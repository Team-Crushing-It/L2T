import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import './finish_screen.dart';

class IncomingCallScreen extends StatelessWidget {
  static const String TAG = "IncomingCallScreen";
  final P2PSession _callSession;

  IncomingCallScreen(this._callSession);

  @override
  Widget build(BuildContext context) {
    //getFirebaseValues();
    _callSession.onSessionClosed = (callSession) {
      log("_onSessionClosed", TAG);
      Navigator.pop(context);
    };

    return MaterialApp(
        home: WillPopScope(
            onWillPop: () => _onBackPressed(context),
            child: Scaffold(
                body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(36),
                    child:
                        Text(_getCallTitle(), style: TextStyle(fontSize: 28)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 36, bottom: 8),
                    child: Text("Members:", style: TextStyle(fontSize: 20)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 86),
                    child: Text(_callSession.opponentsIds.join(", "),
                        style: TextStyle(fontSize: 18)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 36),
                        child: FloatingActionButton(
                          heroTag: "RejectCall",
                          child: Icon(
                            Icons.call_end,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.red,
                          onPressed: () => _rejectCall(context, _callSession),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 36),
                        child: FloatingActionButton(
                          heroTag: "AcceptCall",
                          child: Icon(
                            Icons.call,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.green,
                          onPressed: () => _acceptCall(context, _callSession),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ))));
  }

  _getCallTitle() {
    String callType;

    switch (_callSession.callType) {
      case CallType.VIDEO_CALL:
        callType = "Video";
        break;
      case CallType.AUDIO_CALL:
        callType = "Audio";
        break;
    }

    return "Incoming $callType call";
  }

  void _acceptCall(BuildContext context, P2PSession callSession) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationCallScreen(callSession, true),
      ),
    );
  }

  void _rejectCall(BuildContext context, P2PSession callSession) {
    callSession.reject();
  }

  Future<bool> _onBackPressed(BuildContext context) {
    return Future.value(false);
  }
}

class ConversationCallScreen extends StatefulWidget {
  final P2PSession _callSession;
  final bool _isIncoming;

  @override
  State<StatefulWidget> createState() {
    return _ConversationCallScreenState(_callSession, _isIncoming);
  }

  ConversationCallScreen(this._callSession, this._isIncoming);
}

class _ConversationCallScreenState extends State<ConversationCallScreen>
    implements RTCSessionStateCallback<P2PSession> {
  static const String TAG = "_ConversationCallScreenState";
  P2PSession _callSession;
  bool _isIncoming;
  bool _isCameraEnabled = true;
  bool _isSpeakerEnabled = true;
  bool _isMicMute = false;
  var globalData = [];
  var sentenceItMatchesWith = [];
  var comparingString = "";
  var showvalue = false;
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  Map<int, RTCVideoRenderer> streams = {};

  _ConversationCallScreenState(this._callSession, this._isIncoming);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _listen());

    _speech = stt.SpeechToText();
    _callSession.onLocalStreamReceived = _addLocalMediaStream;
    _callSession.onRemoteStreamReceived = _addRemoteMediaStream;
    _callSession.onSessionClosed = _onSessionClosed;

    _callSession.setSessionCallbacksListener(this);
    if (_isIncoming) {
      _callSession.acceptCall();
    } else {
      _callSession.startCall();
    }
  }

  @override
  void dispose() {
    super.dispose();
    streams.forEach((opponentId, stream) async {
      log("[dispose] dispose renderer for $opponentId", TAG);
      await stream.dispose();
    });
  }

  void _listen() async {
    print("running the thing");
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        print("the aliens are listening");
        await _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print("make that");
            print(_text);
            print(globalData);
            var firebaseList = globalData.toSet().toList();
            var recognizedWords = _text.split(" ");
            for (var sentence in firebaseList) {
              var count = 0;
              for (var a in recognizedWords) {
                if (a.length > 3 && sentence.contains(a)) {
                  count += 1;
                }
              }
              if (count >= 2) {
                sentenceItMatchesWith.add(sentence);
                comparingString = sentence;
              }
            }
            print(sentenceItMatchesWith);
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _addLocalMediaStream(MediaStream stream) {
    log("_addLocalMediaStream", TAG);
    _onStreamAdd(CubeChatConnection.instance.currentUser.id, stream);
  }

  void _addRemoteMediaStream(session, int userId, MediaStream stream) {
    log("_addRemoteMediaStream for user $userId", TAG);
    _onStreamAdd(userId, stream);
  }

  void _removeMediaStream(callSession, int userId) {
    log("_removeMediaStream for user $userId", TAG);
    RTCVideoRenderer videoRenderer = streams[userId];
    if (videoRenderer == null) return;

    videoRenderer.srcObject = null;
    videoRenderer.dispose();

    setState(() {
      streams.remove(userId);
    });
  }

  void _onSessionClosed(session) {
    log("_onSessionClosed", TAG);
    _callSession.removeSessionCallbacksListener();

    Navigator.pop(context);
  }

  void _onStreamAdd(int opponentId, MediaStream stream) async {
    log("_onStreamAdd for user $opponentId", TAG);

    RTCVideoRenderer streamRender = RTCVideoRenderer();
    await streamRender.initialize();
    streamRender.srcObject = stream;
    setState(() => streams[opponentId] = streamRender);
  }

  List<Widget> renderStreamsGrid(Orientation orientation) {
    List<Widget> streamsExpanded = streams.entries
        .map(
          (entry) => Expanded(
            child: RTCVideoView(
              entry.value,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              mirror: true,
            ),
          ),
        )
        .toList();
    if (streams.length > 2) {
      List<Widget> rows = [];

      for (var i = 0; i < streamsExpanded.length; i += 2) {
        var chunkEndIndex = i + 2;

        if (streamsExpanded.length < chunkEndIndex) {
          chunkEndIndex = streamsExpanded.length;
        }

        var chunk = streamsExpanded.sublist(i, chunkEndIndex);

        rows.add(
          Expanded(
            child: Column(children: chunk),
          ),
        );
      }

      return rows;
    }

    return streamsExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Stack(
        children: [
          Scaffold(
              body: _isVideoCall()
                  ? OrientationBuilder(
                      builder: (context, orientation) {
                        return Center(
                          child: Container(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: renderStreamsGrid(orientation)),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 24),
                            child: Text(
                              "Audio call",
                              style: TextStyle(fontSize: 28),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Text(
                              "Members:",
                              style: TextStyle(
                                  fontSize: 20, fontStyle: FontStyle.italic),
                            ),
                          ),
                          Text(
                            _callSession.opponentsIds.join(", "),
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    )),
          Align(
            alignment: Alignment.bottomCenter,
            child: _getActionsPanel(),
          ),
          Material(
            color: Colors.transparent,
            child: Container(
                // color: Colors.transparent,
                width: 300,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    _buildBody(context),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Stack(
                          children: [
                            FlatButton(
                              onPressed: _listen,
                              child: Icon(
                                  _isListening ? Icons.mic : Icons.mic_none),
                            ),
                          ],
                        ))
                  ],
                )),
          )
        ],
      ),
    );
  }

  // _animateToIndex(i) => _listController.animateTo(((hcurrent / 13) - 0.5) * i,
  //     duration: Duration(seconds: 2), curve: Curves.fastOutSlowIn);

  Widget _getActionsPanel() {
    return Container(
      margin: EdgeInsets.only(bottom: 16, left: 150, right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32)),
        child: Container(
          padding: EdgeInsets.all(4),
          color: Colors.black26,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 4),
                child: FloatingActionButton(
                  elevation: 0,
                  heroTag: "Mute",
                  child: Icon(
                    Icons.mic,
                    color: _isMicMute ? Colors.grey : Colors.white,
                  ),
                  onPressed: () => _muteMic(),
                  backgroundColor: Colors.black38,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 4),
                child: FloatingActionButton(
                  elevation: 0,
                  heroTag: "Speacker",
                  child: Icon(
                    Icons.volume_up,
                    color: _isSpeakerEnabled ? Colors.white : Colors.grey,
                  ),
                  onPressed: () => _switchSpeaker(),
                  backgroundColor: Colors.black38,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 4),
                child: FloatingActionButton(
                  elevation: 0,
                  heroTag: "SwitchCamera",
                  child: Icon(
                    Icons.switch_video,
                    color: _isVideoEnabled() ? Colors.white : Colors.grey,
                  ),
                  onPressed: () => _switchCamera(),
                  backgroundColor: Colors.black38,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 4),
                child: FloatingActionButton(
                  elevation: 0,
                  heroTag: "ToggleCamera",
                  child: Icon(
                    Icons.videocam,
                    color: _isVideoEnabled() ? Colors.white : Colors.grey,
                  ),
                  onPressed: () => _toggleCamera(),
                  backgroundColor: Colors.black38,
                ),
              ),
              Expanded(
                child: SizedBox(),
                flex: 1,
              ),
              Padding(
                padding: EdgeInsets.only(left: 0),
                child: FloatingActionButton(
                  child: Icon(
                    Icons.call_end,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.red,
                  onPressed: () => _endCall(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _endCall() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => FinishScreen(),
        fullscreenDialog: true,
      ),
    );

    _callSession.hungUp();
  }

  Future<bool> _onBackPressed(BuildContext context) {
    return Future.value(false);
  }

  _muteMic() {
    setState(() {
      _isMicMute = !_isMicMute;
      _callSession.setMicrophoneMute(_isMicMute);
    });
  }

  _switchCamera() {
    if (!_isVideoEnabled()) return;

    _callSession.switchCamera();
  }

  _toggleCamera() {
    if (!_isVideoCall()) return;

    setState(() {
      _isCameraEnabled = !_isCameraEnabled;
      _callSession.setVideoEnabled(_isCameraEnabled);
    });
  }

  bool _isVideoEnabled() {
    return _isVideoCall() && _isCameraEnabled;
  }

  bool _isVideoCall() {
    return CallType.VIDEO_CALL == _callSession.callType;
  }

  _switchSpeaker() {
    setState(() {
      _isSpeakerEnabled = !_isSpeakerEnabled;
      _callSession.enableSpeakerphone(_isSpeakerEnabled);
    });
  }

  @override
  void onConnectedToUser(P2PSession session, int userId) {
    log("onConnectedToUser userId= $userId");
  }

  @override
  void onConnectionClosedForUser(P2PSession session, int userId) {
    log("onConnectionClosedForUser userId= $userId");
    _removeMediaStream(session, userId);
  }

  @override
  void onDisconnectedFromUser(P2PSession session, int userId) {
    log("onDisconnectedFromUser userId= $userId");
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('baby').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    var tempthingy = snapshot.toList();
    for (var i = 0; i < tempthingy.length; i++) {
      globalData.add(Record.fromSnapshot(tempthingy[i]).name);
    }

    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    //final record = Record.fromMap(data);
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.grey),
        //   borderRadius: BorderRadius.circular(5.0),
        // ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.white24),
                    child: Checkbox(
                      onChanged: null,
                      value: sentenceItMatchesWith.contains(record.name),
                    ),
                  ),
                ),
              ),

              //==============s=================================================
              Flexible(
                flex: 6,
                child: Text(
                  record.name,
                  maxLines: 3,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: comparingString == record.name
                          ? Colors.green
                          : Colors.white24),
                ),
              ),
            ]),
      ),
    );
  }
}

class Record {
  final String name;
  // final int votes;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map(), {this.reference})
      : assert(map()['name'] != null),
        // assert(map()['votes'] != null),
        name = map()['name'];
  // votes = map()['votes'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:>";
}

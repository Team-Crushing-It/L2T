import 'package:flutter/material.dart';
import 'package:rotating_widgets/rotating_widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Rotating Widget Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          height: 520,
          width: MediaQuery.of(context).size.width / 5 * 4,
          child: RotatingWidgetsTest(child: Icon(Icons.thumb_up)),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class RotatingWidgetsTest extends StatefulWidget {
  RotatingWidgetsTest({@required this.child});

  Widget child;

  @override
  _RotatingWidgetsTestState createState() => _RotatingWidgetsTestState();
}

class _RotatingWidgetsTestState extends State<RotatingWidgetsTest> {
  bool boolX;
  bool boolY;
  bool boolZ;
  bool autoplay;
  double _angle;

  @override
  void initState() {
    boolX = true;
    boolY = true;
    boolZ = false;
    autoplay = false;
    _angle = 0.01;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      height: 500.0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: Center(
                child: SizedBox(
                    height: 200.0,
                    width: 200.0,
                    child: RotatingWidget(
                      child: Image.asset(
                        'images/L2TnoBG.png',
                        width: 600,
                        height: 240,
                      ),
                      rotateX: false,
                      rotateY: true,
                      autoplay: true,
                      duration: Duration(milliseconds: 2),
                      rotateZ: false,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

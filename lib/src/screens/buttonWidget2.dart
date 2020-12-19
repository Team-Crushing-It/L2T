import 'package:flutter/material.dart';

Color color = Colors.blue[600];
bool oneSelected = true;
bool twoSelected = true;
bool threeSelected = true;
const Color transparent = Color(0x00000000);

// for every single item in the post array
// build a new element

// when the backend changes, the front-end reacts

class EmojiSection2 extends StatefulWidget {
  @override
  _EmojiSection2State createState() => _EmojiSection2State();
}

Widget box1({width: 150.0, height: 50.0}) => Container(
  width: width,
  height: height,
  color: Colors.green,
);

Widget box2({width: 150.0, height: 50.0}) => Container(
  width: width,
  height: height,
  color: Colors.red,
);

class _EmojiSection2State extends State<EmojiSection2> {
  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: 60,
      width: double.infinity,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              onTap: () {
                print('test');
                print(oneSelected);
                setState(() {
                  oneSelected = !oneSelected;
                });
                print(oneSelected);
              },
              child: Container(
                child: ColorFiltered(
                  colorFilter: oneSelected ? ColorFilter.mode(
                    Colors.transparent,
                    BlendMode.multiply,
                  ) : ColorFilter.mode(
                    Colors.grey,
                    BlendMode.saturation,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      box1(),
                    ],
                  ),
                ),
              ),
            ),
            
            InkWell(
              onTap: () {
                print('test');
                print(twoSelected);
                setState(() {
                  twoSelected = !twoSelected;
                });
                print(twoSelected);
              },
              child: Container(
                child: ColorFiltered(
                  colorFilter: twoSelected ? ColorFilter.mode(
                    Colors.transparent,
                    BlendMode.multiply,
                  ) : ColorFilter.mode(
                    Colors.grey,
                    BlendMode.saturation,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      box2(),
                    ],
                  ),
                ),
              ),
            ),
            
            // Image.asset("images/neutral.png"),
            // Image.asset("images/sad.png"),
          ],
        ),
      ),
    );
  }
}





// Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 InkWell(
//                   // onTap: () {
//                   //   print('test');
//                   //   print(oneSelected);
//                   //   setState(() {
//                   //     oneSelected = !oneSelected;
//                   //   });
//                   //   print(oneSelected);
//                   // },
//                   child: Container(
//                     child: ColorFiltered(
//                       colorFilter: oneSelected ? ColorFilter.mode(
//                         Colors.black,
//                         BlendMode.multiply,
//                       ) : ColorFilter.mode(
//                         Colors.grey,
//                         BlendMode.saturation,
//                       ),
//                       child: Image.asset(
//                         "images/happy.png",
//                       ),
//                     ),
//                   ),
//                 ),
                
//                 InkWell(
//                   // onTap: () {
//                   //   print('test');
//                   //   print(twoSelected);
//                   //   setState(() {
//                   //     twoSelected = !twoSelected;
//                   //   });
//                   //   print(twoSelected);
//                   // },
//                   child: Container(
//                     child: ColorFiltered(
//                       colorFilter: twoSelected ? ColorFilter.mode(
//                         Colors.black,
//                         BlendMode.multiply,
//                       ) : ColorFilter.mode(
//                         Colors.grey,
//                         BlendMode.saturation,
//                       ),
//                       child: Image.asset(
//                         "images/neutral.png",
//                       ),
//                     ),
//                   ),
//                 ),
            
//                   // Image.asset("images/neutral.png"),
//                 // Image.asset("images/sad.png"),
//               ],
//             ),
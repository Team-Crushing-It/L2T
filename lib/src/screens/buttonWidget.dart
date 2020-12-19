import 'package:flutter/material.dart';

Color color = Colors.blue[600];
bool oneSelected = false;
bool twoSelected = false;
bool threeSelected = false;
const Color transparent = Color(0x00000000);

// for every single item in the post array
// build a new element

// when the backend changes, the front-end reacts

class EmojiSection extends StatefulWidget {
  @override
  _EmojiSectionState createState() => _EmojiSectionState();
}

@override
class _EmojiSectionState extends State<EmojiSection> {
  void _selectFunction(int i) {
    switch (i) {
      case 1:
        // change state of 1st
        //  print('test');
        //         print(twoSelected);
        setState(() {
          // turn off the other one
          threeSelected = false;
          twoSelected = false;
          oneSelected = true;
        });
        //         print(twoSelected);
        break;

      case 2:
        // change state of 2nd
        //  print('test');
        //         print(twoSelected);
        setState(() {
          // turn off the other one
          threeSelected = false;
          twoSelected = true;
          oneSelected = false;
        });
        //         print(twoSelected);
        break;

      case 3:
        // change state of 3rd
        //  print('test');
        //         print(twoSelected);
        setState(() {
          // turn off the other one
          threeSelected = true;
          twoSelected = false;
          oneSelected = false;
        });
        //         print(twoSelected);
        break;

      default:
      //make the middle emoji selected
    }
  }

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
                // print('test');
                // print(oneSelected);
                // setState(() {
                //   oneSelected = !oneSelected;
                // });
                // print(oneSelected);
                _selectFunction(1);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: new AssetImage("images/happy.png"),
                    fit: BoxFit.fill,
                    colorFilter: oneSelected
                        ? ColorFilter.mode(
                            Colors.transparent,
                            BlendMode.multiply,
                          )
                        : ColorFilter.mode(
                            Colors.grey,
                            BlendMode.saturation,
                          ),
                  ),
                ),
              ),
            ),

            InkWell(
              onTap: () {
                // print('test');
                // print(twoSelected);
                // setState(() {
                //   twoSelected = !twoSelected;
                // });
                // print(twoSelected);
                _selectFunction(2);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: new AssetImage("images/neutral.png"),
                    fit: BoxFit.fill,
                    colorFilter: twoSelected
                        ? ColorFilter.mode(
                            Colors.transparent,
                            BlendMode.multiply,
                          )
                        : ColorFilter.mode(
                            Colors.grey,
                            BlendMode.saturation,
                          ),
                  ),
                ),
              ),
            ),

            InkWell(
              onTap: () {
                // print('test');
                // print(threeSelected);
                // setState(() {
                //   threeSelected = !threeSelected;
                // });
                // print(threeSelected);
                _selectFunction(3);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: new AssetImage("images/sad.png"),
                    fit: BoxFit.fill,
                    colorFilter: threeSelected
                        ? ColorFilter.mode(
                            Colors.transparent,
                            BlendMode.multiply,
                          )
                        : ColorFilter.mode(
                            Colors.grey,
                            BlendMode.saturation,
                          ),
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
// Widget emojiSection = Container(
//   var isSelected = 0;
//   height: 60,
//   width: double.infinity,
//   child: Center(
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,

//        isSelected = false;
//       children: <Widget>[
//         InkWell(
//           onTap: () {
//             print('test');

//             setState((){
//                 _id = index; //if you want to assign the index somewhere to check
//               });
//               _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("You clicked item number $_id")));
//           },
//           child: Image.asset(
//             "images/happy.png",
//           ),
//         ),
//         InkWell(
//           onTap: () {
//             print('test');
//           },
//           child: Image.asset(
//             "images/neutral.png",
//           ),
//         ),

//         InkWell(
//           onTap: () {
//             print('test');
//           },
//           child: Image.asset(
//             "images/sad.png",
//           ),
//         ),

//         // Image.asset("images/neutral.png"),
//         // Image.asset("images/sad.png"),
//       ],
//     ),
//   ),
// );

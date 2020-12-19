import 'package:flutter/material.dart';

Color color = Colors.blue[600];
bool oneSelected = true;
bool twoSelected = true;
bool threeSelected = true;
const Color transparent = Color(0x00000000);

// for every single item in the post array
// build a new element

// when the backend changes, the front-end reacts

class ExitSection extends StatefulWidget {
  @override
  _ExitSectionState createState() => _ExitSectionState();
}

class _ExitSectionState extends State<ExitSection> {
  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: 50,
      width: double.infinity,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisAlignment: MainAxisAlignment.start,
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
                  child: Image.asset(
                    "images/exit.png", width: 100.0, height: 100.0,
                  ),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'buttonWidget2.dart';

bool oneSelected = true;
bool twoSelected = true;
bool threeSelected = true;

Widget infoSection = Container(
  height: 170,
  width: 390,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Tokens',
                  style: new TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                Text(''),
                Text('12'),
                Text(
                  '-1',
                  style: new TextStyle(
                    fontSize: 15.0,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            EmojiSection2(),
          ],
        ),
      ),
    ],
  ),
);

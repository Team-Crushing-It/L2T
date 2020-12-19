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
                Text('Curent Tokens'),
                Text(''),
                Text('12'),
                Text('-1'),
              ],
            ),
            EmojiSection2(),
          ],
        ),
      ),
    ],
  ),
);
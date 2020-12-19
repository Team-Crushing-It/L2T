import 'package:flutter/material.dart';
Widget textSection = Container(
  height: 200,
  width: 202,
  margin: const EdgeInsets.only(right: 0, left: 0),
  padding: const EdgeInsets.all(10.0),
  alignment: Alignment.center,
  decoration: BoxDecoration(
    border: Border.all(color: Colors.black)
  ),
  child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Next Lesson'),
                Text(''),
                Text('Managing State'),
                Text(''),
                Text("+ Deeper understanding of how setState() works"),
                Text("+ What BLoC architecture looks like"),
              ],
            ),
          ],
        ), 
);
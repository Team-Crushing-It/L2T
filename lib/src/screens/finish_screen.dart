import 'package:flutter/material.dart';
import 'buttonWidget.dart';
import 'infoWidget.dart';
import 'exitWidget.dart';
import 'textBox.dart';

class FinishScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Flutter layout demo'),
        // ),
        body: Column(
      children: [
        ExitSection(),
        Text('How did the interaction go?'),
        Text(' '),
        EmojiSection(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  infoSection,
                  textSection,
                ],
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

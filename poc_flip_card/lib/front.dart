import 'package:flutter/material.dart';
import 'package:poc_flip_card/main.dart';

class Front extends StatelessWidget {
  const Front({super.key, this.index});

  final int? index;

  @override
  Widget build(BuildContext context) {
    return CustomHeroTransition(
        tag: 'container$index',
        index: index,
        isFlipped: false,
        child: Scaffold(
          body: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(
                color: Colors.black,
                width: 3.0,
              ),),
              alignment: Alignment.center,
              child: Text('front $index')),
        ));
  }
}

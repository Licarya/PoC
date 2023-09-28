import 'package:flutter/material.dart';
import 'package:poc_flip_card/main.dart';

class Back extends StatelessWidget {
  const Back({super.key, this.index});

  final int? index;

  @override
  Widget build(BuildContext context) {
    return CustomHeroTransition(
      tag: 'container$index',
      index: index,
      isFlipped: true,
      child:Scaffold(
        body:  Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Spacer(),
                  Text('back $index'),
                  SizedBox(height: 30,),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: BoxDecoration(
                    color: Colors.amber,
                    border: Border.all(
                      color: Colors.black,
                      width: 3.0,
                    ),),
                  child: Text('Ceci est la description du block $index'),),
                  Spacer()
                ],
              )),
          ),
        );
  }
}

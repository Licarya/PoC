import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:poc_flip_card/back.dart';
import 'package:poc_flip_card/front.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedContainerDemo(),
    );
  }
}

class AnimatedContainerDemo extends StatefulWidget {
  @override
  _AnimatedContainerDemoState createState() => _AnimatedContainerDemoState();
}

class _AnimatedContainerDemoState extends State<AnimatedContainerDemo> {
  int? selectedContainerIndex;
  bool isFlipped = false;

  @override
  Widget build(BuildContext context) {
    timeDilation = 3.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation de conteneur Flutter'),
      ),
      body: Stack(
        children: [
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
            ),
            itemCount: 6,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (!isFlipped) {
                        isFlipped = true;
                        selectedContainerIndex = index;

                        if (selectedContainerIndex != null) {
                          Navigator.of(context).push(MaterialPageRoute<void>(
                              builder: (BuildContext context) {
                            return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedContainerIndex = null;
                                    isFlipped = !isFlipped;
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: Back(
                                  index: selectedContainerIndex,
                                ));
                          }));
                        }
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Front(
                      index: index,
                    ),
                  ));
            },
          ),
        ],
      ),
    );
  }
}

class CustomHeroTransition extends StatelessWidget {
  final String tag;
  final Widget child;
  final int? index;
  final bool isFlipped;

  const CustomHeroTransition(
      {super.key, required this.tag,
      required this.child,
      required this.index,
      required this.isFlipped});


  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        final bool isPush = flightDirection == HeroFlightDirection.push;
        final double rotateOnY =  isFlipped ? isPush ? pi : 0 : pi;

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateY(rotateOnY * animation.value),
              alignment: Alignment.center,
              child: isPush
                  ? Transform.scale(
                scaleX: -1,
                    child: Back(
                        index: index,
                      ),
                  )
                  : child,
            );
          },
          child: child,
        );
      },
      child: child,
    );
  }
}

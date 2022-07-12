import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dart_design_pattern_example/abstract_factory/abstract_factory.dart';
import 'package:flutter_dart_design_pattern_example/product/normal_button.dart';

abstract class Shape {
  Shape(this.color);
  late Color color;
  Shape.clone(Shape source) {
    color = source.color;
  }

  Shape clone();
  void randomAttribute();
  Widget render();
}

class Circle extends Shape {
  late double radius;

  Circle.initial() : super(Colors.black) {
    radius = 50.0;
  }

  Circle.clone(Circle source) : super.clone(source) {
    radius = source.radius;
  }

  @override
  Shape clone() {
    return Circle.clone(this);
  }

  @override
  void randomAttribute() {
    color = Color.fromARGB(
        Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1);
    radius = Random().nextInt(50).toDouble();
  }

  @override
  Widget render() {
    return SizedBox(
      height: 120.0,
      child: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: 2 * radius,
          width: 2 * radius,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(
            Icons.star,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class Rectangle extends Shape {
  late double height;
  late double width;

  Rectangle.initial() : super(Colors.black) {
    height = 120.0;
    width = 120.0;
  }

  Rectangle.clone(Rectangle source) : super.clone(source) {
    height = source.height;
    width = source.height;
  }

  @override
  Shape clone() {
    return Rectangle.clone(this);
  }

  @override
  void randomAttribute() {
    color = Color.fromARGB(
        Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1);
    height = Random().nextInt(120).toDouble();
    width = Random().nextInt(120).toDouble();
  }

  @override
  Widget render() {
    return SizedBox(
      height: 120.0,
      child: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
          ),
          child: Icon(
            Icons.star,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class PrototypeView extends StatefulWidget {
  const PrototypeView({Key? key}) : super(key: key);

  @override
  State<PrototypeView> createState() => _PrototypeViewState();
}

class _PrototypeViewState extends State<PrototypeView> {
  Shape _circle = Circle.initial();
  Shape _rectangle = Rectangle.initial();

  Shape? _circleClone;
  Shape? _rectangleClone;

  void _circleRandomAttribute() {
    setState(() {
      _circle.randomAttribute();
    });
  }

  void _rectangleRandomAttribute() {
    setState(() {
      _rectangle.randomAttribute();
    });
  }

  void _circleCloned() {
    setState(() {
      _circleClone = _circle.clone();
    });
  }

  void _rectangleCloned() {
    setState(() {
      _rectangleClone = _rectangle.clone();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(children: [
                Text("Initial"),
                Expanded(
                  child: _circle.render(),
                ),
              ]),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Cloned"),
                _circleClone == null
                    ? SizedBox(
                        height: 50,
                        width: 50,
                        child: Placeholder(),
                      )
                    : _circleClone!.render(),
              ])
            ],
          )),
          FittedBox(
            child: Row(
              children: [
                NormalButton(
                  text: "Set Attribute",
                  materialColor: Colors.black,
                  materialTextColor: Colors.white,
                  onPressed: _circleRandomAttribute,
                ),
                NormalButton(
                  text: "Clone",
                  materialColor: Colors.black,
                  materialTextColor: Colors.white,
                  onPressed: _circleCloned,
                ),
              ],
            ),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(children: [
                Text("Initial"),
                Expanded(
                  child: _rectangle.render(),
                ),
              ]),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Cloned"),
                _rectangleClone == null
                    ? SizedBox(
                        height: 50,
                        width: 50,
                        child: Placeholder(),
                      )
                    : _rectangleClone!.render(),
              ])
            ],
          )),
          FittedBox(
            child: Row(
              children: [
                NormalButton(
                  text: "Set Attribute",
                  materialColor: Colors.black,
                  materialTextColor: Colors.white,
                  onPressed: _rectangleRandomAttribute,
                ),
                NormalButton(
                  text: "Clone",
                  materialColor: Colors.black,
                  materialTextColor: Colors.white,
                  onPressed: _rectangleCloned,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

import 'package:logger/logger.dart';

abstract class Shape {
  void draw();
}

class Rectangle extends Shape {
  @override
  void draw() {
    Logger().d("Rectang is drawed");
  }
}

class Square extends Shape {
  @override
  void draw() {
    Logger().d("Square is drawed");
  }
}

class Circle extends Shape {
  @override
  void draw() {
    Logger().d("Circle is drawed");
  }
}

class ShapeFactory {
  Shape? getShape(String text) {
    if (text.toLowerCase() == "rectangle") {
      return Rectangle();
    }
    if (text.toLowerCase() == "square") {
      return Square();
    }
    if (text.toLowerCase() == "circle") {
      return Circle();
    }
    return null;
  }
}

void main(List<String> args) {
  Shape? circle = ShapeFactory().getShape("Circle");
  Shape? rectangle = ShapeFactory().getShape("Rectangle");
  Shape? square = ShapeFactory().getShape("Square");

  if (circle != null) {
    circle.draw();
  }

  if (square != null) {
    square.draw();
  }

  if (rectangle != null) {
    rectangle.draw();
  }
}

import 'package:logger/logger.dart';

enum BoxColor { Black, Blue }

abstract class Box {
  late int width;
  late int height;

  late BoxColor boxColor;
  void draw(int locX, int locY);
}

class BlueBox extends Box {
  BlueBox(int width, int height) {
    this.width = width;
    this.height = height;
    this.boxColor = BoxColor.Blue;
  }
  @override
  void draw(int locX, int locY) {
    Logger().d("${boxColor.name} box drawn ${locX},${locY}");
  }
}

class BlackBox extends Box {
  BlackBox(int width, int height) {
    this.width = width;
    this.height = height;
    this.boxColor = BoxColor.Black;
  }
  @override
  void draw(int locX, int locY) {
    Logger().d("${boxColor.name} box drawn ${locX},${locY}");
  }
}

class BoxFactory {
  late Map<BoxColor, Box> _boxes;
  BoxFactory() {
    _boxes = Map<BoxColor, Box>();
  }

  Box getBox(BoxColor boxColor) {
    if (_boxes.containsKey(boxColor)) {
      return _boxes[boxColor]!;
    }

    Box? box;

    if (boxColor == BoxColor.Black) {
      box = BlackBox(30, 30);
    } else {
      box = BlueBox(20, 20);
    }

    _boxes[boxColor] = box;
    return box;
  }
}

void main(List<String> args) {
  BoxFactory boxFactory = BoxFactory();

  Box blackBox1 = boxFactory.getBox(BoxColor.Black);
  Box blackBox2 = boxFactory.getBox(BoxColor.Black);
  Box blackBox3 = boxFactory.getBox(BoxColor.Blue);
  Box blackBox4 = boxFactory.getBox(BoxColor.Blue);
  blackBox1.draw(30, 30);
  blackBox2.draw(20, 20);
  blackBox3.draw(40, 40);
  blackBox4.draw(50, 50);
}

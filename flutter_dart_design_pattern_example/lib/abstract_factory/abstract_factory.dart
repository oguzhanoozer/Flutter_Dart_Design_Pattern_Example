import 'dart:io';

import 'package:logger/logger.dart';

abstract class Button {
  void paint();
}

abstract class Label {
  void paint();
}

abstract class GUIFactory {
  Button button();
  Label label();
}

class AndroidButton extends Button {
  void paint() {
    Logger().d("Android Button Clicked");
  }
}

class IOSButton extends Button {
  void paint() {
    Logger().d("IOS Button Clicked");
  }
}

class AndroidLabel extends Label {
  void paint() {
    Logger().d("Android Label Printed");
  }
}

class IOSLabel extends Label {
  void paint() {
    Logger().d("IOS Label Printed");
  }
}

class AndroidFactory extends GUIFactory {
  @override
  Button button() {
    return AndroidButton();
  }

  @override
  Label label() {
    return AndroidLabel();
  }
}

class IOSFactory extends GUIFactory {
  @override
  Button button() {
    return IOSButton();
  }

  @override
  Label label() {
    return IOSLabel();
  }
}

class Application {
  Application(GUIFactory factory) {
    Button button = factory.button();
    Label label = factory.label();
    button.paint();
    label.paint();
  }
}

void main(List<String> args) {
  Application(Platform.isAndroid?AndroidFactory():IOSFactory());
}

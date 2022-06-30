import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dart_design_pattern_example/abstract_factory/abstract_factory.dart';
import 'package:kartal/kartal.dart';

import 'factory_selection.dart';

abstract class ISlider {
  Widget render(double value, ValueSetter<double> onChanged);
}

abstract class IActivityIndicator {
  Widget render();
}

abstract class IWidgetFactory {
  String getTitle();
  ISlider createSlider();
  IActivityIndicator createIndicator();
}

class AndroidIndicator extends IActivityIndicator {
  @override
  Widget render() {
    return CircularProgressIndicator();
  }
}

class IOSActivityIndicator extends IActivityIndicator {
  @override
  Widget render() {
    return CupertinoActivityIndicator();
  }
}

class AndroidSlider extends ISlider {
  @override
  Widget render(double value, ValueSetter<double> onChanged) {
    return Slider(
      value: value,
      max: 100,
      min: 0,
      onChanged: onChanged,
      activeColor: Colors.black,
      inactiveColor: Colors.grey,
    );
  }
}

class IOSSlider extends ISlider {
  @override
  Widget render(double value, ValueSetter<double> onChanged) {
    return CupertinoSlider(
      value: value,
      max: 100,
      min: 0,
      onChanged: onChanged,
    );
  }
}

class MaterialWidgetFactory extends IWidgetFactory {
  @override
  IActivityIndicator createIndicator() {
    return AndroidIndicator();
  }

  @override
  ISlider createSlider() {
    return AndroidSlider();
  }

  @override
  String getTitle() {
    return "Android Widgets";
  }
}

class CupertinoWidgetFactory extends IWidgetFactory {
  @override
  IActivityIndicator createIndicator() {
    return IOSActivityIndicator();
  }

  @override
  ISlider createSlider() {
    return IOSSlider();
  }

  @override
  String getTitle() {
    return "IOS Widgets";
  }
}

class AbstractFactoryView extends StatefulWidget {
  const AbstractFactoryView({Key? key}) : super(key: key);

  @override
  State<AbstractFactoryView> createState() => _AbstractFactoryViewState();
}

class _AbstractFactoryViewState extends State<AbstractFactoryView> {
  List<IWidgetFactory> _widgetsFactoryList = [MaterialWidgetFactory(), CupertinoWidgetFactory()];

  int _selectedIndex = 0;
  double _sliderValue = 50.0;
  String get _sliderValueString => _sliderValue.toStringAsFixed(0);

  late ISlider slider;
  late IActivityIndicator activityIndicator;
  late String widgetText;

  @override
  void initState() {
    _createWidget();
  }

  void _createWidget() {
    slider = _widgetsFactoryList[_selectedIndex].createSlider();
    activityIndicator = _widgetsFactoryList[_selectedIndex].createIndicator();
    widgetText = _widgetsFactoryList[_selectedIndex].getTitle();
  }

  void _setSliderValue(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  void _setSelectedFactoryIndex(int? index) {
    setState(() {
      _selectedIndex = index!;
      _createWidget();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FactorySelection(
          widgetFactoryList: _widgetsFactoryList,
          selectedIndex: _selectedIndex,
          onChanged: _setSelectedFactoryIndex,
        ),
        context.emptySizedHeightBoxLow,
        Text(widgetText),
        context.emptySizedHeightBoxLow,
        activityIndicator.render(),
        context.emptySizedHeightBoxLow,
        slider.render(_sliderValue, _setSliderValue)
      ],
    );
  }
}

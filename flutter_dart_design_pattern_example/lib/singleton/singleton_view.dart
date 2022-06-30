import 'package:flutter/material.dart';
import 'package:flutter_dart_design_pattern_example/product/normal_button.dart';
import 'package:kartal/kartal.dart';

abstract class StateBase {
  @protected
  late String stateText;
  @protected
  late String initialText;
  String get currentText => stateText;

  void setStateText(String text) {
    stateText = text;
  }

  void reset() {
    stateText = initialText;
  }
}

class StateBaseLazyLoading extends StateBase {
  static StateBaseLazyLoading? _instance;

  StateBaseLazyLoading._init() {
    initialText = "a new StateBaseLazyLoading has been created";
    stateText = initialText;
  }

  static StateBaseLazyLoading getInstance() {
    _instance ??= StateBaseLazyLoading._init();
    return _instance!;
  }
}

class StateBaseFactory extends StateBase {
  static StateBaseFactory _instance = StateBaseFactory._init();

  StateBaseFactory._init() {
    initialText = "a new StateBaseFactory has been created";
    stateText = initialText;
  }

  factory StateBaseFactory() {
    return _instance;
  }
}

class StateBaseWithoutSingleton extends StateBase {
  StateBaseWithoutSingleton() {
    initialText = "a new StateBaseConstructor has been created";
    stateText = initialText;
  }
}

class SingletonView extends StatefulWidget {
  SingletonView({Key? key}) : super(key: key);

  @override
  State<SingletonView> createState() => _SingletonViewState();
}

class _SingletonViewState extends State<SingletonView> {
  List<StateBase> stateBaseList = [StateBaseLazyLoading.getInstance(), StateBaseFactory(), StateBaseWithoutSingleton()];

  void _setStateText([String text = "Singleton"]) {
    for (var state in stateBaseList) {
      state.setStateText(text);
    }
    setState(() {});
  }

  void _resetStateText() {
    for (var state in stateBaseList) {
      state.reset();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var state in stateBaseList)
            Card(
              child: Text(state.currentText),
            ),
          context.emptySizedHeightBoxLow,
          NormalButton(
            materialColor: Colors.black,
            materialTextColor: Colors.white,
            onPressed: _setStateText,
            text: "Change states' text to 'Singleton'",
          ),
          context.emptySizedHeightBoxLow,
          NormalButton(
            materialColor: Colors.black,
            materialTextColor: Colors.white,
            onPressed: _resetStateText,
            text: 'Reset',
          ),
        ],
      ),
    ));
  }
}

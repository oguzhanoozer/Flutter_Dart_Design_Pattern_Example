import 'package:flutter/material.dart';
import 'package:flutter_dart_design_pattern_example/proxy/proxy_view.dart';

import 'abstract_factory/abstract_factory_view.dart';
import 'bridge/bridge_view.dart';
import 'builder/builder_view.dart';
import 'chain_of_responsibility/chain_of_responsibility_view.dart';
import 'command/command_view.dart';
import 'composit/composit_view.dart';
import 'decorator/decorator_view.dart';
import 'facade/facade_view.dart';
import 'factory/factory_view.dart';
import 'flyweight/flyweight_view.dart';
import 'interpreter/interpreter_view.dart';
import 'mediator/mediator_view.dart';
import 'prototype/prototype_view.dart';
import 'singleton/singleton_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Material App Bar'),
          ),
          body: MediatorView()),
    );
  }
}

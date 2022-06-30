import 'package:flutter/material.dart';

import 'abstract_factory/abstract_factory_view.dart';
import 'factory/factory_view.dart';
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
          body: AbstractFactoryView()),
    );
  }
}

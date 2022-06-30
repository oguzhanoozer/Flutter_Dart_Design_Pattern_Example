import 'package:flutter/material.dart';
import 'package:flutter_dart_design_pattern_example/factory/factory_view.dart';

import 'abstract_factory_view.dart';

class FactorySelection extends StatelessWidget {
  final List<IWidgetFactory> widgetFactoryList;
  final int selectedIndex;
  final ValueSetter<int?> onChanged;

  const FactorySelection({Key? key, required this.widgetFactoryList, required this.selectedIndex, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        for (int i = 0; i < widgetFactoryList.length; i++)
          RadioListTile(
              title: Text(widgetFactoryList[i].getTitle()),
              selected: i == selectedIndex,
              activeColor: Colors.black,
              controlAffinity: ListTileControlAffinity.platform,
              value: i,
              groupValue: selectedIndex,
              onChanged: onChanged)
      ],
    ));
  }
}

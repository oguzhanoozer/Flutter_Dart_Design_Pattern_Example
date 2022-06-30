import 'package:flutter/material.dart';
import 'package:flutter_dart_design_pattern_example/factory/factory_view.dart';

class DialogSelection extends StatelessWidget {
  final List<CustomDialog> customDialogList;
  final int selectedIndex;
  final ValueSetter<int?> onChanged;

  const DialogSelection({Key? key, required this.customDialogList, required this.selectedIndex, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
     
      children: [
        for (int i = 0; i < customDialogList.length; i++)
          RadioListTile(
              title: Text(customDialogList[i].getTitle()),
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

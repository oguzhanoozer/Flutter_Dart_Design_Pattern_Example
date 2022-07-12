import 'package:flutter/material.dart';

import 'builder_view.dart';

class BuilderSelection extends StatelessWidget {
  final List<StudentBuilder> studentBuilderList;
  final int selectedIndex;
  final ValueSetter<int?> onChanged;

  const BuilderSelection(
      {Key? key,
      required this.studentBuilderList,
      required this.selectedIndex,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        for (int i = 0; i < studentBuilderList.length; i++)
          RadioListTile(
              title: Text(studentBuilderList[i].getStudentName()),
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

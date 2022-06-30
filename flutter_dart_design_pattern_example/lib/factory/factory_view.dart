import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dart_design_pattern_example/factory/dialog_selection.dart';
import 'package:flutter_dart_design_pattern_example/product/normal_button.dart';

abstract class CustomDialog {
  String getTitle();
  Widget create(BuildContext context);
  Future<void> show(BuildContext context) {
    var dialog = create(context);

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return dialog;
        });
  }
}

class AndroidDialog extends CustomDialog {
  @override
  Widget create(BuildContext context) {
    return AlertDialog(
      title: Text(getTitle()),
      content: Text("Material Style Alert Dialog"),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Close"))
      ],
    );
  }

  @override
  String getTitle() {
    return "Android Dialog";
  }
}

class IOSDialog extends CustomDialog {
  @override
  Widget create(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(getTitle()),
      content: Text("Cupertino Style Alert Dialog"),
      actions: [
        CupertinoButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Close"))
      ],
    );
  }

  @override
  String getTitle() {
    return "IOS Dialog";
  }
}

class FactoryView extends StatefulWidget {
  FactoryView({Key? key}) : super(key: key);

  @override
  State<FactoryView> createState() => _FactoryViewState();
}

class _FactoryViewState extends State<FactoryView> {
  List<CustomDialog> _customDialogList = [
    AndroidDialog(),
    IOSDialog(),
  ];

  int _currentSelectedOption = 0;

  void _showCustomDialog(BuildContext context) async {
    var _customDialog = _customDialogList[_currentSelectedOption];
    await _customDialog.show(context);
  }

  void _changeSelecetedOption(int? index) {
    _currentSelectedOption = index!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DialogSelection(
            customDialogList: _customDialogList,
            selectedIndex: _currentSelectedOption,
            onChanged: _changeSelecetedOption,
          ),
          NormalButton(
            materialColor: Colors.black,
            materialTextColor: Colors.white,
            onPressed: () => _showCustomDialog(context),
            text: 'Show Dialog',
          )
        ],
      ),
    );
  }
}

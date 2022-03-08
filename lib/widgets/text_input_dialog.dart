import 'package:flutter/material.dart';
import 'package:tracenow/services/firebase_db.dart';
import 'package:tracenow/widgets/snackbar.dart';

class GlobalTextBox {
  final TextEditingController _textFieldController = TextEditingController();
  void show(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter the code'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "Enter the code"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  _textFieldController.clear();
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text('CONFIRM'),
                onPressed: () async {
                  if (_textFieldController.text.trim().isNotEmpty) {
                    FocusScope.of(context).unfocus();
                    String status =
                        await FirebaseDatabase().uploadLog(_textFieldController.text.toString());
                    Navigator.pop(context);
                    GlobalSnackBar().show(context, status);
                  }
                },
              ),
            ],
          );
        });
  }
}

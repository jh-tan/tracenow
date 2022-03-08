import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tracenow/widgets/snackbar.dart';

class GlobalDialogBox {
  void show(BuildContext context, String message, fun) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Report status'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // dismiss dialog
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () async {
                      // updateReportStatus();
                      fun();
                      Navigator.of(context).pop(); // dismiss dialog
                      GlobalSnackBar().show(context, "Updated");
                    },
                    child: const Text('Agree'))
              ],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ));
  }
}

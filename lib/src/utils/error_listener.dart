import 'package:flutter/material.dart';

MvvmErrorListener defaultErrorListener = MvvmErrorListener();

class MvvmErrorListener {
  void handleErrorMessage(BuildContext ctx, String errorMessage) {
    showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
}
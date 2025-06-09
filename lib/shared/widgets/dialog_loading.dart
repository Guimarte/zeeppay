import 'package:flutter/material.dart';

Future<dynamic> dialogLoading(
  BuildContext context,
  ThemeData theme,
  Widget content,
) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return content;
    },
  );
}

import 'package:ensala_mais/utils/project_colors.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  const ErrorDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Erro!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(message),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: ButtonStyle(
              overlayColor: WidgetStatePropertyAll(
                  ProjectColors().errorButtonForegroundColor),
              foregroundColor:
                  WidgetStatePropertyAll(ProjectColors().buttonTextColor)),
          child: const Text('Confirmar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
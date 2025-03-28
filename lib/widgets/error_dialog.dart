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
              overlayColor:
                  WidgetStatePropertyAll(Color.fromARGB(255, 204, 225, 192)),
              foregroundColor: WidgetStatePropertyAll(Color(0xFF50713c))),
          child: const Text('Confirmar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

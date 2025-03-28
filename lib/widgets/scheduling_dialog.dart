import 'package:flutter/material.dart';

class SchedulingDialog extends StatelessWidget {
  final DateTime selectedDay;
  const SchedulingDialog({super.key, required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Erro!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(selectedDay.toString()),
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

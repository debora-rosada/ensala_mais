import 'package:ensala_mais/utils/project_colors.dart';
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
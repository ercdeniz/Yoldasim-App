import 'package:flutter/material.dart';
import 'package:yoldasim_app/core/extensions/snackbar_extentions.dart';

typedef BinaryUpdateCallback = Future<String?> Function(bool value);

class BinaryUpdateDialog extends StatelessWidget {
  final String question;
  final String positiveLabel;
  final String negativeLabel;
  final String errorMessagePrefix;
  final BinaryUpdateCallback onSave;

  const BinaryUpdateDialog({
    super.key,
    required this.question,
    required this.positiveLabel,
    required this.negativeLabel,
    required this.errorMessagePrefix,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Text(
        question,
        textAlign: TextAlign.center,
        style: TextStyle(color: colorScheme.onSurface),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () => _save(context, false),
          child: Text(negativeLabel),
        ),
        FilledButton(
          onPressed: () => _save(context, true),
          child: Text(positiveLabel),
        ),
      ],
    );
  }

  Future<void> _save(BuildContext context, bool value) async {
    final error = await onSave(value);
    if (error != null) {
      '$errorMessagePrefix$error'.errorSnackbar();
    }
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
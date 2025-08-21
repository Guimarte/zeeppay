import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showDialogConfirm(BuildContext context, {String? message}) {
  showDialog(
    context: context,
    barrierDismissible: false, // Impede fechar ao clicar fora
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.2,
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 20),
                    Flexible(
                      child: Text(
                        message ?? 'Realizado com sucesso!',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => context.pop(), // cancela
                      child: const Text('Ok'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

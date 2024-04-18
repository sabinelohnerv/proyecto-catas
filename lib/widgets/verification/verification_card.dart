import 'package:catas_univalle/view_models/verification_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerificationCard extends StatelessWidget {
  const VerificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<VerificationViewModel>(context, listen: false);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Por favor, revisa tu correo y sigue las instrucciones para confirmar tu cuenta.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () async {
              bool success = await model.resendEmailVerification();
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Se ha reenviado el correo de verificación."),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Error al enviar el correo de verificación.."),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Reenviar correo de verificación'),
          ),
        ],
      ),
    );
  }
}

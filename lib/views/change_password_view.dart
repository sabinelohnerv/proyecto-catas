import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/change_password_viewmodel.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ChangePasswordViewModel>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    InputDecoration _buildInputDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: colorScheme.primaryContainer),
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 186, 94, 91)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              width: 2, color: Color.fromARGB(255, 197, 91, 88)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.white,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cambiar Contraseña",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: colorScheme.primary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: viewModel.setCurrentPassword,
              obscureText: true,
              decoration: _buildInputDecoration('Contraseña actual'),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: viewModel.setNewPassword,
              obscureText: true,
              decoration: _buildInputDecoration('Nueva Contraseña'),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: viewModel.setConfirmPassword,
              obscureText: true,
              decoration: _buildInputDecoration('Confirmar Nueva Contraseña'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (await viewModel.changePassword()) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Contraseña cambiada con éxito',
                          style: TextStyle(color: colorScheme.onPrimary)),
                      backgroundColor: colorScheme.primary,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al cambiar la contraseña',
                          style: TextStyle(color: colorScheme.onError)),
                      backgroundColor: const Color.fromARGB(255, 197, 91, 88),
                    ),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(colorScheme.primary),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text('Cambiar Contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}

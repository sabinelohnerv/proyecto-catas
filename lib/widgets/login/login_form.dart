import 'package:catas_univalle/view_models/login_viewmodel.dart';
import 'package:catas_univalle/views/home_view.dart';
import 'package:catas_univalle/views/register_view.dart';
import 'package:catas_univalle/widgets/login/animations.dart';
import 'package:catas_univalle/widgets/login/decorative_shape_widget.dart';
import 'package:flutter/material.dart';



class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _viewModel = LoginViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: [
            Positioned(
              right: -70,
              top: 10,
              child: DecorativeShapeWidget(
                size: 200,
                color: Theme.of(context).colorScheme.primary,
                shadowColor: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 250),
                  const FadeInAnimation(
                    delay: 100,
                    child: Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const FadeInAnimation(
                    delay: 200,
                    child: Text(
                      'Por favor haz login para continuar.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeInAnimation(
                    delay: 300,
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Correo',
                        prefixIcon: Icon(Icons.email, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInAnimation(
                    delay: 400,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeInAnimation(
                    delay: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final success = await _viewModel.login(
                              _emailController.text,
                              _passwordController.text,
                            );
                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const HomeView()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Inicio de sesión fallido')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 10),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Iniciar Sesión',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 28),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 150),
                  FadeInAnimation(
                    delay: 600,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterView()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              const TextSpan(text: '¿No tienes una cuenta? '),
                              TextSpan(
                                text: '¡Créala!',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

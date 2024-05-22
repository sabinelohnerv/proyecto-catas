import 'package:catas_univalle/view_models/login_viewmodel.dart';
import 'package:catas_univalle/views/register_view.dart';
import 'package:catas_univalle/widgets/login/animations.dart';
import 'package:catas_univalle/widgets/login/login_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../widgets/login/decorative_shape_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _viewModel = LoginViewModel();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.5,
            width: double.infinity,
            child: Stack(
              children: [
                CustomPaint(
                  painter: HeaderShapePainter(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'FoodSense',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const FadeInAnimation(
                      delay: 100,
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Bienvenido de nuevo',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Coloca tus datos',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    FadeInAnimation(
                      delay: 300,
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Correo',
                          prefixIcon: Icon(Icons.email, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInAnimation(
                      delay: 400,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Contraseña',
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    FadeInAnimation(
                      delay: 500,
                      child: Center(
                        child: LoginButton(
                            emailController: _emailController,
                            passwordController: _passwordController,
                            viewModel: _viewModel),
                      ),
                    ),
                    const SizedBox(height: 40),
                    FadeInAnimation(
                      delay: 600,
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            text: '¿No tienes una cuenta? ',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat',
                            ),
                            children: [
                              TextSpan(
                                text: 'Regístrate',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterView()),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:catas_univalle/views/verification_view.dart';
import 'package:flutter/material.dart';
import 'package:catas_univalle/models/judge.dart';
import 'package:catas_univalle/view_models/register_viewmodel.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _viewModel = RegisterViewModel();

  String fullName = '';
  String email = '';
  String password = '';
  String birthDate = '';
  String gender = 'm';
  String dislikes = '';
  List<String> symptoms = [];
  bool smokes = false;
  int cigarettesPerDay = 0;
  String coffee = 'No';
  int coffeeCupsPerDay = 0;
  String llajua = 'No';
  int llajuaPerDay = 0;
  List<String> seasonings = [];
  int sugarInDrinks = 0;
  List<String> allergies = [];
  String comment = '';

  final TextEditingController _birthDateController = TextEditingController();

  void updateListField(List<String> field, String value, bool checked) {
    setState(() {
      if (checked) {
        field.add(value);
      } else {
        field.remove(value);
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      final String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      setState(() {
        _birthDateController.text = formattedDate;
        birthDate = formattedDate;
      });
    }
  }

  @override
  void dispose() {
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Nombre Completo'),
                  onSaved: (value) => fullName = value ?? '',
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio.' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  onSaved: (value) => email = value ?? '',
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio.' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  onSaved: (value) => password = value ?? '',
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio.' : null,
                ),
                TextFormField(
                  controller: _birthDateController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de Nacimiento',
                  ),
                  readOnly: true,
                  onTap: () {
                    _selectDate(context);
                  },
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio.' : null,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Sexo:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Flexible(
                      child: RadioListTile<String>(
                        title: const Text('M'),
                        value: 'm',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() => gender = value!);
                        },
                      ),
                    ),
                    Flexible(
                      child: RadioListTile<String>(
                        title: const Text('F'),
                        value: 'f',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() => gender = value!);
                        },
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Alimentos que le disgustan'),
                  onSaved: (value) => dislikes = value ?? '',
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Comentarios adicionales'),
                  onSaved: (value) => comment = value ?? '',
                  maxLines: null,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: _register,
                    child: const Text('Enviar Formulario'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Judge newJudge = Judge(
        fullName: fullName,
        email: email,
        birthDate: birthDate,
        gender: gender,
        dislikes: dislikes,
        symptoms: symptoms,
        smokes: smokes,
        cigarettesPerDay: cigarettesPerDay,
        coffee: coffee,
        coffeeCupsPerDay: coffeeCupsPerDay,
        llajua: llajua,
        llajuaPerDay: llajuaPerDay,
        seasonings: seasonings,
        sugarInDrinks: sugarInDrinks,
        allergies: allergies,
        comment: comment,
        applicationState: 'PENDING',
      );
      _viewModel.register(newJudge, password).then((success) {
        if (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const VerificationView()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error en el registro.')));
        }
      });
    }
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:catas_univalle/models/judge.dart';
import 'package:catas_univalle/widgets/register/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/views/verification_view.dart';
import 'package:catas_univalle/widgets/register/have_an_account.dart';
import 'package:catas_univalle/view_models/register_viewmodel.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  File? selectedImage;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isValidEmail(String value) {
    if (value.contains('@')) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de Usuario',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  UserImagePicker(
                    onPickImage: (pickedImage) {
                      setState(() {
                        selectedImage = pickedImage;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Nombre Completo',
                          border: OutlineInputBorder()),
                      onSaved: (value) => viewModel.fullName = value ?? '',
                      validator: (value) =>
                          value!.isEmpty ? 'Este campo es obligatorio.' : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Email', border: OutlineInputBorder()),
                      onSaved: (value) => viewModel.email = value ?? '',
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if ((value == null ||
                            value.trim().isEmpty ||
                            !isValidEmail(value))) {
                          return 'Ingresa un email válido.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          border: OutlineInputBorder()),
                      obscureText: true,
                      onSaved: (value) => viewModel.password = value ?? '',
                      validator: (value) =>
                          value!.isEmpty ? 'Este campo es obligatorio.' : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      controller: viewModel.birthDateController,
                      decoration: const InputDecoration(
                          labelText: 'Fecha de Nacimiento',
                          border: OutlineInputBorder()),
                      readOnly: true,
                      onTap: () => viewModel.selectBirthDate(context),
                      validator: (value) =>
                          value!.isEmpty ? 'Este campo es obligatorio.' : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Sexo: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('M'),
                            leading: Radio<String>(
                              value: 'M',
                              groupValue: viewModel.gender,
                              onChanged: (value) =>
                                  setState(() => viewModel.gender = value!),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('F'),
                            leading: Radio<String>(
                              value: 'F',
                              groupValue: viewModel.gender,
                              onChanged: (value) =>
                                  setState(() => viewModel.gender = value!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    '¿Le disgusta algún alimento?',
                    style: TextStyle(fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Alimentos que le disgustan',
                          border: OutlineInputBorder()),
                      onSaved: (value) => viewModel.dislikes = value ?? '',
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Síntomas y/o tratamientos',
                    style: TextStyle(fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      controller: viewModel.symptomsController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Síntomas seleccionados',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton(
                    onPressed: () => viewModel.showSymptomsDialog(context),
                    child: const Text('Seleccionar'),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Alergias y/o intolerancias',
                    style: TextStyle(fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      controller: viewModel.allergiesController,
                      readOnly: true,
                      decoration: const InputDecoration(
                          labelText: 'Alergias seleccionadas',
                          border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  ElevatedButton(
                    onPressed: () => viewModel.showAllergiesDialog(context),
                    child: const Text('Seleccionar'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          '¿Fuma?: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('✓'),
                            leading: Radio<bool>(
                              value: true,
                              groupValue: viewModel.smokes,
                              onChanged: (value) =>
                                  setState(() => viewModel.smokes = value!),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('✗'),
                            leading: Radio<bool>(
                              value: false,
                              groupValue: viewModel.smokes,
                              onChanged: (value) =>
                                  setState(() => viewModel.smokes = value!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    '¿Cuántos cigarrillos fuma al día?',
                    style: TextStyle(fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      controller: viewModel.cigarettesPerDayController,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onSaved: (value) {
                        int cigarettes = int.tryParse(value!) ?? 0;
                        viewModel.updateCigarettesPerDay(cigarettes);
                      },
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            int.tryParse(value) == null) {
                          return 'Ingresa un número válido.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '¿Usted toma café?',
                    style: TextStyle(fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: DropdownButtonFormField<String>(
                      value: viewModel.coffee,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      onChanged: (String? newValue) {
                        viewModel.coffee = newValue!;
                      },
                      items: viewModel.consumptionOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '¿Cuántas tazas de café toma al día?',
                    style: TextStyle(fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      controller: viewModel.coffeeCupsPerDayController,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onSaved: (value) {
                        int coffeeCups = int.tryParse(value!) ?? 0;
                        viewModel.updateCoffeeCupsPerDay(coffeeCups);
                      },
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            int.tryParse(value) == null) {
                          return 'Ingresa un número válido.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '¿Usted come picante o llajua?',
                    style: TextStyle(fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: DropdownButtonFormField<String>(
                      value: viewModel.llajua,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      onChanged: (String? newValue) {
                        viewModel.llajua = newValue!;
                      },
                      items: viewModel.consumptionOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '¿Con cuántas cucharillas de azúcar toma su café o refresco (taza de 200 ml)?',
                    style: TextStyle(
                        fontSize: 16, overflow: TextOverflow.ellipsis),
                    maxLines: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      controller: viewModel.sugarInDrinksController,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onSaved: (value) {
                        int sugar = int.tryParse(value!) ?? 0;
                        viewModel.updateSugarInDrinks(sugar);
                      },
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            int.tryParse(value) == null) {
                          return 'Ingresa un número válido.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '¿Con qué condimenta su comida?',
                    style: TextStyle(fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      controller: viewModel.seasoningsController,
                      readOnly: true,
                      decoration: const InputDecoration(
                          labelText: 'Condimentos seleccionados',
                          border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  ElevatedButton(
                    onPressed: () => viewModel.showSeasoningsDialog(context),
                    child: const Text('Seleccionar'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '¿Algún comentario que quiera añadir?',
                    style: TextStyle(fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      onSaved: (value) => viewModel.comment = value ?? '',
                      maxLines: 3,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            debugPrint("Picked Image Path: $selectedImage");
                            formKey.currentState!.save();
                            Judge newJudge = Judge(
                              id: '',
                              fullName: viewModel.fullName,
                              email: viewModel.email,
                              birthDate: viewModel.birthDate,
                              gender: viewModel.gender,
                              dislikes: viewModel.dislikes,
                              symptoms: viewModel.selectedSymptoms,
                              smokes: viewModel.smokes,
                              cigarettesPerDay: viewModel.cigarettesPerDay,
                              coffee: viewModel.coffee,
                              coffeeCupsPerDay: viewModel.coffeeCupsPerDay,
                              llajua: viewModel.llajua,
                              seasonings: viewModel.selectedSeasonings,
                              sugarInDrinks: viewModel.sugarInDrinks,
                              allergies: viewModel.selectedAllergies,
                              comment: viewModel.comment,
                              applicationState: 'PENDING',
                              profileImgUrl: '',
                            );
                            if (await viewModel.register(
                                newJudge, selectedImage!)) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const VerificationView()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Error en el registro.')),
                              );
                            }
                          }
                        },
                        child: const Text('Registrarse'),
                      )),
                  const HaveAnAccount(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

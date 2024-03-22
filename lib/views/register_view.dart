import 'dart:io';
import 'package:catas_univalle/widgets/register/custom_numberinput.dart';
import 'package:catas_univalle/widgets/register/custom_selectfield.dart';
import 'package:catas_univalle/widgets/register/custom_selectionfield.dart';
import 'package:catas_univalle/widgets/register/gender_selection.dart';
import 'package:catas_univalle/widgets/register/smoking_selection_widget.dart';
import 'package:catas_univalle/widgets/register/submit_registration_button.dart';
import 'package:catas_univalle/widgets/register/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/widgets/register/have_an_account.dart';
import 'package:catas_univalle/view_models/register_viewmodel.dart';
import 'package:catas_univalle/widgets/register/custom_textfield.dart';
import 'package:catas_univalle/functions/util.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  File? selectedImage;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  UserImagePicker(
                    onPickImage: (pickedImage) {
                      setState(() {
                        selectedImage = pickedImage;
                      });
                    },
                  ),
                  CustomTextFormField(
                    labelText: 'Nombre Completo',
                    onSaved: (value) => viewModel.fullName = value ?? '',
                    validator: (value) =>
                        value!.isEmpty ? 'Este campo es obligatorio.' : null,
                  ),
                  CustomTextFormField(
                    labelText: 'Email',
                    onSaved: (value) => viewModel.email = value ?? '',
                    validator: (value) {
                      if ((value == null ||
                          value.trim().isEmpty ||
                          !isValidEmail(value))) {
                        return 'Ingresa un email válido.';
                      }
                      return null;
                    },
                  ),
                  CustomTextFormField(
                    labelText: 'Contraseña',
                    obscureText: true,
                    onSaved: (value) => viewModel.password = value ?? '',
                    validator: (value) {
                      if ((value == null ||
                          value.trim().isEmpty ||
                          !isValidPassword(value))) {
                        return 'La contraseña debe tener al menos 6 caracteres.';
                      }
                      return null;
                    },
                  ),
                  CustomTextFormField(
                    labelText: 'Fecha de Nacimiento',
                    readOnly: true,
                    controller: viewModel.birthDateController,
                    onTap: () => viewModel.selectBirthDate(context),
                    validator: (value) =>
                        value!.isEmpty ? 'Este campo es obligatorio.' : null,
                  ),
                  GenderSelectionWidget(
                    groupValue: viewModel.gender,
                    onChanged: (value) =>
                        setState(() => viewModel.gender = value),
                  ),
                  CustomTextFormField(
                    labelText: 'Alimentos que le disgustan',
                    onSaved: (value) => viewModel.dislikes = value ?? '',
                  ),
                  CustomSelectionField(
                    labelText: 'Padecimientos y/o Tratamientos',
                    controller: viewModel.symptomsController,
                    onTap: () => viewModel.showSymptomsDialog(context),
                  ),
                  CustomSelectionField(
                    labelText: 'Alergias',
                    controller: viewModel.allergiesController,
                    onTap: () => viewModel.showAllergiesDialog(context),
                  ),
                  SmokingSelectionWidget(
                    smokes: viewModel.smokes,
                    onChanged: (value) =>
                        setState(() => viewModel.smokes = value),
                  ),
                  CustomNumberInput(
                    labelText: 'Cigarrillos por día',
                    controller: viewModel.cigarettesPerDayController,
                    onSaved: (value) {
                      int cigarettes = int.tryParse(value!) ?? 0;
                      viewModel.updateCigarettesPerDay(cigarettes);
                    },
                  ),
                  CustomSelectField<String>(
                    value: viewModel.coffee,
                    items: viewModel.consumptionOptions,
                    labelText: 'Consumo de café',
                    onChanged: (value) => viewModel.coffee = value!,
                    itemLabelBuilder: (value) => value,
                  ),
                  CustomNumberInput(
                    labelText: 'Tazas de café por día',
                    controller: viewModel.coffeeCupsPerDayController,
                    onSaved: (value) {
                      int coffeeCups = int.tryParse(value!) ?? 0;
                      viewModel.updateCoffeeCupsPerDay(coffeeCups);
                    },
                  ),
                  CustomSelectField<String>(
                    value: viewModel.llajua,
                    items: viewModel.consumptionOptions,
                    labelText: 'Consumo de picante o llajua',
                    onChanged: (value) => viewModel.llajua = value!,
                    itemLabelBuilder: (value) => value,
                  ),
                  CustomNumberInput(
                    labelText: 'Cucharillas de azúcar en bebidas (200 ml)',
                    controller: viewModel.sugarInDrinksController,
                    onSaved: (value) {
                      int sugar = int.tryParse(value!) ?? 0;
                      viewModel.updateSugarInDrinks(sugar);
                    },
                  ),
                  CustomSelectionField(
                    labelText: 'Condimentos que utiliza',
                    controller: viewModel.seasoningsController,
                    onTap: () => viewModel.showSeasoningsDialog(context),
                  ),
                  CustomTextFormField(
                    labelText: 'Comentarios adicionales',
                    onSaved: (value) => viewModel.comment = value ?? '',
                    maxLines: 3,
                  ),
                  SubmitRegistrationButton(
                    formKey: formKey,
                    selectedImage: selectedImage,
                    viewModel: viewModel,
                  ),
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
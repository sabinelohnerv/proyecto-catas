import 'dart:io';
import 'package:catas_univalle/widgets/register/custom_numberinput.dart';
import 'package:catas_univalle/widgets/register/custom_selectfield.dart';
import 'package:catas_univalle/widgets/register/custom_selectionfield.dart';
import 'package:catas_univalle/widgets/register/gender_selection.dart';
import 'package:catas_univalle/widgets/register/bool_selection_widget.dart';
import 'package:catas_univalle/widgets/register/submit_registration_button.dart';
import 'package:catas_univalle/widgets/register/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/widgets/register/have_an_account.dart';
import 'package:catas_univalle/view_models/register_viewmodel.dart';
import 'package:catas_univalle/widgets/register/custom_textfield.dart';
import 'package:catas_univalle/functions/util.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxisScrolled) => [
          SliverAppBar(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40))),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                viewModel.resetAllData();
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: const Text(
              "Registro de Usuario",
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            ),
            centerTitle: true,
          ),
        ],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
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
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Text(
                        'Datos Generales',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                    CustomTextFormField(
                      labelText: 'Nombre Completo',
                      onSaved: (value) => viewModel.fullName = value ?? '',
                      prefixIcon: const Icon(Icons.person_2),
                      validator: (value) =>
                          value!.isEmpty ? 'Este campo es obligatorio.' : null,
                    ),
                    CustomTextFormField(
                      labelText: 'Email',
                      onSaved: (value) => viewModel.email = value ?? '',
                      prefixIcon: const Icon(Icons.email),
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
                      prefixIcon: const Icon(Icons.password),
                      validator: (value) {
                        if ((value == null ||
                            value.trim().isEmpty ||
                            !isValidPassword(value))) {
                          return 'La contraseña debe tener: \n- Al menos 6 caracteres.';
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      labelText: 'Fecha de Nacimiento',
                      readOnly: true,
                      controller: viewModel.birthDateController,
                      prefixIcon: const Icon(Icons.calendar_month),
                      onTap: () => viewModel.selectBirthDate(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo es obligatorio.';
                        } else if (!isOlderThan18(value)) {
                          return 'Debes tener al menos 18 años de edad.';
                        }
                        return null;
                      },
                    ),
                    GenderSelectionWidget(
                      groupValue: viewModel.gender,
                      onChanged: (value) =>
                          setState(() => viewModel.gender = value),
                    ),
                    CustomSelectField<String>(
                      value: viewModel.roleAsJudge,
                      items: viewModel.roleOptions,
                      labelText: 'Rol en la institución',
                      prefixIcon: const Icon(Icons.assignment_ind),
                      onChanged: (value) => viewModel.roleAsJudge = value!,
                      itemLabelBuilder: (value) => value,
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child: Text(
                        '¿Tiene tiempo para realizar capacitaciones de 1 hora semanalmente?',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.clip,
                        maxLines: 3,
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    BoolSelectionWidget(
                      changingValue: viewModel.hasTime,
                      labelText: '',
                      onChanged: (value) =>
                          setState(() => viewModel.hasTime = value),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Text(
                        'Restricciones',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                    CustomSelectionField(
                      labelText: 'Padecimientos y/o Tratamientos',
                      controller: viewModel.symptomsController,
                      prefixIcon: const Icon(Icons.medical_services),
                      onTap: () => viewModel.showSymptomsDialog(context),
                    ),
                    CustomSelectionField(
                      labelText: 'Alergias',
                      controller: viewModel.allergiesController,
                      prefixIcon: const Icon(Icons.warning),
                      onTap: () => viewModel.showAllergiesDialog(context),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Text(
                        'Hábitos',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                    CustomSelectField<String>(
                      value: viewModel.coffee,
                      items: viewModel.consumptionOptions,
                      labelText: 'Consumo de café',
                      prefixIcon: const Icon(Icons.coffee),
                      onChanged: (value) => viewModel.coffee = value!,
                      itemLabelBuilder: (value) => value,
                    ),
                    CustomNumberInput(
                      labelText: 'Tazas de café por día',
                      controller: viewModel.coffeeCupsPerDayController,
                      prefixIcon: const Icon(Icons.local_cafe),
                      onSaved: (value) {
                        int coffeeCups = int.tryParse(value) ?? 0;
                        viewModel.updateCoffeeCupsPerDay(coffeeCups);
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child: Text(
                        '¿Fuma?',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    BoolSelectionWidget(
                      changingValue: viewModel.smokes,
                      labelText: '',
                      onChanged: (value) =>
                          setState(() => viewModel.smokes = value),
                    ),
                    CustomNumberInput(
                      labelText: 'Cigarrillos por día',
                      controller: viewModel.cigarettesPerDayController,
                      prefixIcon: const Icon(Icons.smoking_rooms),
                      onSaved: (value) {
                        int cigarettes = int.tryParse(value) ?? 0;
                        viewModel.updateCigarettesPerDay(cigarettes);
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Text(
                        'Preferencias',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                    CustomSelectField<String>(
                      value: viewModel.llajua,
                      items: viewModel.consumptionOptions,
                      labelText: 'Consumo de picante o llajua',
                      prefixIcon: const Icon(Icons.local_fire_department),
                      onChanged: (value) => viewModel.llajua = value!,
                      itemLabelBuilder: (value) => value,
                    ),
                    CustomNumberInput(
                      labelText: 'Cucharillas de azúcar en bebidas (200 ml)',
                      controller: viewModel.sugarInDrinksController,
                      prefixIcon: const Icon(Icons.local_drink),
                      onSaved: (value) {
                        int sugar = int.tryParse(value) ?? 0;
                        viewModel.updateSugarInDrinks(sugar);
                      },
                    ),
                    CustomSelectionField(
                      labelText: 'Condimentos que utiliza',
                      controller: viewModel.seasoningsController,
                      prefixIcon: const Icon(Icons.grain),
                      onTap: () => viewModel.showSeasoningsDialog(context),
                    ),
                    CustomTextFormField(
                      labelText: 'Alimentos que le disgustan',
                      prefixIcon: const Icon(Icons.no_food),
                      onSaved: (value) => viewModel.dislikes = value ?? '',
                      validator: (value) =>
                          value!.isEmpty ? 'Este campo es obligatorio.' : null,
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Text(
                        'Información Adicional',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                    CustomTextFormField(
                      labelText: 'Comentarios adicionales',
                      prefixIcon: const Icon(Icons.info),
                      onSaved: (value) => viewModel.comment = value ?? '',
                      maxLines: 3,
                      validator: (value) =>
                          value!.isEmpty ? 'Este campo es obligatorio.' : null,
                    ),
                    SubmitRegistrationButton(
                      formKey: formKey,
                      selectedImage: selectedImage,
                      viewModel: viewModel,
                    ),
                    const HaveAnAccount(),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

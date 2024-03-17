import 'package:catas_univalle/models/judge.dart';
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
        title: const Text('Registro'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Nombre Completo'),
                  onSaved: (value) => viewModel.fullName = value ?? '',
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio.' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
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
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  onSaved: (value) => viewModel.password = value ?? '',
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio.' : null,
                ),
                TextFormField(
                  controller: viewModel.birthDateController,
                  decoration:
                      const InputDecoration(labelText: 'Fecha de Nacimiento'),
                  readOnly: true,
                  onTap: () => viewModel.selectBirthDate(context),
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio.' : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Alimentos que le disgustan'),
                  onSaved: (value) => viewModel.dislikes = value ?? '',
                ),
                const SizedBox(height: 24),
                const Text(
                  'Síntomas y/o tratamientos',
                  style: TextStyle(fontSize: 16),
                ),
                TextField(
                  controller: viewModel.symptomsController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Síntomas seleccionados',
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
                TextField(
                  controller: viewModel.allergiesController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Alergias seleccionadas',
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
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        '¿Usted fuma?: ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('Sí'),
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
                          title: const Text('No'),
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
                TextFormField(
                  controller: viewModel.cigarettesPerDayController,
                  decoration:
                      const InputDecoration(labelText: 'Cigarrillos por día'),
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
                const SizedBox(height: 16),
                const Text(
                  '¿Usted toma café?',
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButtonFormField<String>(
                  value: viewModel.coffee,
                  decoration: const InputDecoration(
                    labelText: 'Frecuencia de consumo',
                  ),
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
                const SizedBox(height: 16),
                const Text(
                  '¿Cuántas tazas de café toma al día?',
                  style: TextStyle(fontSize: 16),
                ),
                TextFormField(
                  controller: viewModel.coffeeCupsPerDayController,
                  decoration:
                      const InputDecoration(labelText: 'Tazas de café al día'),
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
                const SizedBox(height: 16),
                const Text(
                  '¿Usted come picante o llajua?',
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButtonFormField<String>(
                  value: viewModel.llajua,
                  decoration: const InputDecoration(
                    labelText: 'Frecuencia de consumo',
                  ),
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
                const SizedBox(height: 16),
                const Text(
                  '¿Con cuántas cucharillas de azúcar toma su café o refresco (taza de 200 ml)?',
                  style:
                      TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis),
                  maxLines: 3,
                ),
                TextFormField(
                  controller: viewModel.sugarInDrinksController,
                  decoration: const InputDecoration(
                      labelText: 'Cantidad de cucharillas de azúcar'),
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
                const SizedBox(height: 24),
                const Text(
                  '¿Con qué condimenta su comida?',
                  style: TextStyle(fontSize: 16),
                ),
                TextField(
                  controller: viewModel.seasoningsController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Condimentos seleccionados',
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
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Comentarios adicionales'),
                  onSaved: (value) => viewModel.comment = value ?? '',
                  maxLines: 3,
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
                          );
                          if (await viewModel.register(newJudge)) {
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
    );
  }
}

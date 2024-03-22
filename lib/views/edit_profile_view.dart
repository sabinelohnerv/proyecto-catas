// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/view_models/register_viewmodel.dart';

import '../widgets/profile/edit_field.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<RegisterViewModel>(context, listen: false);
    viewModel.loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Perfil"),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
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
              children: [
                CustomTextFormField(
                  controller: TextEditingController(text: viewModel.dislikes),
                  labelText: 'Alimentos que le disgustan',
                  onSaved: (value) => viewModel.updateDislikes(value ?? ''),
                ),
                ListTile(
                  title: const Text("Fumador"),
                  trailing: Switch(
                    value: viewModel.smokes,
                    onChanged: (newValue) {
                      setState(() {
                        viewModel.smokes = newValue;
                      });
                    },
                  ),
                ),
                CustomTextFormField(
                  controller: TextEditingController(
                      text: viewModel.cigarettesPerDay.toString()),
                  labelText: 'Cigarrillos por día',
                  keyboardType: TextInputType.number,
                  onSaved: (value) => viewModel
                      .updateCigarettesPerDay(int.tryParse(value ?? '0') ?? 0),
                ),
                CustomDropdownFormField(
                  value: viewModel.coffee,
                  labelText: 'Consumo de café',
                  items: viewModel.consumptionOptions,
                  onChanged: (String? newValue) =>
                      viewModel.coffee = (newValue!),
                ),
                CustomTextFormField(
                  controller: TextEditingController(
                      text: viewModel.coffeeCupsPerDay.toString()),
                  labelText: 'Tazas de café por día',
                  keyboardType: TextInputType.number,
                  onSaved: (value) => viewModel
                      .updateCoffeeCupsPerDay(int.tryParse(value ?? '0') ?? 0),
                ),
                CustomDropdownFormField(
                  value: viewModel.llajua,
                  labelText: 'Consumo de llajua',
                  items: viewModel.consumptionOptions,
                  onChanged: (String? newValue) =>
                      viewModel.llajua = (newValue!),
                ),
                CustomTextFormField(
                  controller: TextEditingController(
                      text: viewModel.sugarInDrinks.toString()),
                  labelText: 'Cucharillas de azúcar en bebidas',
                  keyboardType: TextInputType.number,
                  onSaved: (value) => viewModel
                      .updateSugarInDrinks(int.tryParse(value ?? '0') ?? 0),
                ),
                CustomTextFormField(
                  controller: TextEditingController(text: viewModel.comment),
                  labelText: 'Comentarios',
                  maxLines: 3,
                  onSaved: (value) => viewModel.updateComment(value ?? ''),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (await viewModel.saveProfileChanges()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Perfil actualizado correctamente')),
                        );
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Error al actualizar el perfil')),
                        );
                      }
                    }
                  },
                  child: const Text('Guardar Cambios'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDropdownFormField extends StatelessWidget {
  final String value;
  final String labelText;
  final List<String> items;
  final void Function(String?) onChanged;

  const CustomDropdownFormField({
    Key? key,
    required this.value,
    required this.labelText,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

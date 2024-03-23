// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/view_models/register_viewmodel.dart';
import '../widgets/profile/profile_card.dart';
import '../widgets/register/custom_numberinput.dart';
import '../widgets/register/custom_selectfield.dart';
import '../widgets/register/custom_textfield.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxisScrolled) => [
          SliverAppBar(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40))),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: const Text(
              "EDITAR PERFIL",
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
            centerTitle: true,
          ),
        ],
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
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: SimpleSectionCard(
                            img: 'sintomas',
                            title: 'Síntomas',
                            subtitle: 'Editar',
                            destinationScreen: null,
                            isClickable: true,
                            onTap: () => viewModel.showSymptomsDialog(context),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SimpleSectionCard(
                            img: 'alergias',
                            title: 'Alergias',
                            subtitle: 'Editar',
                            destinationScreen: null,
                            isClickable: true,
                            onTap: () => viewModel.showAllergiesDialog(context),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SimpleSectionCard(
                            img: 'condimentos',
                            title: 'Condimento',
                            subtitle: 'Editar',
                            destinationScreen: null,
                            isClickable: true,
                            onTap: () =>
                                viewModel.showSeasoningsDialog(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextFormField(
                    controller: viewModel.dislikesController,
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
                  CustomNumberInput(
                    labelText: 'Cigarrillos por día',
                    controller: viewModel.cigarettesPerDayController,
                    onSaved: (value) {
                      int cigarettes = int.tryParse(value) ?? 0;
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
                      int coffeeCups = int.tryParse(value) ?? 0;
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
                      int sugar = int.tryParse(value) ?? 0;
                      viewModel.updateSugarInDrinks(sugar);
                    },
                  ),
                  CustomTextFormField(
                    controller: viewModel.commentController,
                    labelText: 'Comentarios',
                    maxLines: 3,
                    onSaved: (value) => viewModel.updateComment(value ?? ''),
                  ),
                  FilledButton(
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
                    child: const Text(
                      'GUARDAR CAMBIOS',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

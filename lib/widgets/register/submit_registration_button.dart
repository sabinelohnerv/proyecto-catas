// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:catas_univalle/models/judge.dart';
import 'package:catas_univalle/view_models/register_viewmodel.dart';
import 'package:catas_univalle/views/verification_view.dart';
import 'package:flutter/material.dart';

class SubmitRegistrationButton extends StatelessWidget {
  const SubmitRegistrationButton({
    super.key,
    required this.formKey,
    required this.selectedImage,
    required this.viewModel,
  });

  final GlobalKey<FormState> formKey;
  final File? selectedImage;
  final RegisterViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15),
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
                roleAsJudge: viewModel.roleAsJudge,
                hasTime: viewModel.hasTime
              );
              if (await viewModel.register(newJudge, selectedImage!)) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VerificationView()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error en el registro.')),
                );
              }
            }
          },
          child: const Text(
            'REGISTRARSE',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ));
  }
}

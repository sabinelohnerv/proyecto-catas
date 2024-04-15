import 'dart:io';

import 'package:catas_univalle/models/judge.dart';
import 'package:catas_univalle/view_models/register_viewmodel.dart';
import 'package:catas_univalle/views/verification_view.dart';
import 'package:flutter/material.dart';

class SubmitRegistrationButton extends StatefulWidget {
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
  State<SubmitRegistrationButton> createState() =>
      _SubmitRegistrationButtonState();
}

class _SubmitRegistrationButtonState extends State<SubmitRegistrationButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        onPressed: _isLoading
            ? null
            : () async {
                if (widget.formKey.currentState!.validate()) {
                  if (widget.selectedImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text('Debes seleccionar una foto de perfil.')));
                    return;
                  }
                  setState(() {
                    _isLoading = true;
                  });
                  widget.formKey.currentState!.save();
                  widget.viewModel.calculateReliability();
                  Judge newJudge = Judge(
                      id: '',
                      fullName: widget.viewModel.fullName,
                      email: widget.viewModel.email,
                      birthDate: widget.viewModel.birthDate,
                      gender: widget.viewModel.gender,
                      dislikes: widget.viewModel.dislikes,
                      symptoms: widget.viewModel.selectedSymptoms,
                      smokes: widget.viewModel.smokes,
                      cigarettesPerDay: widget.viewModel.cigarettesPerDay,
                      coffee: widget.viewModel.coffee,
                      coffeeCupsPerDay: widget.viewModel.coffeeCupsPerDay,
                      llajua: widget.viewModel.llajua,
                      seasonings: widget.viewModel.selectedSeasonings,
                      sugarInDrinks: widget.viewModel.sugarInDrinks,
                      allergies: widget.viewModel.selectedAllergies,
                      comment: widget.viewModel.comment,
                      applicationState: 'PENDING',
                      profileImgUrl: '',
                      roleAsJudge: widget.viewModel.roleAsJudge,
                      hasTime: widget.viewModel.hasTime,
                      reliability: widget.viewModel.reliability);
                  if (await widget.viewModel
                      .register(newJudge, widget.selectedImage!)) {
                    widget.viewModel.resetAllData();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VerificationView()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error en el registro.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
        child: _isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : const Text(
                'REGISTRARSE',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
      ),
    );
  }
}

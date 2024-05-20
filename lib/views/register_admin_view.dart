// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:catas_univalle/view_models/register_admin_viewmodel.dart';
import 'package:catas_univalle/widgets/register/custom_selectfield.dart';
import 'package:catas_univalle/widgets/register/custom_textfield.dart';
import 'package:catas_univalle/widgets/register/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:catas_univalle/functions/util.dart';

class RegisterAdminView extends StatefulWidget {
  const RegisterAdminView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterAdminViewState();
  }
}

class _RegisterAdminViewState extends State<RegisterAdminView> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  final RegisterAdminViewModel viewModel = RegisterAdminViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: const Text(
              "Registrar Administrador",
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.white),
            ),
            centerTitle: true,
          ),
        ],
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 40.0),
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
                      onPickImage: (File pickedImage) {
                        viewModel.profileImage = pickedImage;
                      },
                    ),
                    CustomTextFormField(
                      labelText: 'Nombre del Administrador',
                      prefixIcon: const Icon(Icons.person),
                      onSaved: (value) => viewModel.name = value ?? '',
                      validator: (value) =>
                          value!.isEmpty ? 'Este campo es obligatorio.' : null,
                    ),
                    CustomTextFormField(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
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
                    CustomSelectField<String>(
                      value: viewModel.role,
                      items: viewModel.roleOptions,
                      labelText: 'Privilegios',
                      prefixIcon: const Icon(Icons.assignment_ind),
                      onChanged: (value) => viewModel.role = value!,
                      itemLabelBuilder: (value) => value,
                    ),
                    CustomTextFormField(
                      labelText: 'Contraseña',
                      readOnly: true,
                      prefixIcon: const Icon(Icons.password),
                      onTap: () => viewModel.randomizePassword(),
                      controller: viewModel.passwordController,
                      validator: (value) =>
                          value!.isEmpty ? 'Este campo es obligatorio.' : null,
                    ),
                    const SizedBox(height: 36),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            bool success = await viewModel.registerAdmin();
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Administrador registrado con éxito'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(viewModel.errorMessage ??
                                      "Error en el registro"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'REGISTRAR',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
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

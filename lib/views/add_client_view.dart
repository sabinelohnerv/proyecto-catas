import 'dart:io';
import 'package:catas_univalle/functions/util.dart';
import 'package:catas_univalle/view_models/add_client_viewmodel.dart';
import 'package:catas_univalle/widgets/clients/submit_new_client.dart';
import 'package:catas_univalle/widgets/register/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddClientView extends StatefulWidget {
  const AddClientView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddClientViewState();
  }
}

class _AddClientViewState extends State<AddClientView> {
  final _formKey = GlobalKey<FormState>();
  File? _logo;
  final picker = ImagePicker();
  final AddClientViewModel viewModel = AddClientViewModel();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _logo = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              "Agregar Anfitrión",
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            ),
            centerTitle: true,
          ),
        ],
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 40),
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
                    CustomTextFormField(
                      labelText: 'Nombre del Anfitrión',
                      prefixIcon: const Icon(Icons.assignment_ind),
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
                    const SizedBox(height: 4),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      child: Text(
                        'Logo del Anfitrión',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _logo == null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                              height: 220,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(Icons.no_photography_rounded,
                                    size: 50, color: Colors.grey),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              height: 220,
                              width: MediaQuery.sizeOf(context).width,
                              child: Image.file(
                                _logo!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    TextButton.icon(
                      onPressed: getImage,
                      icon: const Icon(Icons.image),
                      label: const Text('Elegir logo'),
                    ),
                    const SizedBox(height: 36),
                    SubmitNewClient(
                      formKey: _formKey,
                      logo: _logo,
                      viewModel: viewModel,
                      name: viewModel.name,
                      email: viewModel.email,
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

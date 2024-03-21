import 'dart:io';

import 'package:catas_univalle/widgets/profile/attributes_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/profile_viewmodel.dart';
import '../widgets/register/user_image_picker.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileViewState();
  }
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    final userViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    userViewModel.loadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<ProfileViewModel>(context);
    File? selectedImage;

    String listToMultilineString(List<String> list) {
      return list.join('\n');
    }

    String commasToLineBreaks(String input) {
      return input.replaceAll(',', '\n');
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    UserImagePicker(
                      initialImage: userViewModel.imageUrl,
                      onPickImage: (pickedImage) {
                        setState(() {
                          selectedImage = pickedImage;
                        });
                      },
                    ),
                    Text(
                      userViewModel.fullName.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userViewModel.email,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AttributeContainer(
                    title: 'Intolerancias',
                    content: listToMultilineString(userViewModel.allergies),
                  ),
                  AttributeContainer(
                    title: 'Dislikes',
                    content: commasToLineBreaks(userViewModel.dislikes),
                  ),
                  AttributeContainer(
                    title: 'Comentarios',
                    content: commasToLineBreaks(userViewModel.comment),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

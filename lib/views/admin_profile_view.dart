import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/profile_viewmodel.dart';
import '../widgets/register/user_image_picker.dart';
import 'edit_profile_view.dart';

class AdminProfileView extends StatefulWidget {
  const AdminProfileView({super.key});

  @override
  State<AdminProfileView> createState() => _AdminProfileViewState();
}

class _AdminProfileViewState extends State<AdminProfileView> {
  @override
  void initState() {
    super.initState();
    final userViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    userViewModel.loadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const EditProfileView()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 5,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(30)),
              child: Container(
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
                      const SizedBox(height: 30),
                      UserImagePicker(
                        initialImage: userViewModel.imageUrl,
                        onPickImage: (pickedImage) async {
                          await userViewModel.updateProfileImage(
                              pickedImage, userViewModel.currentUser!.uid);
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
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Center(
                child: Text(
                  "Administrator",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
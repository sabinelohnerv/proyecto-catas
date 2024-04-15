import 'dart:io';
import 'package:catas_univalle/models/admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _primaryAuth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late FirebaseAuth _secondaryAuth;

  AdminService() {
    initializeSecondaryAuth();
  }

  Future<void> initializeSecondaryAuth() async {
    FirebaseApp secondaryApp = await Firebase.initializeApp(
      name: 'SecondaryApp',
      options: Firebase.app().options,
    );
    _secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);
  }

  Future<void> registerAdmin(String email, String password, String name,
      String profileImgPath, String role) async {
    try {
      UserCredential userCredential = await _secondaryAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await sendVerificationEmail(userCredential.user);

      String imageUrl = "";
      if (profileImgPath.isNotEmpty) {
        imageUrl = await uploadImage(profileImgPath, userCredential.user!.uid);
      }

      Admin newAdmin = Admin(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        profileImgUrl: imageUrl,
        role: role,
      );

      await createAdmin(newAdmin);
    } catch (e) {
      throw Exception('Error en el registro de administrador');
    }
  }

  Future<String> uploadImage(String filePath, String userId) async {
    File file = File(filePath);
    try {
      TaskSnapshot snapshot =
          await _storage.ref('user_profile_images/$userId.jpg').putFile(file);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error al guardar la imagen');
    }
  }

  Future<void> sendVerificationEmail(User? user) async {
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> createAdmin(Admin admin) async {
    try {
      await _firestore.collection('users').doc(admin.id).set({
        'fullName': admin.name,
        'email': admin.email,
        'img_url': admin.profileImgUrl,
        'role': admin.role,
      });
    } catch (e) {
      throw Exception('Error en el registro de administrador');
    }
  }

  Stream<List<Admin>> adminsStream() {
    return _firestore
        .collection('users')
        .where('role', whereIn: ['admin', 'admin-2'])
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Admin.fromSnapshot(doc)).toList();
        });
  }
}

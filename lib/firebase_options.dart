// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAAQCfqVPAksEg5JbZUbdp_ZFWeuoi9UDg',
    appId: '1:12944337518:web:1a4b6dae1a26c1023fd47f',
    messagingSenderId: '12944337518',
    projectId: 'catas-univalle',
    authDomain: 'catas-univalle.firebaseapp.com',
    storageBucket: 'catas-univalle.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDqR3vocAauhRX2gPFjU4rFGnjo8Bht57k',
    appId: '1:12944337518:android:ee4365bd20bca5b13fd47f',
    messagingSenderId: '12944337518',
    projectId: 'catas-univalle',
    storageBucket: 'catas-univalle.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBMoCTPtYZG-wU12bBETj1nhYY3GlUXczo',
    appId: '1:12944337518:ios:f0923105c92a6c693fd47f',
    messagingSenderId: '12944337518',
    projectId: 'catas-univalle',
    storageBucket: 'catas-univalle.appspot.com',
    iosBundleId: 'com.example.catasUnivalle',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBMoCTPtYZG-wU12bBETj1nhYY3GlUXczo',
    appId: '1:12944337518:ios:4bd58a439679ef243fd47f',
    messagingSenderId: '12944337518',
    projectId: 'catas-univalle',
    storageBucket: 'catas-univalle.appspot.com',
    iosBundleId: 'com.example.catasUnivalle.RunnerTests',
  );
}

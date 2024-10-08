// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBSPARZTXiPYClMXZ8AaX5veGIvgV0gQnU',
    appId: '1:366060295124:android:3cf54fc35d040202a4fc41',
    messagingSenderId: '366060295124',
    projectId: 'readingapp-aed62',
    storageBucket: 'readingapp-aed62.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB2LUYXpEIMgU43WDeoCMXxorIREsaWBuk',
    appId: '1:366060295124:ios:780c0ba4159c44c8a4fc41',
    messagingSenderId: '366060295124',
    projectId: 'readingapp-aed62',
    storageBucket: 'readingapp-aed62.appspot.com',
    androidClientId: '366060295124-sfb2jqketds7e6cfnps98mmol4b1sjmn.apps.googleusercontent.com',
    iosClientId: '366060295124-ttpu73mkg3vih44sk5epmb5khma8k6il.apps.googleusercontent.com',
    iosBundleId: 'com.example.readingApp',
  );

}
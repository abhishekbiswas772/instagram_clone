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
        return windows;
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
    apiKey: 'AIzaSyDnP1IPA9TdJJ0Zmcc53sD0LjmayOz0DU8',
    appId: '1:52526309153:web:41a19191db4341cc7a6860',
    messagingSenderId: '52526309153',
    projectId: 'instagram-22674',
    authDomain: 'instagram-22674.firebaseapp.com',
    storageBucket: 'instagram-22674.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBD2hT3NMOFQOn4ptSetBcZMqYS3_-CAcw',
    appId: '1:52526309153:android:851f9a0331c002017a6860',
    messagingSenderId: '52526309153',
    projectId: 'instagram-22674',
    storageBucket: 'instagram-22674.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBYImuTjzuU_rv_QR8S-3iGYJ1td4kFKbA',
    appId: '1:52526309153:ios:5134e2ceb00c3a147a6860',
    messagingSenderId: '52526309153',
    projectId: 'instagram-22674',
    storageBucket: 'instagram-22674.appspot.com',
    iosBundleId: 'com.example.instagramCloneApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBYImuTjzuU_rv_QR8S-3iGYJ1td4kFKbA',
    appId: '1:52526309153:ios:5134e2ceb00c3a147a6860',
    messagingSenderId: '52526309153',
    projectId: 'instagram-22674',
    storageBucket: 'instagram-22674.appspot.com',
    iosBundleId: 'com.example.instagramCloneApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDnP1IPA9TdJJ0Zmcc53sD0LjmayOz0DU8',
    appId: '1:52526309153:web:e003f26676a175317a6860',
    messagingSenderId: '52526309153',
    projectId: 'instagram-22674',
    authDomain: 'instagram-22674.firebaseapp.com',
    storageBucket: 'instagram-22674.appspot.com',
  );
}
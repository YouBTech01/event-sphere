// File generated for Firebase initialization
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAwcylkMpRJtmtHXXC__xi4F0rU1bcElZ0',
    appId: '1:914073844823:android:0ec19cee163f6a64c7b712',
    messagingSenderId: '914073844823',
    projectId: 'event-app-a1446',
    storageBucket: 'event-app-a1446.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCoIRmxHk6VXRDZ94kSIux3L-3x6AgzYLQ',
    appId: '1:914073844823:web:0ebdd23ad13690a6c7b712',
    messagingSenderId: '914073844823',
    projectId: 'event-app-a1446',
    authDomain: 'event-app-a1446.firebaseapp.com',
    storageBucket: 'event-app-a1446.firebasestorage.app',
    measurementId: 'G-EW3LPT7J3G',
  );
}

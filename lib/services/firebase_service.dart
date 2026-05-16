import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  FirebaseService._();

  static final instance = FirebaseService._();

  Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
    } catch (_) {
      // Works in offline-first mode when Firebase config is not yet wired.
    }
  }
}

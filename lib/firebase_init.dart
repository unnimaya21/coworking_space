import 'package:coworking_space_app/main.dart';
import 'package:firebase_core/firebase_core.dart';

Future<FirebaseApp> ensureFirebaseInitialized() async {
  try {
    // If default app already exists, just return it.
    return Firebase.app();
  } catch (_) {
    // Otherwise initialize once.
    return Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}

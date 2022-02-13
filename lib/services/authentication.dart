import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:jpuzzle/services/firestore.dart';
import 'package:jpuzzle/models/User.dart' as user_model;
class Authentication extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  late user_model.User currentUser;
  GoogleSignInAccount get user => _user!;
  FirestoreProvider _firestoreProvider = FirestoreProvider();
  Future<void> googleLogin() async {
    late UserCredential userCredential;
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider.addScope(
          'https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({
        'login_hint': 'user@example.com'
      });
      userCredential=await FirebaseAuth.instance.signInWithPopup(googleProvider);
    }
    else {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      var credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      userCredential=await FirebaseAuth.instance.signInWithCredential(credential);

      notifyListeners();
    }
    currentUser=await _firestoreProvider.addUser(userCredential.user!.displayName!, (await userCredential.user?.getIdToken())!);
  }
  Future <void> signOut()  async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
  }
}
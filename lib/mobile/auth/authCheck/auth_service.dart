import 'package:firebase_auth/firebase_auth.dart';
import 'package:yardify/widgets/snack_bar.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //error handler
  String getFirebaseAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return "Invalid email address.";
      case 'user-disabled':
        return "This user has been disabled.";
      case 'email-already-in-use':
        return "The email is already in use.";
      case 'operation-not-allowed':
        return "Operation not allowed.";
      case 'weak-password':
        return "The password is too weak. Password should be at least 6 characters.";
      case 'user-not-found':
        return "No user found with this email.";
      case 'wrong-password':
        return "Incorrect password.";
      default:
        return "An unknown error occurred.";
    }
  }

  // Register
  Future<User?> register(String email, String password, context) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      String message = getFirebaseAuthErrorMessage(e.code);
      displaySnackBar(context, message);
      return null;
    }
  }

  // Login
  Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Get current user
  User? get currentUser => _auth.currentUser;
}

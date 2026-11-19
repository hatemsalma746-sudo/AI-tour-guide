
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
    '829454792723-703bh5b28lknikn2l1a948rts1g58sam.apps.googleusercontent.com',
  );

  // Google Sign In
  Future<String?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser =
    await _googleSignIn.signIn();

    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    return googleAuth.idToken;
  }

  // Email and Password Login
  Future<bool> login(String email, String password) async {

    // TODO: Connect with Backend Login API
    // POST /api/auth/login
    // Send email and password
    // Save the returned access token

    return false;
  }

  // Google Login Backend
  Future<bool> loginWithGoogle(String idToken) async {

    // TODO: Connect with Backend Google API
    // POST /api/auth/google
    // Request Body: { "idToken": idToken }
    // Save the returned access token

    return false;
  }

  // Guest Login
  Future<bool> loginAsGuest() async {

    // TODO: Connect with Backend Guest API
    // Get Guest Access Token
    // Save the Guest Access Token

    return true;
  }
}

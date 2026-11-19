
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  bool obscurePassword = true;
  String? errorMessage;

  static const Color goldColor = Color(0xFFC5A86E);

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  // Future<bool> login(String email, String password) async {
  //   if (email.trim().isEmpty || password.isEmpty) {
  //     errorMessage = 'Please enter email and password';
  //     notifyListeners();
  //     return false;
  //   }
  //
  //   if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$')
  //       .hasMatch(email.trim())) {
  //     errorMessage = 'Please enter a valid email';
  //     notifyListeners();
  //     return false;
  //   }
  //
  //   isLoading = true;
  //   errorMessage = null;
  //   notifyListeners();
  //
  //   try {
  //     final success = await _authService.login(
  //       email.trim(),
  //       password,
  //     );
  //
  //     if (!success) {
  //       errorMessage = 'Login integration is pending';
  //     }
  //
  //     return success;
  //   } catch (e) {
  //     errorMessage = 'Something went wrong';
  //     return false;
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }
  Future<bool> login(String email, String password) async {
    if (email.trim().isEmpty || password.isEmpty) {
      errorMessage = 'Please enter email and password';
      notifyListeners();
      return false;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.com$',
    );

    if (!emailRegex.hasMatch(email)) {
      errorMessage = 'Please enter a valid email ending with .com';
      notifyListeners();
      return false;
    }
    if (password.length < 6) {
      errorMessage = 'Password must be at least 6 characters';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Temporary login until Backend integration
      await Future.delayed(const Duration(seconds: 1));

      return true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<bool> googleLogin() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final idToken = await _authService.signInWithGoogle();

      if (idToken == null) {
        return false;
      }

      final success =
      await _authService.loginWithGoogle(idToken);

      if (!success) {
        errorMessage = 'Google Backend integration is pending';
      }

      return success;
    } catch (e) {
      errorMessage = 'Google Sign In failed';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> guestLogin() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      return await _authService.loginAsGuest();
    } catch (e) {
      errorMessage = 'Guest login failed';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}


import 'package:flutter/material.dart';

import '../view_model/login_view_model.dart';
import '../utils/app_images.dart';
import '../utils/app_route.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginViewModel viewModel = LoginViewModel();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  static const Color bgColor = Color(0xFF171614);
  static const Color fieldBgColor = Color(0xFF232220);
  static const Color goldColor = Color(0xFFC5A86E);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    viewModel.dispose();
    super.dispose();
  }

  void goToHome() {
    //for guest navigator
    // TODO: Replace with your actual Home Route
    Navigator.pushReplacementNamed(context, AppRoute.homeScreen);
  }

  Future<void> handleLogin() async {
    final success = await viewModel.login(
      emailController.text,
      passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      goToHome();
    } else {
      showMessage();
    }
  }

  Future<void> handleGoogleLogin() async {
    final success = await viewModel.googleLogin();

    if (!mounted) return;

    if (success) {
      goToHome();
    } else if (viewModel.errorMessage != null) {
      showMessage();
    }
  }

  Future<void> handleGuestLogin() async {
    final success = await viewModel.guestLogin();

    if (!mounted) return;

    if (success) {
      goToHome();
    } else {
      showMessage();
    }
  }

  void showMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          viewModel.errorMessage ?? 'Something went wrong',
        ),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText:
      isPassword ? viewModel.obscurePassword : false,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 15,
        ),
        floatingLabelStyle: const TextStyle(
          color: goldColor,
          fontSize: 13,
        ),
        filled: true,
        fillColor: fieldBgColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: goldColor,
            width: 1.5,
          ),
        ),
        suffixIcon: isPassword
            ? IconButton(
          onPressed: viewModel.togglePasswordVisibility,
          icon: Icon(
            viewModel.obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.white54,
            size: 20,
          ),
        )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: bgColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header Image
                Stack(
                  children: [
                    SizedBox(
                      height: 290,
                      width: double.infinity,
                      child: Image.asset(
                        AppImages.py2Photo,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: 290,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black,
                            bgColor,
                          ],
                          stops: [0.0, 0.65, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 24,
                      right: 24,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Welcome back',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 38,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Log in to continue your journey.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28),

                      // Email
                      buildTextField(
                        label: 'Email',
                        controller: emailController,
                      ),

                      const SizedBox(height: 18),

                      // Password
                      buildTextField(
                        label: 'Password',
                        controller: passwordController,
                        isPassword: true,
                      ),

                      const SizedBox(height: 12),

                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: goldColor,
                            fontSize: 13.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: viewModel.isLoading
                              ? null
                              : handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: bgColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(27),
                            ),
                          ),
                          child: viewModel.isLoading
                              ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: bgColor,
                            ),
                          )
                              : const Text(
                            'Log in',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // OR Divider
                      Row(
                        children: const [
                          Expanded(
                            child: Divider(color: Colors.white38),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                            ),
                            child: Text(
                              'or',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: Colors.white38),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Google Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton(
                          onPressed: viewModel.isLoading
                              ? null
                              : handleGoogleLogin,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.white24,
                            ),
                            backgroundColor: fieldBgColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(27),
                            ),
                          ),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'G',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Continue with Google',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Create Account
                      Center(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children:[
                            Text(
                              'New here? ',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                             TextButton(onPressed: (){
                               Navigator.pushNamed(context, AppRoute.createAccount);
                             },
                              child:  Text(
                                'Create account',
                                style: TextStyle(
                                  color: goldColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Guest
                      Center(
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: viewModel.isLoading
                                  ? null
                                  : handleGuestLogin,
                              child: const Text(
                                'Continue as guest',
                                style: TextStyle(
                                  color: Colors.white,
                                  decoration:
                                  TextDecoration.underline,
                                ),
                              ),
                            ),
                            const Text(
                              'Limited daily use',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

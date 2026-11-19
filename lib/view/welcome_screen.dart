import 'package:ai_tour_guide/utils/app_images.dart';
import 'package:ai_tour_guide/utils/app_route.dart';
import 'package:ai_tour_guide/utils/screen_utils.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppImages.splashScreen, fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.2)),
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 20,
                  left: 14,
                  right: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "WELCOME",
                        style: TextStyle(
                          color: Color(0xFFBA8E63),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        'Ancient\nEgypt,\nAlive Again',
                        style: TextStyle(
                          color: Color(0xFFD6D0E2),
                          fontSize: 55,
                          height: height * 0.0015,
                          fontFamily: 'serif',
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        "point your camera at any artifact\nand hear its story",
                        style: TextStyle(
                          fontSize: 16,
                          height: height * 0.0015,
                          color: Color(0xFFD6D0E2),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: width * 0.8,
                          height: height * 0.06,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pushReplacementNamed(
                              context,
                              AppRoute.homeScreen,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: StadiumBorder(),
                              elevation: 0,
                            ),
                            child: Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.021),
                        SizedBox(
                          width: width * 0.8,
                          height: height * 0.06,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoute.loginScreen,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              side: BorderSide(color: Color(0xFFBA8E63)),
                              shape: StadiumBorder(),
                            ),
                            child: Text(
                              "Log in/Sign up",
                              style: TextStyle(
                                color: Color(0xFFBA8E63),
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} //0xFFBA8E63

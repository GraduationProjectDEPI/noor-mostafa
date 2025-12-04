import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dartx/dartx.dart';
import 'register_page.dart';
import 'auth_service.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passController = TextEditingController();
  final isPasswordVisible = false.obs;
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8EAF6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:   EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 0,
              children: [
                // Logo
                Container(
                  width: 90,
                  height: 90,
                  decoration:   BoxDecoration(
                    color: Color(0xFF5F52EE),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.flash_on,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                  SizedBox(height: 20),

                  Text(
                  'ElectriCount',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                  SizedBox(height: 8),

                  Text(
                  'Monitor your electricity usage',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B7280),
                  ),
                ),
                  SizedBox(height: 48),

                // White Card
                Container(
                  padding:   EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 0,
                    children: [
                      // Email Label
                        Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                        SizedBox(height: 8),

                      // Email Field
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'your.email@example.com',
                          hintStyle:   TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 15,
                          ),
                          filled: true,
                          fillColor:   Color(0xFFF3F4F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:   EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                        SizedBox(height: 20),

                      // Password label
                        Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                        SizedBox(height: 8),

                      // Password Field
                      Obx(() => TextField(
                        controller: passController,
                        obscureText: !isPasswordVisible.value,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle:   TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 15,
                          ),
                          filled: true,
                          fillColor:  Color(0xFFF3F4F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:   EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color:   Color(0xFF9CA3AF),
                              size: 20,
                            ),
                            onPressed: () => isPasswordVisible.value =
                            !isPasswordVisible.value,
                          ),
                        ),
                      )),
                        SizedBox(height: 24),

                      // Sign In Button
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await authService.login(
                              emailController.text,
                              passController.text,
                            );
                            Get.snackbar(
                              'Result',
                              result ? 'Login successful!' : 'Error in login',
                            );
                            // Navigate to home if needed
                            // if (result) Get.off(EntryPage());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF5F52EE),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                        SizedBox(height: 20),

                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.off(RegisterPage()),
                            child: Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5F52EE),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                  SizedBox(height: 24),

                // Forgot Password
                Text(
                  'Forgot password?',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
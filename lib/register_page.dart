import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dartx/dartx.dart';
import 'login_page.dart';
import 'auth_service.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final authService = AuthService();

  void handleRegister() async {
    if (nameController.text.isNullOrEmpty ||
        emailController.text.isNullOrEmpty ||
        passwordController.text.isNullOrEmpty ||
        confirmPasswordController.text.isNullOrEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    isLoading.value = true;
    final success = await authService.register(emailController.text, passwordController.text);
    isLoading.value = false;

    if (success) {
      Get.snackbar('Success', 'Registration successful!');
      Get.off(() => LoginPage());
    } else {
      Get.snackbar('Error', 'Registration failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFFE8EAF6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 90,
                  height: 90,
                  decoration:  BoxDecoration(
                    color: Color(0xFF5F52EE),
                    shape: BoxShape.circle,
                  ),
                  child:  Icon(
                    Icons.flash_on,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                SizedBox(height: 20),

                // Title
                 Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                 SizedBox(height: 8),

                // Subtitle
                 Text(
                  'Join ElectriCount today',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B7280),
                  ),
                ),
                SizedBox(height: 32),

                // White card
                Container(
                  padding:  EdgeInsets.all(24),
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
                    children: [
                      // Full Name
                       Text(
                        'Full Name',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                       SizedBox(height: 8),
                      TextField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'Your Name',
                          hintStyle:  TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 15,
                          ),
                          filled: true,
                          fillColor:  Color(0xFFF3F4F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:  EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Email
                       Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                       SizedBox(height: 8),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'your.email@example.com',
                          hintStyle:  TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 15,
                          ),
                          filled: true,
                          fillColor:  Color(0xFFF3F4F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:  EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => TextField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible.value,
                        decoration: InputDecoration(
                          hintText: 'Create a password',
                          hintStyle:  TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 15,
                          ),
                          filled: true,
                          fillColor:  Color(0xFFF3F4F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:  EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                              color:  Color(0xFF9CA3AF),
                              size: 20,
                            ),
                            onPressed: () => isPasswordVisible.value = !isPasswordVisible.value,
                          ),
                        ),
                      )),
                      SizedBox(height: 20),

                      // Confirm Password
                       Text(
                        'Confirm Password',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                      SizedBox(height: 8),
                      Obx(() => TextField(
                        controller: confirmPasswordController,
                        obscureText: !isConfirmPasswordVisible.value,
                        decoration: InputDecoration(
                          hintText: 'Confirm your password',
                          hintStyle:  TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 15,
                          ),
                          filled: true,
                          fillColor:  Color(0xFFF3F4F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isConfirmPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                              color:  Color(0xFF9CA3AF),
                              size: 20,
                            ),
                            onPressed: () => isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value,
                          ),
                        ),
                      )),
                       SizedBox(height: 24),

                      // Create Account Button
                      Obx(() => SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading.value ? null : handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  Color(0xFF5F52EE),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading.value
                              ?  SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              :  Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )),
                       SizedBox(height: 20),

                      // Sign in Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.off(() => LoginPage()),
                            child:  Text(
                              'Sign in',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
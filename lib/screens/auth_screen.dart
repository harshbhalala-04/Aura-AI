import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/auth_controller.dart';
import '../core/app_constant.dart';
import '../widgets/glassmorphic_container.dart';
import '../widgets/loading_widget.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppConstant.BACKGROUND_COLOR,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstant.PADDING_LARGE),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.hub_rounded,
                    size: 80, color: AppConstant.PRIMARY_COLOR),
                const SizedBox(height: AppConstant.PADDING_MEDIUM),
                Text(
                  AppConstant.APP_NAME,
                  style: GoogleFonts.outfit(
                    fontSize: AppConstant.FONT_HEADLINE,
                    fontWeight: FontWeight.bold,
                    color: AppConstant.TEXT_PRIMARY,
                  ),
                ),
                Text(
                  'Your Intelligent AI Companion',
                  style: GoogleFonts.inter(
                    fontSize: AppConstant.FONT_SUBTITLE,
                    color: AppConstant.TEXT_SECONDARY,
                  ),
                ),
                const SizedBox(height: AppConstant.PADDING_XL),
                GlassmorphicContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstant.PADDING_LARGE),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(
                            () => Text(
                              authController.isLogin.value
                                  ? 'Welcome Back'
                                  : 'Create Account',
                              style: GoogleFonts.outfit(
                                fontSize: AppConstant.FONT_TITLE,
                                fontWeight: FontWeight.w600,
                                color: AppConstant.TEXT_PRIMARY,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppConstant.PADDING_LARGE),
                          _buildTextFormField(
                            controller: _emailController,
                            hintText: 'Email',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: AppConstant.PADDING_MEDIUM),
                          _buildTextFormField(
                            controller: _passwordController,
                            hintText: 'Password',
                            icon: Icons.lock_outline,
                            obscureText: true,
                          ),
                          const SizedBox(height: AppConstant.PADDING_LARGE),
                          Obx(
                            () => authController.isLoading.value
                                ? const LoadingWidget()
                                : _buildAuthButton(),
                          ),
                          const SizedBox(height: AppConstant.PADDING_MEDIUM),
                          _buildToggleButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(color: AppConstant.TEXT_PRIMARY),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(color: AppConstant.TEXT_SECONDARY),
        prefixIcon: Icon(icon, color: AppConstant.TEXT_SECONDARY),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstant.BORDER_RADIUS_MEDIUM),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstant.BORDER_RADIUS_MEDIUM),
          borderSide:
              const BorderSide(color: AppConstant.PRIMARY_COLOR, width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hintText';
        }
        if (hintText == 'Email' && !value.contains('@')) {
          return 'Please enter a valid email';
        }
        if (hintText == 'Password' && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildAuthButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (!_formKey.currentState!.validate()) return;
          authController.handleAuth(
              _emailController.text.trim(), _passwordController.text.trim());
        },
        style: ElevatedButton.styleFrom(
          padding:
              const EdgeInsets.symmetric(vertical: AppConstant.PADDING_MEDIUM),
          backgroundColor: AppConstant.PRIMARY_COLOR,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppConstant.BORDER_RADIUS_MEDIUM),
          ),
        ),
        child: Obx(
          () => Text(
            authController.isLogin.value ? 'Login' : 'Sign Up',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: AppConstant.FONT_SUBTITLE,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    return TextButton(
      onPressed: () {
        authController.isLogin.toggle();
        _formKey.currentState?.reset();
      },
      child: Obx(
        () => Text(
          authController.isLogin.value
              ? "Don't have an account? Sign Up"
              : 'Already have an account? Sign In',
          style: GoogleFonts.inter(color: AppConstant.TEXT_SECONDARY),
        ),
      ),
    );
  }
}

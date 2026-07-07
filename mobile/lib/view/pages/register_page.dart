import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/auth_viewmodel.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey.shade500),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                Center(
                  child: Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                      ),
                    ),
                    child: const Icon(
                      Icons.graphic_eq_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                const Center(
                  child: Text(
                    "SafisAudio",
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 6),

                Center(
                  child: Text(
                    "Create your account",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  "Username",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: usernameController,
                  decoration: inputDecoration(
                    hint: "Enter username",
                    icon: Icons.person_outline,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Username wajib diisi";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 22),

                const Text(
                  "Email Address",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputDecoration(
                    hint: "you@example.com",
                    icon: Icons.email_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email wajib diisi";
                    }

                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return "Format email tidak valid";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 22),

                const Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: inputDecoration(
                    hint: "********",
                    icon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password wajib diisi";
                    }

                    if (value.length < 8) {
                      return "Minimal 8 karakter";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 22),

                const Text(
                  "Confirm Password",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword,
                  decoration: inputDecoration(
                    hint: "********",
                    icon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Konfirmasi password wajib diisi";
                    }

                    if (value != passwordController.text) {
                      return "Password tidak sama";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 34),

                SizedBox(
                  height: 58,
                  child: ElevatedButton(
                    onPressed: auth.isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            final success = await auth.register(
                              username: usernameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text,
                            );

                            if (!mounted) return;

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Registrasi berhasil. Silakan login.",
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginPage(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(auth.status),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: auth.isLoading
                            ? const SizedBox(
                                width: 26,
                                height: 26,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

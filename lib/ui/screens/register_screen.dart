import 'package:flutter/material.dart';
import 'package:online_bank/data/services/auth_firebase_services.dart';
import 'package:online_bank/data/services/user_firebase_services.dart';
import 'package:online_bank/ui/screens/login_screen.dart';
import 'package:online_bank/ui/screens/user_info_add.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController confirmPasswordText = TextEditingController();
  final TextEditingController emailText = TextEditingController();
  final TextEditingController passwordText = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authHttpServices = FirebaseAuthServices();
  final userFirebaseServices = UserFirebaseServices();

  bool isLoading = false;
  String? errorMessage;

  void submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      if (confirmPasswordText.text == passwordText.text) {
        await _authHttpServices.registerUser(
          email: emailText.text,
          password: passwordText.text,
        );
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const UserInfoScreen(),
          ),
        );
      } else {
        throw Exception('Passwords do not match');
      }
    } catch (e) {
      if (e.toString().contains('EMAIL_ALREADY_IN_USE')) {
        errorMessage =
            'The email address is already in use by another account.';
      } else if (e.toString().contains('WEAK_PASSWORD')) {
        errorMessage =
            'The password is too weak. Please enter a stronger password.';
      } else if (e.toString().contains('INVALID_EMAIL')) {
        errorMessage =
            'The email address is not valid. Please enter a valid email address.';
      } else {
        errorMessage =
            'An error occurred during registration. Please try again.';
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    confirmPasswordText.dispose();
    emailText.dispose();
    passwordText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(1, 33, 149, 243),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return const LoginScreen();
              },
            ));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 119, 255),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 50,
                  bottom: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: emailText,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Colors.grey.shade300,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        labelText: "name@gmail.com",
                        labelStyle: const TextStyle(color: Colors.grey),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Input Email";
                        }
                        if (!value.contains("@")) {
                          return "Input --> @";
                        }
                        return null;
                      },
                    ),
                    if (errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: passwordText,
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.grey.shade300,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        labelText: "Enter Password",
                        labelStyle: const TextStyle(color: Colors.grey),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Input Password";
                        }
                        if (value.length < 6) {
                          return "Password min 6";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: confirmPasswordText,
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.grey.shade300,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        labelText: "Confirm Password",
                        labelStyle: const TextStyle(color: Colors.grey),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Confirm Password";
                        }
                        if (value != passwordText.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              isLoading
                  ? const CircularProgressIndicator()
                  : ZoomTapAnimation(
                      onTap: submit,
                      child: Container(
                        width: 328,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color.fromARGB(244, 33, 54, 215),
                        ),
                        child: const Center(
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const LoginScreen();
                          },
                        ),
                      );
                      isLoading = false;
                      setState(() {});
                    },
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

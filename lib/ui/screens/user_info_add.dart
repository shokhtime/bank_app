import 'package:flutter/material.dart';
import 'package:online_bank/data/services/user_firebase_services.dart';
import 'package:online_bank/ui/screens/home_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final userFirebaseServices = UserFirebaseServices();
  // File? _imageFile;

  bool isLoading = false;

  void submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });

      try {
        if (nameController.text.isNotEmpty) {
          await userFirebaseServices.addUser(nameController.text);
          setState(() {
            isLoading = false;
          });

          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return const HomeScreen();
            },
          ));
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        // Handle the error appropriately, e.g., show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(1, 33, 149, 243),
        title: const Text(
          "Fill Your Profile",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 25),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                child: TextFormField(
                  controller: nameController,
                  style: TextStyle(
                    color: Colors.grey.shade300,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    labelText: "Your full name",
                    labelStyle: const TextStyle(color: Colors.grey),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1.0,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 15),
              const SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoading
                      ? const CircularProgressIndicator()
                      : ZoomTapAnimation(
                          onTap: submit,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.90,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: const Color.fromARGB(255, 33, 150, 243),
                            ),
                            child: const Center(
                              child: Text(
                                "Save",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:social_network/views/home_page.dart';
import 'package:social_network/views/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import '../models/user.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  UserController uc = Get.find<UserController>();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 200),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.black.withOpacity(0.5),
          ),
          child: SizedBox(
            height: 350,
            width: 300,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: const Text(
                        'PicShare',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontFamily: 'GenshinFont',
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(0, 3.0),
                              blurRadius: 3.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.group,
                      color: Colors.white,
                      size: 35,
                    ),
                  ],
                ),
                Form(
                  key: _key,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: TextFormField(
                          controller: _emailController,
                          textAlign: TextAlign.left,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none),
                            hintText: 'ex:user123@gmail.com',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon:
                                const Icon(Icons.mail, color: Colors.black),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Required Field!!';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: TextFormField(
                          controller: _passwordController,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.black,
                            backgroundColor: Colors.white,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            prefixIcon: const Icon(Icons.lock_rounded,
                                color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'ex:123...',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Required Field!!';
                            }
                            return null;
                          },
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                Get.to(() => const RegistrationScreen()),
                            child: Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: const Text(
                                'Not Registered?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                  decorationThickness: 2.2,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 47),
                            padding: const EdgeInsets.only(right: 12),
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () async {
                                if (_key.currentState!.validate()) {
                                  User? loggedUser = await widget.uc.getByLogin(
                                      _emailController.text,
                                      _passwordController.text);

                                  if (loggedUser != null) {
                                    try {
                                      Get.to(() =>
                                          HomePage(currentUser: loggedUser));
                                    } catch (e) {
                                      e.printError();
                                    }
                                  }
                                }
                              },
                              child: const Row(
                                children: [
                                  Text("Login",
                                      style: TextStyle(color: Colors.white)),
                                  Icon(Icons.arrow_forward,
                                      color: Colors.white),
                                ],
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

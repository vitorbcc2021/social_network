import 'package:social_network/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_page.dart';
import '../models/user.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  UserController uc = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 150),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.black.withOpacity(0.5),
          ),
          child: SizedBox(
            height: 475,
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
                const Text(
                  'User Registration',
                  style: TextStyle(
                    fontSize: 23,
                    fontFamily: 'GenshinFont',
                    color: Colors.white,
                  ),
                ),
                Form(
                  key: _key,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: TextFormField(
                          controller: _userNameController,
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
                            hintText: 'ex:User123',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon:
                                const Icon(Icons.person, color: Colors.black),
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
                            horizontal: 20, vertical: 10),
                        child: TextFormField(
                            controller: _emailController,
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
                              prefixIcon:
                                  const Icon(Icons.mail, color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'ex:user123@gmail.com',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Required Field!!';
                              }

                              return null;
                            }),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
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
                            }),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: const Text(
                                'Already a User?',
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
                            margin: const EdgeInsets.only(left: 32),
                            padding: const EdgeInsets.only(right: 12),
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                User newUser = User(
                                    userName: _userNameController.text,
                                    email: _emailController.text);

                                if (_key.currentState!.validate()) {
                                  if (await uc.addUser(
                                      user: newUser,
                                      email: _emailController.text,
                                      password: _passwordController.text)) {
                                    Get.off(
                                        () => HomePage(currentUser: newUser));
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    showDialog(
                                      context: context,
                                      builder: (context) => const Text(
                                          'This User Already Exists!'),
                                    );
                                  }
                                }
                              },
                              child: const Row(
                                children: [
                                  Text("Register",
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

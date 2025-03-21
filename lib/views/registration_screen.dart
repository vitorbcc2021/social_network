import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import 'home_page.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _key = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final uc = Get.find<UserController>();

  bool _isPasswordVisible = false;

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
                          },
                        ),
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
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            prefixIcon: const Icon(Icons.lock_rounded,
                                color: Colors.black),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
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
                                final uc = Get.find<UserController>();

                                if (_key.currentState!.validate()) {
                                  final success = await uc.register(
                                    _userNameController.text,
                                    _emailController.text,
                                    _passwordController.text,
                                  );

                                  if (success) {
                                    Get.off(() => const HomePage());
                                  } else {
                                    Get.defaultDialog(
                                      title: 'Oops!',
                                      middleText:
                                          'Este email já está cadastrado',
                                      textConfirm: 'OK',
                                      confirmTextColor: Colors.white,
                                      onConfirm: Get.back,
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

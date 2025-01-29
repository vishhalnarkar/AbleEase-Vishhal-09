import 'dart:typed_data';

import 'package:ableeasefinale/pages/UI/homePage.dart';
import 'package:ableeasefinale/pages/UI/parentPage.dart';
import 'package:ableeasefinale/pages/UI/text_field_input.dart';
import 'package:ableeasefinale/pages/doctorPages/doctorparentPage.dart';
import 'package:ableeasefinale/resources/auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class DoctorRegister extends StatefulWidget {
  const DoctorRegister({Key? key}) : super(key: key);

  @override
  _DoctorRegisterState createState() => _DoctorRegisterState();
}

class _DoctorRegisterState extends State<DoctorRegister> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpDoctor(
      mail: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
    );
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const doctorParentPage()),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      body: Center(
        // Parent Container
        child: Container(
          width: 325,
          height: 470, // Increased height of the container
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "WELCOME",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 30.0, // Decreased top padding
                  right: 40,
                  left: 40,
                ),
                child: Form(
                  child: Column(
                    children: [
                      TextFieldInput(
                          textEditingController: _usernameController,
                          hintText: "Enter Username (max:8)",
                          textInputType: TextInputType.text,
                          prefixIcon: Icon(Icons.person)),
                      const SizedBox(
                        height: 15, // Decreased height between input fields
                      ),
                      TextFieldInput(
                          textEditingController: _emailController,
                          hintText: "Enter Your Email",
                          textInputType: TextInputType.emailAddress,
                          prefixIcon: Icon(Icons.mail)),
                      const SizedBox(
                        height: 15, // Decreased height between input fields
                      ),
                      TextFieldInput(
                          textEditingController: _passwordController,
                          hintText: "Password",
                          textInputType: TextInputType.text,
                          prefixIcon: Icon(Icons.key),
                          isPass: true),
                      const SizedBox(
                        height: 20, // Decreased height between input fields
                      ),
                      InkWell(
                        onTap: signUpUser,
                        child: Container(
                          width: 150,
                          height: 50,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            color: Color(0xffEA3EF7),
                          ),
                          child: !_isLoading
                              ? const Text(
                                  'Register',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                )
                              : const CircularProgressIndicator(
                                  color: Colors.blue,
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
      ),
    );
  }
}

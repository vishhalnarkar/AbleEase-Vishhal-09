import 'package:ableeasefinale/pages/UI/detailsPage.dart';
import 'package:ableeasefinale/pages/UI/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegPatientdoctor extends StatelessWidget {
  const RegPatientdoctor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 325,
          height: 450,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Register",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              // Here
              ConstrainedBox(
                constraints:
                    const BoxConstraints.tightFor(width: 275, height: 60),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // ignore: avoid_print
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const DetailsPage()));
                  },
                  icon: const Icon(
                    Icons.medical_services_outlined,
                    color: Colors.black,
                    // size: 50,
                  ),
                  label: const Text(
                    "Register as Doctor",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      elevation: MaterialStatePropertyAll(10)),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ConstrainedBox(
                constraints:
                    const BoxConstraints.tightFor(width: 275, height: 60),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // ignore: avoid_print
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                  },
                  icon: const Icon(
                    Icons.healing_outlined,
                    size: 37,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "Register as Patient",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      elevation: MaterialStatePropertyAll(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

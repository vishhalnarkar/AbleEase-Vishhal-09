// ignore_for_file: camel_case_types, file_names
import 'package:ableeasefinale/pages/UI/insightsPage.dart';
import 'package:ableeasefinale/pages/doctorPages/doctorInsights.dart';
import 'package:ableeasefinale/pages/doctorPages/doctorLineChart.dart';
import 'package:ableeasefinale/resources/auth_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class doctorProfilePage extends StatefulWidget {
  const doctorProfilePage({super.key});
  @override
  State<doctorProfilePage> createState() => _doctorProfilePageState();
}

class _doctorProfilePageState extends State<doctorProfilePage> {
  var authMethods = AuthMethods();
  String username = "Jayesh";

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  // Fetch the username of the current user - DB Stuff Start
  void getUsername() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      username = (snap.data() as Map<String, dynamic>)['username'];
      username = username.substring(
        8,
      );
      username = username.trim();
    });
  }
  // Fetch the username of the current user - DB Stuff End

  String getGreetings() {
    DateTime now = DateTime.now();
    int currentHour = now.hour;

    if (currentHour < 12) {
      return "Good Morning,";
    } else if (currentHour < 18) {
      return "Good Afternoon,";
    } else {
      return "Good Evening,";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main Home Column
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Notification Bar Padding
          const SizedBox(
            height: 42,
            // 37 looked perfect
            // 42 perfect starts right after the notification bar
          ),

          // For Name and Icon
          SizedBox(
            // color: Colors.white,
            height: 200,
            width: 411,

            // To align Name and Icon side by side
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              // To align greattings and Name One below the other
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getGreetings(),
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w300),
                    ),
                    Expanded(
                      child: Text(
                        'Dr.$username',
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w400),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),

              // For Padding
              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(right: 20, top: 20, left: 30),
                child: CircleAvatar(
                  radius: 67,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: const CircleAvatar(
                    radius: 65,
                    foregroundImage: AssetImage('assets/images/avatar.jpg'),
                  ),
                ),
              )
            ]),
          ),

          // Spacer for Padding
          const Spacer(),

          GestureDetector(
              child: const Image(
                image: AssetImage('assets/images/seeInsights.png'),
                width: 400,
                height: 300,
              ),
              onTap: () {
                Navigator.of(context).push(
                    // Insights Page Here
                    MaterialPageRoute(builder: (context) => doctorLineChart()));
              }),

          const SizedBox(
            height: 36,
          ),

          // Logout Button
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary),
                    child: Text(
                      "LOGOUT",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    onPressed: () {
                      authMethods.signOutUser(context);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

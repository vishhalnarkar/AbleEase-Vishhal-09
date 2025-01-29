import 'package:ableeasefinale/pages/UI/loginPage.dart';
import 'package:ableeasefinale/pages/UI/signIn.dart';
import 'package:ableeasefinale/pages/doctorPages/doctorPatientView.dart';
import 'package:ableeasefinale/pages/doctorPages/doctorparentPage.dart';
import 'package:ableeasefinale/pages/UI/parentPage.dart';
import 'package:ableeasefinale/pages/tasks/taskPage.dart';
import 'package:ableeasefinale/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDRymIYsNze9pkzED9w3_anF7HwzJWp9Uw',
      appId: '1:489622722242:android:96cc50ed27c50b4e3d8d5b',
      messagingSenderId: '489622722242',
      projectId: 'ableease-36e2d',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                // return const ParentPage();
                return const doctorParentPage();
                // return const DoctorSignIn();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // return const LoginPage();
            return TaskPage();
            // return const DoctorSignIn();
          },
        ),
        // home: MedTest(),
        theme: lightMode,
        darkTheme: darkMode,
        themeMode: ThemeMode.dark,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // User is logged in, fetch their role
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (userSnapshot.hasData && userSnapshot.data!.exists) {
                  final userRole =
                      userSnapshot.data!['role']; // Fetch role from Firestore
                  if (userRole == 'doctor') {
                    return const doctorParentPage();
                  } else if (userRole == 'user') {
                    return const ParentPage();
                  }
                }
                // If role is not found or invalid, log out the user
                FirebaseAuth.instance.signOut();
                return const LoginPage();
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // User is not logged in, show login page
        return const LoginPage();
      },
    );
  }
}

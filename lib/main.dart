import 'package:ableeasefinale/pages/UI/homePage.dart';
import 'package:ableeasefinale/pages/UI/loginPage.dart';
import 'package:ableeasefinale/pages/doctorPages/AssignPage.dart';
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
  ));
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
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Assignpage(),
        //   stream: FirebaseAuth.instance.authStateChanges(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.active) {
        //       if (snapshot.hasData) {
        //         // return const ParentPage();
        //         return const doctorParentPage();
        //         // return const DoctorSignIn();
        //       } else if (snapshot.hasError) {
        //         return Center(
        //           child: Text('${snapshot.error}'),
        //         );
        //       }
        //     }
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(child: CircularProgressIndicator());
        //     }

        //     // return const LoginPage();
        //     return const TaskPage();
        //     // return const DoctorSignIn();
        //   },
        // ),
        // home: MedTest(),
        theme: lightMode,
        darkTheme: darkMode,
        themeMode: ThemeMode.dark,
      ),
    );
  }
}

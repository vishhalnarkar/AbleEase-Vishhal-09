import 'dart:typed_data';

import 'package:ableeasefinale/models/user.dart' as model;
import 'package:ableeasefinale/pages/UI/loginPage.dart';
import 'package:ableeasefinale/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../pages/UI/homePage.dart';
import '../pages/UI/parentPage.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('patient').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<int> getTotalPatients() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('totalPatient')
          .doc('8G2euRnrVWto6WVPHEvF')
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        var data = snapshot.data() as Map<String, dynamic>;
        int total = data['TotalPatientInDb'];
        print(total);
        print("Now returning");
        return total; // Default to 0 if field is missing
      }
    } catch (error) {
      print('Error fetching total patients: $error');
    }
    return 0; // Return 0 in case of an error
  }

  //Sign up user
  Future<String> signUpUser({
    required String mail,
    required String password,
    required String username,
  }) async {
    String res = "Some error Occurred";
    int totalPatients = await getTotalPatients();
    totalPatients = totalPatients + 1;

    //Get Total patients
    print("Total Patients done :$totalPatients");
    print("Going inside create user function");
    try {
      // Check if email, password, and username are not empty
      if (mail.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        // Check if username length is less than 8 characters
        if (username.length < 9) {
          UserCredential cred = await _auth.createUserWithEmailAndPassword(
              email: mail, password: password);

          print("User Created");
          // model.User user = model.User(mail: mail, username: username);

          // Add user
          await _firestore.collection('patient').doc(cred.user!.uid).set({
            'PatientUid': 'P_$totalPatients',
            'PatientId': cred.user!.uid,
            'PatientName': username,
            'PatientEmail': mail,
            'PatientPassword': password,
            'role': 'patient',
          });

          await FirebaseFirestore.instance
              .collection('totalPatient')
              .doc(
                  '8G2euRnrVWto6WVPHEvF') // Replace 'uid' with the actual document ID
              .update({
            'TotalPatientInDb': FieldValue.increment(1),
          });
          res = 'success';
        } else {
          res = 'Username must be less than 8 characters';
        }
      } else {
        res = 'Please enter all the fields';
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> signUpDoctor({
    required String mail,
    required String password,
    required String username,
  }) async {
    String res = "Some error Occurred";

    try {
      // Check if email, password, and username are not empty
      if (mail.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        // Check if username length is less than 8 characters
        if (username.length < 9) {
          UserCredential cred = await _auth.createUserWithEmailAndPassword(
              email: mail, password: password);

          model.User user = model.User(mail: mail, username: username);

          // Add user
          await _firestore.collection('doctors').doc(cred.user!.uid).set({
            'DoctorId': cred.user!.uid,
            'DoctorName': username,
            'DoctorEmail': mail,
            'DoctorPassword': password,
            'role': 'doctor'
          });

          res = 'success';
        } else {
          res = 'Username must be less than 8 characters';
        }
      } else {
        res = 'Please enter all the fields';
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  //Log in user
  Future<String> logInUser({
    required String mail,
    required String password,
  }) async {
    String res = "Some error occured";

    try {
      if (mail.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: mail, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> logInDoctor({
    required String mail,
    required String password,
  }) async {
    String res = "Some error occured";

    try {
      if (mail.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: mail, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  void signOutUser(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }
}

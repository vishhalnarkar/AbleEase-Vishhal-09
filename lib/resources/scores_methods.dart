import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ScoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final uid = "";

  getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      return uid;
    } else {
      print('No user signed in.');
    }
  }

  Future<String> addUserScores({
    required int score,
    int? tries,
    required String gameCategory,
    required String gameName,
  }) async {
    try {
      String userId = await getUserId();
      var userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      var gameCategoryRef = userRef.collection('gameScore').doc('category');
      var gameCollectionRef =
          gameCategoryRef.collection(gameCategory).doc(gameName);

      // Check if the game category document exists
      var categoryData = await gameCategoryRef.get();
      if (!categoryData.exists) {
        // If it doesn't exist, create it with an initial value of '0' for totalRoundsPlayed
        await gameCategoryRef.set({'totalRoundsPlayed': 0});
      }

      // Check if the game document exists
      var gameData = await gameCollectionRef.get();
      if (!gameData.exists) {
        // If it doesn't exist, create it with an initial value of '0' for totalRoundsPlayed
        await gameCollectionRef.set({'totalRoundsPlayed': 0});
      }

      // Fetch the current total rounds played
      var totalRoundData = await gameCollectionRef.get();
      var totalRoundsPlayed = totalRoundData.data()!['totalRoundsPlayed'];

      // Increment the total rounds played and update the document
      var roundNumber = 'round_${totalRoundsPlayed + 1}';
      await gameCollectionRef
          .collection('rounds')
          .doc(roundNumber)
          .set({'score': score, 'tries': tries});
      await gameCollectionRef
          .update({'totalRoundsPlayed': totalRoundsPlayed + 1});

      print("Data added");
      return 'success';
    } catch (e) {
      print(e);
      return 'failure';
    }
  }

  Future getTotalRounds(
      {required String gameCategory, required String gameName}) async {
    // Your existing code to fetch the rounds data
    // For example:
    String userId = await getUserId();
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('gameScore')
        .doc('category')
        .collection(gameCategory)
        .doc(gameName)
        .get();

    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    // Check if data is not null and contains the key 'totalRoundsPlayed'
    if (data != null && data.containsKey('totalRoundsPlayed')) {
      // Access the value associated with the key 'totalRoundsPlayed'
      dynamic totalRoundsPlayed = data['totalRoundsPlayed'];

      // Check if the value is a double or an int
      if (totalRoundsPlayed is double) {
        return totalRoundsPlayed;
      } else if (totalRoundsPlayed is int) {
        return totalRoundsPlayed.toDouble();
      } else {
        print("error occured in getTotalROunds");
        // Handle other cases where the value cannot be cast to double
        // For example, return a default value or throw an exception
        throw Exception("totalRoundsPlayed is not a double or int");
      }
    }
  }

  Future<void> updatePreviousGame(String gameName, String imagePath) async {
    String userId = await getUserId();

    var userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    var gameCategoryRef =
        userRef.collection('previous_game').doc('game_details');

    // Check if the 'previous_game' collection exists
    var previousGameCollection = await gameCategoryRef.parent.parent!.get();
    if (!previousGameCollection.exists) {
      // If the collection doesn't exist, create it
      await userRef.collection('previous_game').doc('game_details').set({});
    }

    // Check if the 'game_details' document exists
    var gameDetailsDoc = await gameCategoryRef.get();
    if (!gameDetailsDoc.exists) {
      // If the document doesn't exist, create it
      await gameCategoryRef.set({});
    }

    // Update the fields 'gameImagePath' and 'gameName'
    await gameCategoryRef
        .update({'gameImagePath': imagePath, 'gameName': gameName});
  }
}

class GameDetailsExtractor {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> getGameName() async {
    String? gameName;

    try {
      String userId = await getUserId();
      var gameCategoryRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('previous_game')
          .doc('game_details');

      var gameDetailsDoc = await gameCategoryRef.get();
      if (gameDetailsDoc.exists) {
        gameName = gameDetailsDoc.get('gameName');
      }
    } catch (e) {
      print('Error getting game name: $e');
    }

    return gameName;
  }

  Future<String?> getGameImagePath() async {
    String? gameImagePath;

    try {
      String userId = await getUserId();
      var gameCategoryRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('previous_game')
          .doc('game_details');

      var gameDetailsDoc = await gameCategoryRef.get();
      if (gameDetailsDoc.exists) {
        gameImagePath = gameDetailsDoc.get('gameImagePath');
      }
    } catch (e) {
      print('Error getting game image path: $e');
    }

    return gameImagePath;
  }

  Future<String> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception('No user signed in.');
    }
  }
}

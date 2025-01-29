
import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String mail;
  final String username;

  const User({
    required this.mail,
    required this.username,
  });


  Map<String, dynamic> toJson() =>{
    "username":username,
    "mail":mail,
  };


  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      mail:snapshot['mail']
    );
  }
}
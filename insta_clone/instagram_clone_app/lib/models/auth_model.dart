import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  String username;
  String email;
  String uid;
  String bio;
  List followers;
  List following;
  Uint8List file;
  String photoUrl;

  UserModel(
      {required this.username,
      required this.email,
      required this.uid,
      required this.bio,
      required this.followers,
      required this.following,
      required this.file,
      required this.photoUrl});

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      file: snapshot["file"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "uid": uid,
        "bio": bio,
        "followers": followers,
        "following": following,
        "file": file,
        "photoUrl": photoUrl
      };
}

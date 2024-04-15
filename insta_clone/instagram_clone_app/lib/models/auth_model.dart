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

  static UserModel fromMap(Map<String, dynamic> snapshot) {
    Uint8List? fileData;
    if (snapshot['file'] != null) {
      if (snapshot['file'] is Uint8List) {
        fileData = snapshot['file'];
      } else if (snapshot['file'] is List<dynamic>) {
        // Handle conversion from List<dynamic> to Uint8List (e.g., for image data)
        List<dynamic> fileList = snapshot['file'];
        fileData = Uint8List.fromList(List<int>.from(fileList));
      }
    }
    return UserModel(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      file: fileData!,
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

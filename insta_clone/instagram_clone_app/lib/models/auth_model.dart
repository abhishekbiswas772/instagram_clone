import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String username;
  String email;
  String uid;
  String bio;
  List followers;
  List following;
  String photoUrl;

  UserModel(
      {required this.username,
      required this.email,
      required this.uid,
      required this.bio,
      required this.followers,
      required this.following,
      required this.photoUrl});

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }

  static UserModel fromMap(Map<String, dynamic> snapshot) {
    return UserModel(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
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
        "photoUrl": photoUrl
      };
}

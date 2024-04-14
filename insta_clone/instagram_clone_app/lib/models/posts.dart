import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String description;
  String uid;
  String username;
  String postId;
  final datePublished;
  String postUrl;
  String profileImage;
  final likes;

  PostModel({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profileImage,
    required this.likes
  });

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PostModel(
      username: snapshot["username"],
      uid: snapshot["uid"],
      description: snapshot["description"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      postUrl: snapshot["postUrl"],
      profileImage: snapshot["profileImage"],
      likes: snapshot["likes"]
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid" : uid,
        "description" : description,
        "postId" : postId,
        "datePublished" : datePublished,
        "postUrl" : postUrl,
        "profileImage" : profileImage,
        "likes" : likes
      };
}
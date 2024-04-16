// ignore_for_file: unnecessary_null_comparison

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone_app/models/auth_model.dart';
import 'package:instagram_clone_app/models/posts.dart';
import 'package:uuid/uuid.dart';

class AuthMethods {
  final FirebaseAuth _authFirebase = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storageFirebase = FirebaseStorage.instance;
  String? _authUsrId;
  User? get user => _authFirebase.currentUser;

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllPostFromFirebase() {
    return _firestore.collection('posts').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllCommentForPost(
      String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('datePublished', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserDetails(String userId) {
    return _firestore
        .collection('users')
        .where('uid', isEqualTo: userId)
        .snapshots();
  }

  // ignore: non_constant_identifier_names
  Future<bool> signup_user(String email, String password, String username,
      String bio, Uint8List fileImage) async {
    if (username.isNotEmpty &&
        password.isNotEmpty &&
        username.isNotEmpty &&
        bio.isNotEmpty &&
        fileImage != null) {
      try {
        // ignore: no_leading_underscores_for_local_identifiers
        UserCredential _userCred = await _authFirebase
            .createUserWithEmailAndPassword(email: email, password: password);
        _authUsrId = _userCred.user?.uid ?? "";

        // ignore: no_leading_underscores_for_local_identifiers
        String __downloadImageURL =
            await __uploadImageToStorage("profilePics", fileImage, false);

        // ignore: no_leading_underscores_for_local_identifiers
        UserModel __authModels = UserModel(
            username: username,
            email: email,
            uid: _authUsrId ?? "",
            bio: bio,
            followers: [],
            following: [],
            photoUrl: __downloadImageURL);

        await _firestore
            .collection('users')
            .doc(_authUsrId ?? "")
            .set(__authModels.toJson());
        return true;
      } on FirebaseAuthException catch (_) {
        return false;
      } catch (_) {
        return false;
      }
    } else {
      return false;
    }
  }

  // ignore: non_constant_identifier_names
  Future<bool> login_user(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential _ = await _authFirebase.signInWithEmailAndPassword(
            email: email, password: password);
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (_) {
      print(_);
    }
  }

  Future<String> __uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    // ignore: no_leading_underscores_for_local_identifiers
    Reference _storageReference =
        _storageFirebase.ref().child(childName).child(_authUsrId ?? "");

    if (isPost) {
      String id = const Uuid().v1();
      _storageReference = _storageReference.child(id);
    }
    // ignore: no_leading_underscores_for_local_identifiers
    UploadTask __uploadTask = _storageReference.putData(file);
    // ignore: no_leading_underscores_for_local_identifiers
    TaskSnapshot __taskSnapshot = await __uploadTask;
    // ignore: no_leading_underscores_for_local_identifiers
    String __downloadURL = await __taskSnapshot.ref.getDownloadURL();
    return __downloadURL;
  }

  Future<bool> uploadPost(String desc, Uint8List file, String uid,
      String username, String profileImage) async {
    try {
      String _photoDownloadUrl =
          await __uploadImageToStorage('posts', file, true);
      String __postId = Uuid().v1();
      PostModel _postModel = PostModel(
          description: desc,
          uid: uid,
          username: username,
          postId: __postId,
          datePublished: DateTime.now(),
          postUrl: _photoDownloadUrl,
          profileImage: profileImage,
          likes: []);
      await _firestore
          .collection('posts')
          .doc(__postId)
          .set(_postModel.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> postCommentToPost(String postId, String text, String uid,
      String name, String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now()
        });
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  Future<bool> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> performSignOut() async {
    try {
      await _authFirebase.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}

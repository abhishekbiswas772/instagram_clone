import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/Screens/add_post_screen.dart';
import 'package:instagram_clone_app/Screens/feed_screen.dart';
import 'package:instagram_clone_app/Screens/profile_screen.dart';
import 'package:instagram_clone_app/Screens/search_screen.dart';

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text("Notification"),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser?.uid ?? "",
  )
];

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/Screens/login_screen.dart';
import 'package:instagram_clone_app/resources/auth_methods.dart';
import 'package:instagram_clone_app/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLength = 0;
  int followersCount = 0;
  int followingCount = 0;
  bool isLoading = true;
  bool isFollowing = false;
  final AuthMethods _authMethods = AuthMethods();

  Widget __buildSubColumn(int count, String labelName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            labelName,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        )
      ],
    );
  }

  Widget __buildFollowButton(Function? onTap, Color backgroundColor,
      Color borderColor, String buttonName, Color txtColor) {
    return Container(
      padding: const EdgeInsets.only(top: 02),
      child: TextButton(
        onPressed: () {
          onTap!();
        },
        child: Container(
          width: 250,
          height: 30,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: borderColor,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            buttonName,
            style: TextStyle(color: txtColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where(widget.uid,
              isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? "")
          .get();
      postLength = postSnap.docs.length;
      followersCount = userSnap.data()!["followers"].length;
      followingCount = userSnap.data()!["followings"].length;
      isFollowing = userSnap
          .data()!["followers"]
          .contains(FirebaseAuth.instance.currentUser?.uid ?? "");
      userData = userSnap.data()!;
      setState(() {
        isLoading = false;
      });
    } catch (_) {
      print(_);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(userData["username"]),
        centerTitle: false,
      ),
      body: (isLoading == false)
          ? ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 40,
                            backgroundImage: NetworkImage(userData["photoUrl"]),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    __buildSubColumn(postLength, "posts"),
                                    __buildSubColumn(
                                        followersCount, "followers"),
                                    __buildSubColumn(
                                        followingCount, "following")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ((FirebaseAuth.instance.currentUser?.uid ??
                                                "") ==
                                            widget.uid)
                                        ? __buildFollowButton(() async {
                                            await _authMethods.performSignOut();
                                            if (context.mounted) {
                                              Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginScreen()));
                                            }
                                          }, mobileBackgroundColor, Colors.grey,
                                            "Signout", primaryColor)
                                        : (isFollowing)
                                            ? __buildFollowButton(
                                                () async {
                                                  await _authMethods.followUser(
                                                      (FirebaseAuth
                                                              .instance
                                                              .currentUser
                                                              ?.uid ??
                                                          ""),
                                                      userData["uid"]);
                                                  isLoading = true;
                                                  setState(() {});
                                                  getData();
                                                },
                                                Colors.white,
                                                Colors.grey,
                                                "Unfollow",
                                                Colors.black,
                                              )
                                            : __buildFollowButton(
                                                () async {
                                                  await _authMethods.followUser(
                                                      (FirebaseAuth
                                                              .instance
                                                              .currentUser
                                                              ?.uid ??
                                                          ""),
                                                      userData["uid"]);
                                                  isLoading = true;
                                                  setState(() {});
                                                  getData();
                                                },
                                                Colors.blueAccent,
                                                Colors.blueAccent,
                                                "Follow",
                                                Colors.white,
                                              )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(userData["username"],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(userData["bio"],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridView.builder(
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 1.5,
                                  childAspectRatio: 1,
                                  crossAxisCount: 3),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                (snapshot.data! as dynamic).docs[index];
                            return Container(
                              child:
                                  Image(image: NetworkImage(snap["postUrl"])),
                            );
                          });
                    })
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

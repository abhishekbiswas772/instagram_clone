import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/utils/colors.dart';

class ListPostScreen extends StatefulWidget {
  const ListPostScreen({super.key});

  @override
  State<ListPostScreen> createState() => _ListPostScreenState();
}

class _ListPostScreenState extends State<ListPostScreen> {
  late Stream<List<Map<String, dynamic>>> profileDataStream;

  @override
  void initState() {
    super.initState();
    profileDataStream = getProfileDataStream();
  }

  Stream<List<Map<String, dynamic>>> getProfileDataStream() async* {
    var myUid = FirebaseAuth.instance.currentUser?.uid ?? "";
    var postCollection = FirebaseFirestore.instance.collection('posts');

    yield* postCollection
        .where('uid', isEqualTo: myUid)
        .snapshots()
        .asyncMap((postSnap) async {
      List<Map<String, dynamic>> data = [];

      for (var postItem in postSnap.docs) {
        List uidLikes = postItem.data()["likes"];
        if (uidLikes.contains(myUid)) {
          uidLikes.remove(myUid);
        }

        for (var eachUID in uidLikes) {
          var userData = await getUserData(eachUID);
          if (userData != null) {
            List<Map<String, dynamic>> followersData =
                await getFollowersData(myUid);
            data.add({
              'uid': userData["uid"],
              'photoUrl': userData["photoUrl"],
              'username': userData["username"],
              'followers': followersData,
            });
          }
        }
      }

      return data;
    });
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    var userSnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userSnap.exists) {
      var username = userSnap.data()?["username"]?.toString() ?? "";
      var userProfilePic = userSnap.data()?["photoUrl"]?.toString() ?? "";
      return {'uid': uid, 'username': username, 'photoUrl': userProfilePic};
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getFollowersData(String uid) async {
    var userSnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    List<Map<String, dynamic>> followersData = [];

    if (userSnap.exists) {
      var followers = userSnap.data()?["followers"] ?? [];
      for (var eachFollowers in followers) {
        var followersUid = eachFollowers.toString();
        var followersUserSnap = await FirebaseFirestore.instance
            .collection('users')
            .doc(followersUid)
            .get();
        if (followersUserSnap.exists) {
          var followersUsername =
              followersUserSnap.data()?["username"]?.toString() ?? "";
          var followersPhoto =
              followersUserSnap.data()?["photoUrl"]?.toString() ?? "";
          followersData.add({
            'followers_uid': followersUid,
            'followers_username': followersUsername,
            'followers_photo': followersPhoto
          });
        }
      }
    }

    return followersData;
  }

  List<Widget> __buildLikeAndFollow(List<Map<String, dynamic>> data) {
    // print(data.toString());
    List<Widget> dataWidget = [];
    print(data.toString());
    for (var eachDetails in data) {
      var userData = eachDetails["username"] ?? "";
      var photoUrl = eachDetails["photoUrl"] ?? "";
      print(photoUrl);
      var followers = eachDetails["followers"] ?? [];
      print(followers);

      // Process each follower item
      for (var eachFollowersItem in followers) {
        var fuserData = eachFollowersItem["followers_username"] ?? "";
        var fphotoUrl = eachFollowersItem["photoUrl"] ?? "";
        dataWidget.add(
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(fphotoUrl),
              radius: 18,
            ),
            title: Row(
              children: [
                Text(
                  fuserData,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white, // Customize color as needed
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 3),
                const Text(
                  "started following you",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white, // Customize color as needed
                  ),
                ),
              ],
            ),
          ),
        );
      }

      dataWidget.add(
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(photoUrl),
            radius: 18,
          ),
          title: Row(
            children: [
              Text(
                userData,
                style: const TextStyle(
                  color: Colors.white, // Customize color as needed
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 3),
              const Text(
                "liked your post",
                style: TextStyle(
                  color: Colors.white, // Customize color as needed
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Return the complete list of widgets after processing all data items
    return dataWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Likes & Notification"),
        centerTitle: false,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: profileDataStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Map<String, dynamic>> profileData = snapshot.data!;
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: __buildLikeAndFollow(profileData),
              ),
            ),
          );
        },
      ),
    );
  }
}

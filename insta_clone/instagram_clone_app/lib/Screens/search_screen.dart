import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone_app/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowUser = false;

  getUsers(String text) async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: text)
        .get();
  }

  getPosts() async {
    await FirebaseFirestore.instance.collection('posts').get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(labelText: "Search for a user"),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUser = true;
            });
          },
        ),
      ),
      body: isShowUser
          ? FutureBuilder(
              future: getUsers(_searchController.text),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SafeArea(
                      child: Center(
                    child: CircularProgressIndicator(),
                  ));
                }
                return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              (snapshot.data! as dynamic).docs[index]
                                  ["photoUrl"]),
                        ),
                        title: Text((snapshot.data! as dynamic).docs[index]
                            ["username"]),
                      );
                    });
              })
          : FutureBuilder(
              future: getPosts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SafeArea(
                      child: Center(
                    child: CircularProgressIndicator(),
                  ));
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  staggeredTileBuilder: (index) => StaggeredTile.count(
                      (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  itemBuilder: (context, index) {
                    return Image.network(
                      (snapshot.data! as dynamic).docs[index]["postUrl"],
                      fit: BoxFit.cover,
                    );
                  },
                );
              }),
    );
  }
}
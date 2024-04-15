import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/models/auth_model.dart';
import 'package:instagram_clone_app/resources/auth_methods.dart';
import 'package:instagram_clone_app/utils/colors.dart';
import 'package:intl/intl.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final AuthMethods _authMethods = AuthMethods();
  final TextEditingController _commentController = TextEditingController();
  UserModel? model;
  final GlobalKey<ScaffoldMessengerState> _commentStateScreen =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    QuerySnapshot<Map<String, dynamic>> _snapshot =
        await _authMethods.getUserDetails(_authMethods.user?.uid ?? "").first;
    Map<String, dynamic> _modelMap = _snapshot.docs[0].data();
    UserModel _model = UserModel.fromMap(_modelMap);
    setState(() {
      model = _model;
    });
  }

  void postCommentToPost(UserModel model, context) async {
    var result = await _authMethods.postCommentToPost(widget.snap["postId"],
        _commentController.text, model.uid, model.username, model.photoUrl);
    if (context.mounted) {
      if (result == true) {
        _commentStateScreen.currentState?.showSnackBar(const SnackBar(
          content: Text("Comment Posted Sucessfully"),
          duration: Duration(milliseconds: 400),
        ));
      } else {
        _commentStateScreen.currentState?.showSnackBar(const SnackBar(
          content: Text("Comment Posted Failed"),
          duration: Duration(milliseconds: 400),
        ));
      }

      setState(() {
        _commentController.text = "";
      });
    }
  }

  Widget __buildCommentCard(Map<String, dynamic>? snap) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(snap?["profilePic"] ?? ""),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: snap?["name"] ?? "",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " ${snap?["text"] ?? ""}")
                  ])),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(snap?["datePublished"].toDate()),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(
              Icons.favorite,
              size: 16,
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments"),
        centerTitle: false,
      ),
      body: StreamBuilder(
          stream: _authMethods
              .getAllCommentForPost(widget.snap['postId'].toString()),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  return __buildCommentCard(snapshot.data?.docs[index].data());
                });
          }),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(model?.photoUrl ?? ""),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: "Comment as ${model?.username ?? ""}",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                postCommentToPost(model!, context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: const Text(
                  "Post",
                  style: TextStyle(color: blueColor),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

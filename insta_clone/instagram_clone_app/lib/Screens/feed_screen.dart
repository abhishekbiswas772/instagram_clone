import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone_app/Screens/comment_screen.dart';
import 'package:instagram_clone_app/models/auth_model.dart';
import 'package:instagram_clone_app/resources/auth_methods.dart';
import 'package:instagram_clone_app/utils/colors.dart';
import 'package:intl/intl.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final AuthMethods _authMethods = AuthMethods();
  UserModel? model;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: SvgPicture.asset(
          "assets/ic_instagram.svg",
          color: primaryColor,
          height: 32,
        ),
        backgroundColor: mobileBackgroundColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.messenger_outline,
            ),
          )
        ],
      ),
      body: StreamBuilder(
          stream: _authMethods.getAllPostFromFirebase(),
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
                  return Container(
                    child: PostCard(
                        snap: snapshot.data?.docs[index].data(), model: model!),
                  );
                });
          }),
    );
  }
}

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLike;
  const LikeAnimation(
      {super.key,
      required this.child,
      required this.isAnimating,
      this.duration = const Duration(milliseconds: 150),
      required this.onEnd,
      this.smallLike = false});

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2));
    scale = Tween<double>(begin: 1, end: 1.2).animate(_animationController);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isAnimating || widget.smallLike) {
      await _animationController.forward();
      await _animationController.reverse();
      await Future.delayed(const Duration(milliseconds: 200));

      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}

class PostCard extends StatefulWidget {
  final Map<String, dynamic>? snap;
  final UserModel model;
  const PostCard({super.key, required this.snap, required this.model});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final AuthMethods _authMethods = AuthMethods();
  bool isLikeAnimating = false;
  int commentLength = 0;

  __showDilog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: ["delete"]
                  .map((e) => InkWell(
                        onTap: () async {
                          bool result = await _authMethods.deletePost(widget.snap?["postId"] ?? "");
                          if(result == true){
                            if(context.mounted){
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          child: Text(e),
                        ),
                      ))
                  .toList(),
            ),
          );
        });
  }

  Widget __buildPostCard(
      Map<String, dynamic>? snap, BuildContext context, UserModel _model) {
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(snap?["profileImage"]),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snap?["username"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      __showDilog(context);
                    },
                    icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              bool result = await _authMethods.likePost(
                  snap?["postId"], _model.uid, snap?["likes"]);
              print(result);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    snap?["postUrl"],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                      duration: const Duration(milliseconds: 400),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 120,
                      )),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LikeAnimation(
                  isAnimating: snap?["likes"].contains(_model.uid),
                  smallLike: true,
                  onEnd: null,
                  child: IconButton(
                    onPressed: () async {
                      bool result = await _authMethods.likePost(
                          snap?["postId"], _model.uid, snap?["likes"]);
                      print(result);
                    },
                    icon: (snap?["likes"].contains(_model.uid))
                        ? const Icon(
                            Icons.favorite,
                          )
                        : const Icon(Icons.favorite_border),
                  )),
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => CommentScreen(
                                snap: snap!,
                              )))
                      .then((value) {
                    getComments();
                  });
                },
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.bookmark_border,
                  ),
                ),
              ))
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    "${snap?["likes"].length} likes",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                            text: snap?["username"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: " ${snap?["description"]}",
                          )
                        ]),
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 4, left: 10),
                child: Text(
                  "view all ${commentLength.toString()} comments",
                  style: const TextStyle(fontSize: 16, color: secondaryColor),
                )),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 2, left: 10),
            child: Text(
              DateFormat.yMMMd().format(snap?["datePublished"].toDate()),
              style: const TextStyle(fontSize: 16, color: secondaryColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap?['postId'])
        .collection('comments')
        .get();
    commentLength = snap.docs.length;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return __buildPostCard(widget.snap, context, widget.model);
  }
}

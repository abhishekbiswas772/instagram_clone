import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_app/models/auth_model.dart';
import 'package:instagram_clone_app/resources/auth_methods.dart';
import 'package:instagram_clone_app/utils/colors.dart';
import 'package:instagram_clone_app/utils/image_controller.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});
  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController __captionTextController = TextEditingController();
  final AuthMethods _authMethods = AuthMethods();
  final GlobalKey<ScaffoldMessengerState> _addPostScaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  Uint8List? __imageFile;
  bool isImageSelected = false;
  bool isPosted = false;
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

  _selectImage(BuildContext context) {
    return showDialog(
      context: context,
      builder: ((context) {
        return SimpleDialog(
          title: const Text("Create a Post"),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Take a Photo"),
              onPressed: () async {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
                // ignore: no_leading_underscores_for_local_identifiers
                Uint8List? _imageFile =
                    await ImagePickerController.picImage(ImageSource.camera);
                setState(() {
                  __imageFile = _imageFile;
                  isImageSelected = true;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Choose from Gallery"),
              onPressed: () async {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
                // ignore: no_leading_underscores_for_local_identifiers
                Uint8List? _imageFile =
                    await ImagePickerController.picImage(ImageSource.gallery);
                setState(() {
                  __imageFile = _imageFile;
                  isImageSelected = true;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }),
    );
  }

  void __postImage(
      BuildContext context, Uint8List imagefile, UserModel model) async {
    setState(() {
      isPosted = true;
    });
    bool __resultFromFirebase = await _authMethods.uploadPost(
        __captionTextController.text,
        imagefile,
        model.uid,
        model.username,
        model.photoUrl);
    if (__resultFromFirebase) {
      if (context.mounted) {
        setState(() {
          isPosted = true;
        });
        _addPostScaffoldKey.currentState?.showSnackBar(const SnackBar(
            content: Text("Post Successfully, Please Try Again")));
        __clearImage();
      }
    } else {
      if (context.mounted) {
        setState(() {
          isPosted = true;
        });
        _addPostScaffoldKey.currentState?.showSnackBar(
            const SnackBar(content: Text("Cannot Post, Please Try Again")));
      }
    }
  }

  void __clearImage() {
    setState(() {
      isImageSelected = false;
      __imageFile = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    __captionTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _authMethods.getUserDetails(_authMethods.user?.uid ?? ""),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return (isImageSelected == false)
              ? SafeArea(
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.upload),
                      onPressed: () => _selectImage(context),
                    ),
                  ),
                )
              : Scaffold(
                  appBar: AppBar(
                    title: const Text("Post to"),
                    centerTitle: false,
                    backgroundColor: mobileBackgroundColor,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        __clearImage();
                      },
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            __postImage(context, __imageFile!, model!);
                          },
                          child: const Text(
                            "Post",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ))
                    ],
                  ),
                  body: Column(
                    children: [
                      (isPosted == false)
                          ? Container(
                              padding: const EdgeInsets.only(top: 0),
                            )
                          : const LinearProgressIndicator(),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                snapshot.data!.docs[0].data()["photoUrl"]),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: TextField(
                                controller: __captionTextController,
                                decoration: const InputDecoration(
                                  hintText: "Write an caption...",
                                  border: InputBorder.none,
                                ),
                                maxLines: 8,
                              )),
                          SizedBox(
                            height: 45,
                            width: 45,
                            child: AspectRatio(
                              aspectRatio: 487 / 451,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    alignment: FractionalOffset.topCenter,
                                    fit: BoxFit.fill,
                                    image: MemoryImage(__imageFile!),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                      )
                    ],
                  ),
                );
        });
  }
}

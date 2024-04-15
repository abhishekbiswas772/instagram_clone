import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_app/Screens/mobile_screen_layout.dart';
import 'package:instagram_clone_app/resources/auth_methods.dart';
import 'package:instagram_clone_app/utils/colors.dart';
import 'package:instagram_clone_app/utils/image_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController __emailTxtController = TextEditingController();
  final TextEditingController __passwordTxtController = TextEditingController();
  final TextEditingController __bioController = TextEditingController();
  final TextEditingController __usernameController = TextEditingController();
  final AuthMethods __authMethods = AuthMethods();
  final GlobalKey<ScaffoldMessengerState> _signupScaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  Uint8List? __selectedImage;
  bool isLoading = false;

  void __performSignUpUser(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    String __usernameTxt = __usernameController.text;
    String __passwordTxt = __passwordTxtController.text;
    String __bioTxt = __bioController.text;
    String __emailTxt = __emailTxtController.text;
    if (__selectedImage != null) {
      bool result = await __authMethods.signup_user(
          __emailTxt, __passwordTxt, __usernameTxt, __bioTxt, __selectedImage!);
      if (result) {
        if (context.mounted) {
          setState(() {
            isLoading = false;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MobileScreenLayout(),
            ),
          );
        }
      }
    } else {
      if (context.mounted) {
        setState(() {
          isLoading = false;
        });
        _signupScaffoldKey.currentState?.showSnackBar(const SnackBar(
            content: Text("Required a Profile Pic for registring to app")));
      }
    }
  }

  void __picProfileImage(BuildContext context) async {
    Uint8List? __imageByteList =
        await ImagePickerController.picImage(ImageSource.gallery);
    if (__imageByteList != null) {
      if (context.mounted) {
        setState(() {
          __selectedImage = __imageByteList;
        });
      }
    } else {
      if (context.mounted) {
        _signupScaffoldKey.currentState?.showSnackBar(
            const SnackBar(content: Text("Image is not selected")));
      }
    }
  }

  Widget __buildTextFieldWidget(
      BuildContext context,
      TextEditingController controller,
      String hintTxt,
      bool isPassword,
      TextInputType txtInputType) {
    final borderDecoration = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintTxt,
        border: borderDecoration,
        focusedBorder: borderDecoration,
        enabledBorder: borderDecoration,
        filled: true,
        contentPadding: const EdgeInsets.all(8.0),
      ),
      keyboardType: txtInputType,
      obscureText: isPassword,
    );
  }

  Widget __createSignupButton(BuildContext context, Function onTap) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const ShapeDecoration(
            color: blueColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)))),
        child: (isLoading == false)
            ? const Text("Signup")
            : const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 2),
              SvgPicture.asset(
                "assets/ic_instagram.svg",
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(
                height: 24,
              ),
              Stack(
                children: [
                  (__selectedImage == null)
                      ? const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              "https://images.unsplash.com/photo-1579176647030-bd86f6fd4e1e?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(__selectedImage!),
                        ),
                  Positioned(
                    top: 90,
                    left: 90,
                    child: IconButton(
                      onPressed: () {
                        __picProfileImage(context);
                      },
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              __buildTextFieldWidget(context, __usernameController,
                  "Enter your username", false, TextInputType.text),
              const SizedBox(
                height: 24,
              ),
              __buildTextFieldWidget(context, __emailTxtController,
                  "Enter your email", false, TextInputType.emailAddress),
              const SizedBox(
                height: 24,
              ),
              __buildTextFieldWidget(context, __passwordTxtController,
                  "Enter your password", true, TextInputType.text),
              const SizedBox(
                height: 24,
              ),
              __buildTextFieldWidget(context, __bioController, "Enter your bio",
                  false, TextInputType.text),
              const SizedBox(
                height: 24,
              ),
              __createSignupButton(context, () {
                __performSignUpUser(context);
              }),
              const SizedBox(height: 12),
              Flexible(child: Container(), flex: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Already have an account"),
                  ),
                  const SizedBox(width: 3),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Log in.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}

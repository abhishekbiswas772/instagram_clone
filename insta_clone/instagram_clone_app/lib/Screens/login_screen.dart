import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone_app/Screens/mobile_screen_layout.dart';
import 'package:instagram_clone_app/Screens/signup_screen.dart';
import 'package:instagram_clone_app/resources/auth_methods.dart';
import 'package:instagram_clone_app/utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController __emailTxtController = TextEditingController();
  final TextEditingController __passwordTxtController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _loginScaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final AuthMethods __authMethods = AuthMethods();
  bool isLoading = false;

  void __performUserLogin(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    String __emailText = __emailTxtController.text;
    String __passwordText = __passwordTxtController.text;
    bool result = await __authMethods.login_user(__emailText, __passwordText);
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
    } else {
      if (context.mounted) {
        _loginScaffoldKey.currentState?.showSnackBar(const SnackBar(
            content: Text(
                "Failed to login user in app, Please check the cred or try again latter")));
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

  Widget __createLoginButton(BuildContext context, Function onTap) {
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
            ? const Text("Log in")
            : const CircularProgressIndicator(
                color: primaryColor,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
              height: 64,
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
            __createLoginButton(context, () {}),
            const SizedBox(height: 12),
            Flexible(child: Container(), flex: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text("Don't have an account"),
                ),
                const SizedBox(width: 3),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignupScreen()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      "Sign up.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}

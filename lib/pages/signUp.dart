import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather_monitoring/model/user.dart';
import 'package:weather_monitoring/wedget/logbutton.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController gmail = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController user_name = TextEditingController();
  void create() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: gmail.text,
        password: password.text,
      );
      NewUser user = NewUser(
          email: gmail.text.toLowerCase(), name: user_name.text.toLowerCase());
      user.addUser();

      Navigator.of(context).pushReplacementNamed("home");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(
        'assets/image5.jpeg',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
      Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromARGB(137, 33, 149, 243),
            Color.fromARGB(176, 244, 67, 54),
          ],
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _page(),
        ),
      ),
    ]);
  }

  Widget _page() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
              _icon(),
              const SizedBox(height: 50),
              _inputField("Username", user_name),
              const SizedBox(height: 20),
              _inputField("Gmail", gmail),
              const SizedBox(height: 20),
              _inputField("Password", password, isPassword: true),
              const SizedBox(height: 50),
              LogButton(
                label: "Sign Up",
                onPressed: () => create(),
              ),
              const SizedBox(height: 20),
              _extraText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _icon() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          shape: BoxShape.circle),
      child: const Icon(Icons.person, color: Colors.white, size: 120),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller,
      {isPassword = false}) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.white));

    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword,
    );
  }

  Widget _extraText() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacementNamed("login");
      },
      child: const Text(
        "Already have an account?",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}

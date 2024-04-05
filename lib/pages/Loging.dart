import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather_monitoring/wedget/inputField.dart';
import 'package:weather_monitoring/wedget/logbutton.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String passwordError = "";
  Future Loging() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameController.text, password: passwordController.text);
      Navigator.of(context).pushNamed("home");
    } on FirebaseAuthException catch (e) {
      setState(() {
        passwordError = "Wrong password/Email";
        usernameController = TextEditingController();
        passwordController = TextEditingController();
      });
      print(e.code);
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
              const SizedBox(height: 70),
              _icon(),
              const SizedBox(height: 50),
              InputField(
                controller: usernameController,
                hintText: "Username",
              ),
              const SizedBox(height: 20),
              InputField(
                  hintText: "Password",
                  controller: passwordController,
                  isPassword: true),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(passwordError,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 50),
              LogButton(
                label: "Loging",
                onPressed: () => Loging(),
              ),
              const SizedBox(height: 20),
              _googleSign(),
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

  Widget _googleSign() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        primary: Color.fromARGB(255, 221, 103, 24),
        onPrimary: const Color.fromARGB(255, 249, 250, 250),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      child: const SizedBox(
          width: double.infinity,
          child: Text(
            "Sign in with google ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          )),
    );
  }

  Widget _extraText() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacementNamed("signup");
      },
      child: const Text(
        "Don't have an account?",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}


// MaterialButton(
//           minWidth: double.infinity,
//           height: 40,
//           color: Color.fromARGB(255, 231, 129, 11),
//           onPressed: () {
//             signInWithGoogle();
//           },
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Center(
//             child: Text(
//               "Login with google",
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 18,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ),
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather_monitoring/wedget/logbutton.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Future Loging() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameController.text, password: passwordController.text);
      Navigator.of(context).pushNamed("home");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
  // Future signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;

  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );

  //   // Once signed in, return the UserCredential
  //   await FirebaseAuth.instance.signInWithCredential(credential);
  //   Navigator.of(context).pushNamedAndRemoveUntil("homepage", (route) => false);
  // }

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
              _inputField("Username", usernameController),
              const SizedBox(height: 20),
              _inputField("Password", passwordController, isPassword: true),
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

  Widget _googleSign() {
    return ElevatedButton(
      onPressed: () {},
      child: const SizedBox(
          width: double.infinity,
          child: Text(
            "Sign in with google ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          )),
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        primary: Color.fromARGB(255, 221, 103, 24),
        onPrimary: const Color.fromARGB(255, 249, 250, 250),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
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
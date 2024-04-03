import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewUser {
  String? name;
  String? email;
  String? status;

  NewUser({required this.name, required this.email});

  // Create a CollectionReference called users that references the firestore collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'full_name': name,
          'email': email,
          'id': FirebaseAuth.instance.currentUser!.uid,
          'status': 'user',
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  getuser() async {
    String a;
    String b;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where('id', isEqualTo: "${FirebaseAuth.instance.currentUser!.uid}")
        .get();

    querySnapshot.docs.forEach((element) {
      name = element['full_name'];
      status = element['status'];
    });
  }
}

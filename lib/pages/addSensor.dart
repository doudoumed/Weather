import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weather_monitoring/wedget/inputField.dart';

class AddPlace extends StatefulWidget {
  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  final Sensorname = TextEditingController();

  File? file;
  XFile? imageregion;
  var url;

  getImage() async {
    imageregion = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageregion != null) {
      setState(() {
        file = File(imageregion!.path);
      });
      Reference refSt = FirebaseStorage.instance.ref().child(imageregion!.name);

      UploadTask uptask = refSt.putFile(File(imageregion!.path));
      TaskSnapshot snp = await uptask;
      url = await refSt.getDownloadURL();
      setState(() {});
    }
  }

  CollectionReference place = FirebaseFirestore.instance.collection('sensors');

  Future<void> addRegion() {
    return place.add({
      'name': Sensorname.text,
      'image': url,
    });
    /*try {
      firebase_storeg.UploadTask uploadTask;
      firebase_storeg.Reference ref = firebase_storeg.FirebaseStorage.instance
          .ref()
          .child('img')
          .child('/' + imageregion!.name);
      uploadTask = ref.putFile(File(imageregion!.path));
      await uploadTask.whenComplete(() => null);
      url = await ref.getDownloadURL();
      setState(() {});
    } catch (e) {
      print(e);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
            resizeToAvoidBottomInset: true,
            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Color.fromARGB(0, 255, 255, 255),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("home", (route) => false);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        if (url != null)
                          Image.network(
                            url!,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        SizedBox(
                          height: 20,
                        ),
                        InputField(
                            hintText: "Sensorname", controller: Sensorname),
                        SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 40,
                          onPressed: () {
                            getImage();
                          },
                          color: (url != null)
                              ? Color.fromARGB(255, 102, 218, 7)
                              : Color(0xff0095FF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "Select image",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 40,
                          onPressed: () {
                            addRegion();
                          },
                          color: Color(0xff0095FF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "Add",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

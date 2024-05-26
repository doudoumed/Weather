import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_monitoring/wedget/menu.dart';
import 'package:share/share.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

const IconData sensors = IconData(0xe576, fontFamily: 'MaterialIcons');
final databaseReference = FirebaseDatabase.instance.ref("StoreData/data");

class _homeState extends State<home> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late Future<Map<String, dynamic>> _dataFuture;
  String? userName;
  String? status;

  getuser() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      userName = querySnapshot.docs[0]['full_name'];
      status = querySnapshot.docs[0]['status'];
    });
  }

  @override
  void initState() {
    FirebaseAuth.instance.idTokenChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
    _dataFuture = fetchData();
    getuser();
  }

  // static const IconData login_outlined =
  //     IconData(0xf198, fontFamily: 'MaterialIcons');

  final databaseReference = FirebaseDatabase.instance.ref("StoreData");

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://weather-21208-default-rtdb.europe-west1.firebasedatabase.app/StoreData/data.json'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  final String fileUrl =
      "https://docs.google.com/spreadsheets/d/1LE9ps6IYIQ58G7f7IecJSTGTGnoVfrLCe0Q5FVDyYt0/gviz/tq?tqx=out:csv&sheet=data_weather";
  String? filePath;

  Future<void> requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      downloadFile();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Storage permission is required to download the file')),
      );
    }
  }

  Future<void> downloadFile() async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Could not find external storage directory');
      }
      final path = '${directory.path}/downloaded_sheet.csv';
      final dio = Dio();
      final response = await dio.download(fileUrl, path);
      if (response.statusCode == 200) {
        setState(() {
          filePath = path;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File downloaded to $path')),
        );
      } else {
        print("Failed to download file. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download file: $e')),
      );
    }
  }

  void _viewFile() {
    if (filePath != null) {
      Share.shareFiles([filePath!], text: 'Check out this CSV file');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File not downloaded yet')),
      );
    }
  }

  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('HH:mm');
  DateFormat dayformat = DateFormat("EEE M-d yyyy");
  // int i = 0;
  // List<Widget> pages = [homepage(), remote_page(), stat_page()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            _globalKey.currentState!.openDrawer();
          },
          icon: const Icon(
            Icons.menu,
            size: 30,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: GestureDetector(
              onTap: () {
                downloadFile();
                // setState(() {
                //   _dataFuture = fetchData();
                //   now = DateTime.now();
                // });
                // Navigator.of(context)
                //     .pushNamedAndRemoveUntil("home", (route) => false);
              },
              child: SvgPicture.asset(
                'assets/rest.svg',
                height: 30,
                width: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Stack(children: [
        Image.asset(
          'assets/image5.jpeg',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        Container(
          decoration: const BoxDecoration(color: Color.fromARGB(115, 0, 0, 0)),
        ),
        FutureBuilder(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return const Center(
                child: Text(
                  'Failed to load data. Please check your internet connection.',
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else {
              Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;

              return Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 150,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _viewFile();
                                    },
                                    child: Text(
                                      '${data['temperature']}°C',
                                      style: const TextStyle(
                                        fontSize: 85,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        height: 5,
                                        width: 80,
                                        color: Colors.white38,
                                      ),
                                      Container(
                                        height: 5,
                                        width: data['temperature'] / 2,
                                        color: Colors.redAccent,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data['localisation ']}',
                                style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                dayformat.format(now),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Last Updated: ${formatter.format(now)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 40),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white30,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'Wind',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    '34',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    'km/h',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        height: 5,
                                        width: 50,
                                        color: Colors.white38,
                                      ),
                                      Container(
                                        height: 5,
                                        width: 8 / 2,
                                        color: Colors.greenAccent,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: [
                                  const Text(
                                    'Rain',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    '66',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    '%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        height: 5,
                                        width: 50,
                                        color: Colors.white38,
                                      ),
                                      Container(
                                        height: 5,
                                        width: 7 / 2,
                                        color: Colors.redAccent,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: [
                                  const Text(
                                    'Humidy',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${data['humidity']}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    '%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        height: 5,
                                        width: 50,
                                        color: Colors.white38,
                                      ),
                                      Container(
                                        height: 5,
                                        width: data['humidity'] / 2,
                                        color: Colors.redAccent,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ]),
      drawer: Menu(
        globalKey: _globalKey,
        userName: userName,
        status: status,
      ),
    );
  }
}

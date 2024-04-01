import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:weather_monitoring/wedget/custom_icon_button.dart';
import 'package:weather_monitoring/wedget/logbutton.dart';

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
                setState(() {
                  _dataFuture = fetchData();
                  now = DateTime.now();
                });
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
                                  Text(
                                    '${data['temperature']}°C',
                                    style: const TextStyle(
                                      fontSize: 85,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
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
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(158, 0, 0, 0),
        width: 275,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 30, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _globalKey.currentState!.closeDrawer();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: FirebaseAuth.instance.currentUser == null
                        ? LogButton(
                            label: "Loging",
                            onPressed: () {
                              Navigator.of(context).pushNamed("login");
                            },
                          )
                        : Profil(),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("stat");
                    },
                    child: const drawItem(
                      title: "statistics",
                      icon: Icons.query_stats,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {},
                    child: const drawItem(
                      title: "Alerts",
                      icon: Icons.notifications,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("remot");
                    },
                    child: const drawItem(
                      title: "Control",
                      icon: Icons.settings,
                    ),
                  ),
                ],
              ),
              if (FirebaseAuth.instance.currentUser != null)
                LogButton(
                  label: "Log out",
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("home", (route) => false);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Profil extends StatelessWidget {
  const Profil({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      width: double.maxFinite,
      child: Card(
        color: Colors.white38,
        elevation: 0.4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    shape: BoxShape.circle),
                child: const Icon(Icons.person, color: Colors.white, size: 30),
              ),
              SizedBox(
                width: 20,
              ),
              Text(FirebaseAuth.instance.currentUser!.email.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class drawItem extends StatelessWidget {
  final String title;
  final IconData icon;
  const drawItem({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(
            width: 50,
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          )
        ],
      ),
    );
  }
}


  


// onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//               Navigator.of(context)
//                   .pushNamedAndRemoveUntil("login", (route) => false);
//             },

// pages[i],
//       bottomNavigationBar: BottomNavigationBar(
//         elevation: 0,
//         type: BottomNavigationBarType.fixed,
//         onTap: (index) {
//           setState(() {
//             i = index;
//           });
//         },
//         backgroundColor: Color.fromARGB(143, 24, 23, 23),
//         currentIndex: i,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Ionicons.home_outline),
//             label: "Home",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.settings,
//               size: 25,
//             ),
//             label: "Control",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.query_stats),
//             label: "statistics",
//           )
//         ],
//       ),
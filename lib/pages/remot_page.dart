import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_monitoring/wedget/sensorCart.dart';

class remote_page extends StatefulWidget {
  remote_page({super.key});

  @override
  State<remote_page> createState() => _remote_pageState();
}

final databaseReference = FirebaseDatabase.instance.ref("StoreData/data");
bool? status;

class _remote_pageState extends State<remote_page> {
  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://weather-21208-default-rtdb.europe-west1.firebasedatabase.app/StoreData/data.json'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> get() async {
    // TODO: implement initState
    Map<String, dynamic> data = await fetchData();
    setState(() {
      if (data['counter'] == 0) {
        status = false;
      } else {
        status = true;
      }
    });
    print('data+++++++++++ $status');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'assets/image5.jpeg',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        Container(
          decoration: BoxDecoration(color: Color.fromARGB(115, 0, 0, 0)),
        ),
        Container(
          child: status == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SensorCard(
                  status: status,
                ),
        )
      ]),
    );
  }
}


// Container(
//           padding: EdgeInsets.all(40),
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             SizedBox(
//               height: 20,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Text(
//                   'DHT11',
//                   style: TextStyle(fontSize: 20.0, color: Colors.white),
//                 ),
//                 Switch(
//                   value: status,
//                   onChanged: (value) {
//                     if (value == true) {
//                       databaseReference.update({
//                         'counter': 1,
//                       });
//                     } else {
//                       databaseReference.update({
//                         'counter': 0,
//                       });
//                     }
//                     setState(() {
//                       status = value;
//                     });
//                   },
//                 ),
//               ],
//             ),
//             Container(
//               padding: EdgeInsets.fromLTRB(160, 0, 0, 0),
//               child: status == true
//                   ? Text(
//                       'State is ON',
//                       style: TextStyle(
//                           fontSize: 15.0,
//                           color: const Color.fromARGB(255, 8, 8, 8)),
//                     )
//                   : Text(
//                       'State is OFF',
//                       style: TextStyle(
//                           fontSize: 15.0,
//                           color: const Color.fromARGB(255, 8, 8, 8)),
//                     ),
//             ),
//           ]),
//         ),

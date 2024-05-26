import 'dart:async';
import 'dart:convert';

import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class stat_page extends StatefulWidget {
  stat_page({super.key});

  @override
  State<stat_page> createState() => _stat_pageState();
}

class _stat_pageState extends State<stat_page> {
  StreamController<List<dynamic>> _dataStreamController =
      StreamController<List<dynamic>>.broadcast();
  List<double> temp = [];
  List<double> humid = [];
  List<String> time = [];

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://script.google.com/macros/s/AKfycbwk0NReEpvzb8FKyHa-i6J3p9gI11C47COfrgI-vHWmhPH6fwvImDPp3vyULe730Q/exec'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _dataStreamController.add(data);
      for (var i = temp.length; i < data.length; i++) {
        if (formatDate2(data[i]['date']) == "03/16/2024") {
          temp.add(data[i]['temperature'] / 100);
          time.add(formatDate(data[i]['date']));
          humid.add(data[i]['humidity'] / 100);
        }
      }
      time.sort((a, b) {
        var timeA = DateFormat.Hm().parse(a);
        var timeB = DateFormat.Hm().parse(b);
        return timeA.compareTo(timeB);
      });
      setState(() {
        temp;
        time;
        humid;
      });
    } else {
      throw Exception('Failed to load data');
    }
    print(time);
  }

  String formatDate2(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('MM/dd/yyyy').format(dateTime.toLocal());
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('HH:mm').format(dateTime.toLocal());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
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
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(90, 40, 0, 0),
                child: Text(
                  "Temperature",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: time.isEmpty || temp.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : LineGraph(
                          features: [
                            Feature(
                              color: Colors.blue,
                              data: temp,
                            ),
                          ],
                          size: Size(time.length * 100, 400),
                          labelX: time,
                          labelY: [
                            '5',
                            '10',
                            '15',
                            '20',
                            '25',
                            '30',
                            '35',
                            '40'
                          ],
                          graphColor: Colors.white30,
                          graphOpacity: 0.3,
                          verticalFeatureDirection: true,
                          descriptionHeight: 80,
                        )),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(90, 40, 0, 0),
                child: Text(
                  "Humidity",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: time.isEmpty || temp.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : LineGraph(
                          features: [
                            Feature(
                              color: Colors.pink,
                              data: humid,
                            ),
                          ],
                          size: Size(time.length * 100, 400),
                          labelX: time,
                          labelY: ['20', '40', '60', '80', '100'],
                          graphColor: Colors.white30,
                          graphOpacity: 0.2,
                          descriptionHeight: 130,
                        ))
            ],
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchData,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}


// ListView.builder(
//             itemCount: data.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(data[index]['date']),
//                 subtitle: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text('${data[index]['temperature']}'),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text('${data[index]['humidity']}'),
//                     ]),
        
//                 // Add more fields as needed based on your JSON structure
//               );
//             },
//           ),



// StreamBuilder<List<dynamic>>(
//           stream: _dataStreamController.stream,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               List<dynamic> data = snapshot.data!;
//               return ListView.builder(
//                 itemCount: data.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(formatDate(data[index]['date'])),
//                     subtitle: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Text('${data[index]['temperature']}'),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Text('${data[index]['humidity']}'),
//                         ]),

//                     // Add more fields as needed based on your JSON structure
//                   );
//                 },
//               );
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Text('Error: ${snapshot.error}'),
//               );
//             } else {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         ),
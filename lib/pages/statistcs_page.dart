import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:weather_monitoring/model/table.dart';

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
  List<String> date = [];
  bool veiw = false;

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://script.google.com/macros/s/AKfycbwk0NReEpvzb8FKyHa-i6J3p9gI11C47COfrgI-vHWmhPH6fwvImDPp3vyULe730Q/exec'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _dataStreamController.add(data);
      int j = 20;
      for (var i = 0; i < data.length; i++) {
        if ((formatDate2(data[i]['date'])) == dayformat.format(now) && j > 0) {
          temp.add(data[i]['temperature'] / 100);
          time.add(formatDate(data[i]['date']));
          date.add(formatDate2(data[i]['date']));
          humid.add(data[i]['humidity'] / 100);
          j--;
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
        date;
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
  DateFormat dayformat = DateFormat("MM/dd/yyyy");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&${dayformat.format(now)}");
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
            child: veiw == false
                ? SingleChildScrollView(
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
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 80,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Table(
                              border: TableBorder.all(color: Colors.grey),
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.top,
                              children: [
                                TableRow(
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(0, 244, 67, 54),
                                    ),
                                    children: [
                                      TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          alignment:
                                              AlignmentDirectional.center,
                                          child: Text('date'),
                                        ),
                                      )),
                                      TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          alignment:
                                              AlignmentDirectional.center,
                                          child: Text('time'),
                                        ),
                                      )),
                                      TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          alignment:
                                              AlignmentDirectional.center,
                                          child: Text('temperateur'),
                                        ),
                                      )),
                                      TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          alignment:
                                              AlignmentDirectional.center,
                                          child: Text('Humidity'),
                                        ),
                                      )),
                                    ]),
                                ...List.generate(
                                    temp.length,
                                    (index) => TableRow(children: [
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text('${date[index]}'),
                                              )),
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Container(
                                                alignment:
                                                    AlignmentDirectional.center,
                                                child: Text('${time[index]}'),
                                              )),
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Container(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  child: Text(
                                                      '${temp[index] * 100}'))),
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Container(
                                                alignment:
                                                    AlignmentDirectional.center,
                                                child: Text(
                                                    '${humid[index] * 100}'),
                                              ))
                                        ]))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          )
        ]),
        floatingActionButton: SpeedDial(
          backgroundColor: Color.fromARGB(166, 255, 255, 255),
          animatedIcon: AnimatedIcons.menu_close,
          overlayColor: Colors.black,
          overlayOpacity: 0.4,
          children: [
            SpeedDialChild(
              child: Icon(Icons.download),
              onTap: () {
                downloadFile();
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.share),
              onTap: () {
                _viewFile();
              },
            ),
            SpeedDialChild(
              child: veiw == false
                  ? Icon(Icons.table_chart_rounded)
                  : Icon(Icons.data_thresholding),
              onTap: () {
                setState(() {
                  veiw = !veiw;
                });
              },
            ),
          ],
        ));
  }
}

// Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             FloatingActionButton(
//               onPressed: () {
//                 setState(() {
//                   veiw = !veiw;
//                 });
//               },
//               tooltip: 'Increment',
//               child: veiw == true
//                   ? const Icon(Icons.remove_red_eye)
//                   : const Icon(Icons.remove_red_eye_outlined),
//             ),
//             FloatingActionButton(
//               onPressed: () {
//                 setState(() {
//                   veiw = !veiw;
//                 });
//               },
//               tooltip: 'Increment',
//               child: veiw == true
//                   ? const Icon(Icons.remove_red_eye)
//                   : const Icon(Icons.remove_red_eye_outlined),
//             ),
//             FloatingActionButton(
//               onPressed: () {
//                 setState(() {
//                   veiw = !veiw;
//                 });
//               },
//               tooltip: 'Increment',
//               child: veiw == true
//                   ? const Icon(Icons.remove_red_eye)
//                   : const Icon(Icons.remove_red_eye_outlined),
//             ),
//           ],
//         )

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



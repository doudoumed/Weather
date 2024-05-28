import 'dart:async';
import 'dart:convert';

import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_monitoring/model/table.dart';

class TableData extends StatefulWidget {
  TableData({super.key});

  @override
  State<TableData> createState() => _TableDataState();
}

class _TableDataState extends State<TableData> {
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
      for (var i = temp.length; i < data.length; i++) {
        temp.add(data[i]['temperature']);
        date.add(formatDate(data[i]['date']));
        time.add(formatDate(data[i]['date']));
        humid.add(data[i]['humidity']);
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
      ]),
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







// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:weather_monitoring/model/table.dart';
// import 'package:http/http.dart' as http;

// class TableData extends StatefulWidget {
//   const TableData({super.key});

//   @override
//   State<TableData> createState() => _TableDataState();
// }

// class _TableDataState extends State<TableData> {
//   Future<List<weatherData>> weatherDataList() async {
//     var response = await http.get(Uri.parse(
//         "https://script.google.com/macros/s/AKfycbwk0NReEpvzb8FKyHa-i6J3p9gI11C47COfrgI-vHWmhPH6fwvImDPp3vyULe730Q/exec"));
//     var data = json.decode(response.body).cast<Map<String, dynamic>>();
//     List<weatherData> wetherdataList = await data
//         .map<weatherData>((json) => weatherData.fromJson(json))
//         .toList();
//     return wetherdataList;
//   }

//   Future<weatherDataGridsource> getDataSource() async {
//     var dataList = await weatherDataList();
//     return weatherDataGridsource(dataList);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Image.asset(
//             'assets/image5.jpeg',
//             fit: BoxFit.cover,
//             height: double.infinity,
//             width: double.infinity,
//           ),
//           Container(
//             decoration: BoxDecoration(color: Color.fromARGB(115, 0, 0, 0)),
//           ),
//           FutureBuilder(
//               future: getDataSource(),
//               builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (snapshot.hasError) {
//                   print('Error: ${snapshot.error}');
//                   return const Center(
//                     child: Text(
//                       'Failed to load data. Please check your internet connection.',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   );
//                 } else {
//                   return SfDataGrid(
//                       source: snapshot.data, columns: getColums());
//                 }
//               })

//           //SfDataGrid(source: source, columns: columns)
//         ],
//       ),
//     );
//   }

//   List<GridColumn> getColums() {
//     return <GridColumn>[
//       GridColumn(
//         columnName: 'date',
//         width: 70,
//         label: Container(
//           alignment: Alignment.centerLeft,
//           padding: EdgeInsets.all(8),
//           child: Text('Date'),
//         ),
//       ),
//       GridColumn(
//         columnName: 'time',
//         width: 70,
//         label: Container(
//           alignment: Alignment.centerLeft,
//           padding: EdgeInsets.all(8),
//           child: Text('Date'),
//         ),
//       ),
//       GridColumn(
//         columnName: 'location',
//         width: 70,
//         label: Container(
//           alignment: Alignment.centerLeft,
//           padding: EdgeInsets.all(8),
//           child: Text('Location'),
//         ),
//       ),
//       GridColumn(
//         columnName: 'temp',
//         width: 70,
//         label: Container(
//           alignment: Alignment.centerLeft,
//           padding: EdgeInsets.all(8),
//           child: Text('temp'),
//         ),
//       ),
//       GridColumn(
//         columnName: 'humid',
//         width: 70,
//         label: Container(
//           alignment: Alignment.centerLeft,
//           padding: EdgeInsets.all(8),
//           child: Text('humid'),
//         ),
//       )
//     ];
//   }
// }

// class weatherDataGridsource extends DataGridSource {
//   weatherDataGridsource(this.weatherList) {
//     buildDataGridRow();
//   }
//   late List<DataGridRow> dataGridRows;
//   late List<weatherData> weatherList;

//   @override
//   DataGridRowAdapter? buildRow(DataGridRow row) {
//     return DataGridRowAdapter(cells: [
//       Container(
//         child: Text(
//           formatDate2(row.getCells()[0].value.toString()),
//           overflow: TextOverflow.ellipsis,
//         ),
//         alignment: Alignment.centerLeft,
//         padding: EdgeInsets.all(8.0),
//       ),
//       Container(
//         child: Text(
//           formatDate(row.getCells()[1].value.toString()),
//           overflow: TextOverflow.ellipsis,
//         ),
//         alignment: Alignment.centerLeft,
//         padding: EdgeInsets.all(8.0),
//       ),
//       Container(
//         child: Text(
//           row.getCells()[2].value.toString(),
//           overflow: TextOverflow.ellipsis,
//         ),
//         alignment: Alignment.centerLeft,
//         padding: EdgeInsets.all(8.0),
//       ),
//       Container(
//         child: Text(
//           row.getCells()[3].value.toString(),
//           overflow: TextOverflow.ellipsis,
//         ),
//         alignment: Alignment.centerLeft,
//         padding: EdgeInsets.all(8.0),
//       ),
//       Container(
//         child: Text(
//           row.getCells()[4].value.toString(),
//           overflow: TextOverflow.ellipsis,
//         ),
//         alignment: Alignment.centerLeft,
//         padding: EdgeInsets.all(8.0),
//       )
//     ]);
//   }

//   String formatDate2(String dateString) {
//     DateTime dateTime = DateTime.parse(dateString);
//     return DateFormat('MM/dd/yyyy').format(dateTime.toLocal());
//   }

//   String formatDate(String dateString) {
//     DateTime dateTime = DateTime.parse(dateString);
//     return DateFormat('HH:mm').format(dateTime.toLocal());
//   }

//   @override
//   // TODO: implement rows
//   List<DataGridRow> get rows => dataGridRows;

//   void buildDataGridRow() {
//     dataGridRows = weatherList.map<DataGridRow>((dataGridRow) {
//       return DataGridRow(cells: [
//         DataGridCell<String>(columnName: 'date', value: dataGridRow.date),
//         DataGridCell<String>(columnName: 'time', value: dataGridRow.time),
//         DataGridCell<String>(
//             columnName: 'location', value: dataGridRow.locatin),
//         DataGridCell<int>(columnName: 'temperateur', value: dataGridRow.temp),
//         DataGridCell<int>(columnName: 'humidity', value: dataGridRow.humid),
//       ]);
//     }).toList(growable: false);
//   }
// }

// // "date":"2024-05-25T07:33:12.209Z","time":"1899-12-30T08:19:37.000Z","temperature":27,"humidity":46,"location":"Algiers"


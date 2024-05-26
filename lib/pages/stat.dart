import 'dart:async';
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class LineChartSample extends StatefulWidget {
  @override
  State<LineChartSample> createState() => _LineChartSampleState();
}

class _LineChartSampleState extends State<LineChartSample> {
  StreamController<List<dynamic>> _dataStreamController =
      StreamController<List<dynamic>>.broadcast();
  List<double> temp = [];
  List<double> humid = [];
  List<DateTime> time = [];

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://script.google.com/macros/s/AKfycbwk0NReEpvzb8FKyHa-i6J3p9gI11C47COfrgI-vHWmhPH6fwvImDPp3vyULe730Q/exec'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _dataStreamController.add(data);
      for (var i = temp.length; i < data.length; i++) {
        temp.add(data[i]['temperature'] / 100);
        time.add(formatDate(data[i]['date']) as DateTime);
        humid.add(data[i]['humidity'] / 100);
      }
      time.sort((a, b) {
        var timeA = DateFormat.Hm().parse(a as String);
        var timeB = DateFormat.Hm().parse(b as String);
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

  String formatDate2(DateTime dateString) {
    return DateFormat('MM/dd/yyyy').format(dateString.toLocal());
  }

  String formatDate(dateString) {
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
      appBar: AppBar(title: Text('Temperature and Humidity Line Graphs')),
      body: time.isEmpty || time.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: time.asMap().entries.map((entry) {
                              int idx = entry.key;
                              DateTime date = entry.value;
                              return FlSpot(
                                  date.millisecondsSinceEpoch.toDouble(),
                                  temp[idx]);
                            }).toList(),
                            isCurved: true,
                            barWidth: 4,
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                DateTime date =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        value.toInt());
                                return Text('${date.hour}:${date.minute}');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        gridData: FlGridData(show: true),
                      ),
                    ),
                  ),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: time.asMap().entries.map((entry) {
                              int idx = entry.key;
                              DateTime date = entry.value;
                              return FlSpot(
                                  date.millisecondsSinceEpoch.toDouble(),
                                  humid[idx]);
                            }).toList(),
                            isCurved: true,
                            barWidth: 4,
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                DateTime date =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        value.toInt());
                                return Text('${date.hour}:${date.minute}');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        gridData: FlGridData(show: true),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

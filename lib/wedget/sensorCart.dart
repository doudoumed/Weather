import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:weather_monitoring/pages/addSensor.dart';
import 'package:weather_monitoring/pages/remot_page.dart';

class SensorCard extends StatefulWidget {
  var status;
  List<QueryDocumentSnapshot> sensors;

  SensorCard({super.key, required this.status, required this.sensors});

  @override
  State<SensorCard> createState() => _SensorCardState();
}

class _SensorCardState extends State<SensorCard> {
  List<QueryDocumentSnapshot> sensors = [];
  getdata() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("sensors").get();
    sensors.addAll(querySnapshot.docs);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: List.generate(widget.sensors.length, (index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                          height: 135,
                          width: double.maxFinite,
                          child: Card(
                            color: Colors.white38,
                            elevation: 0.4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              // onTap: () {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => Places(
                              //             regian: widget.nearbyPlaces[index]['name']),
                              //       ));
                              // },
                              // onDoubleTap: () {
                              //   if (getuserinformation.statu == 'admin') {
                              //     AwesomeDialog(
                              //         context: context,
                              //         animType: AnimType.scale,
                              //         dialogType: DialogType.warning,
                              //         title: 'This is Ignored',
                              //         desc: 'updaye your comment',
                              //         btnCancelText: "delet",
                              //         btnOkText: "update",
                              //         btnOkOnPress: () {
                              //           Navigator.push(
                              //               context,
                              //               MaterialPageRoute(
                              //                 builder: (context) => UpdateRegion(
                              //                     url: widget.nearbyPlaces[index]['url'],
                              //                     id: widget.nearbyPlaces[index].id,
                              //                     name: widget.nearbyPlaces[index]
                              //                         ['name']),
                              //               ));
                              //         },
                              //         btnCancelOnPress: () async {
                              //           await FirebaseFirestore.instance
                              //               .collection('regians')
                              //               .doc(widget.nearbyPlaces[index].id)
                              //               .delete();
                              //           FirebaseStorage.instance
                              //               .ref(widget.nearbyPlaces[index]['url'])
                              //               .delete();
                              //           Navigator.push(
                              //               context,
                              //               MaterialPageRoute(
                              //                 builder: (context) => HomePage(),
                              //               ));
                              //         }).show();
                              //   }
                              // },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        widget.sensors[index]['image'],
                                        height: double.maxFinite,
                                        width: 130,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8),
                                                  child: Switch(
                                                    value: widget.status,
                                                    onChanged: (value) {
                                                      if (value == true) {
                                                        databaseReference
                                                            .update({
                                                          'counter': 1,
                                                        });
                                                      } else {
                                                        databaseReference
                                                            .update({
                                                          'counter': 0,
                                                        });
                                                      }
                                                      setState(() {
                                                        widget.status = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  child: widget.status == true
                                                      ? const Text(
                                                          'activated',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.0,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      24,
                                                                      58,
                                                                      25)),
                                                        )
                                                      : const Text(
                                                          'Deactivated',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.0,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 20),
                                              child: Text(
                                                widget.sensors[index]['name'],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // CATEGORIES
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPlace(),
                    ));
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                primary: Colors.white38,
                onPrimary: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const SizedBox(
                  width: 150,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: 20,
                        ),
                        Text(
                          "add sensor",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        )
      ],
    );
  }
}

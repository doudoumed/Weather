import 'package:flutter/material.dart';
import 'package:weather_monitoring/pages/remot_page.dart';

class SensorCard extends StatefulWidget {
  var status;
  SensorCard({super.key, required this.status});

  @override
  State<SensorCard> createState() => _SensorCardState();
}

class _SensorCardState extends State<SensorCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
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
                          child: Image.asset(
                            "assets/DHT11.jpg",
                            height: double.maxFinite,
                            width: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Switch(
                                        value: widget.status,
                                        onChanged: (value) {
                                          if (value == true) {
                                            databaseReference.update({
                                              'counter': 1,
                                            });
                                          } else {
                                            databaseReference.update({
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
                                              'Status is ON',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0,
                                                  color: Color.fromARGB(
                                                      255, 24, 58, 25)),
                                            )
                                          : const Text(
                                              'Status is OFF',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0,
                                                  color: Colors.red),
                                            ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Text(
                                    "DHT11",
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
    );
  }
}

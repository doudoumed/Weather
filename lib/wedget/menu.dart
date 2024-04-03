import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather_monitoring/wedget/logbutton.dart';

class Menu extends StatefulWidget {
  String? userName;
  String status;

  Menu({
    super.key,
    required this.userName,
    required this.status,
    required GlobalKey<ScaffoldState> globalKey,
  }) : _globalKey = globalKey;

  final GlobalKey<ScaffoldState> _globalKey;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String message = "";

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                        widget._globalKey.currentState!.closeDrawer();
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
                      ? Column(
                          children: [
                            LogButton(
                              label: "Loging",
                              onPressed: () {
                                Navigator.of(context).pushNamed("login");
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(message,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16)),
                            )
                          ],
                        )
                      : Profil(widget.userName),
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    if (FirebaseAuth.instance.currentUser != null) {
                      Navigator.of(context).pushNamed("stat");
                    } else {
                      setState(() {
                        message = "You must log in";
                      });
                    }
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
                if (widget.status == "admin")
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
    );
  }
}

Widget Profil(var userName) {
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(FirebaseAuth.instance.currentUser!.email.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                Text(userName,
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    ),
  );
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
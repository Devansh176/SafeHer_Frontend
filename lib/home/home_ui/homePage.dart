import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../login/login_ui/loginPage.dart';
import 'elevated_cards/elevatedCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String displayName = "";

  @override
  void initState() {
    super.initState();
    getDisplayName();
  }

  void getDisplayName() {
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null && user.displayName != null) {
      setState(() {
        displayName = user.displayName!.split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double fontSize =  height * 0.05;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[50],
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu), // ☰ Menu Icon
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(displayName, style: TextStyle(fontSize: fontSize * 0.5, fontWeight: FontWeight.bold)),
              accountEmail: Text(FirebaseAuth.instance.currentUser?.email ?? "No Email"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    FirebaseAuth.instance.currentUser?.photoURL ??
                    "https://www.gravatar.com/avatar/placeholder"
                ),
              ),
              decoration: BoxDecoration(color: Colors.green[700]),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {

              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.lightGreen[50],
      body: Padding(
        padding: EdgeInsets.only(top: height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: height * 0.05),
              child: Text(
                "Hello, $displayName !!",
                style: GoogleFonts.preahvihear(
                  color: Colors.green[800],
                  fontSize: height * 0.03,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedCard(icon: Icons.sos, color: Colors.red, label: "SOS"),
                ElevatedCard(icon: Icons.call, color: Colors.green, label: "Call"),
                ElevatedCard(icon: Icons.location_on, color: Colors.blue, label: "Location")
              ],
            ),
            SizedBox(height: height * 0.05,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedCard(icon: Icons.access_alarms, color: Colors.orange, label: "Alarm"),
                ElevatedCard(icon: Icons.local_police_outlined, color: Colors.purple, label: "Police"),
                ElevatedCard(icon: Icons.warning_amber, color: Colors.red[900]!, label: "Alert"),
              ],
            ),
            SizedBox(height: height * 0.05,),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      Colors.lightGreen[50]!
                  ),
                  side: WidgetStateProperty.all(
                    const BorderSide(
                    color: Colors.lightGreen,
                    ),
                  ),
                ),
                onPressed: (){},
                child: Text(
                  "Add Contact",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
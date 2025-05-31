import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safer/home/contacts_ui/contacts_call_page.dart';
import 'package:safer/home/home_ui/home_bloc/alert/alert_utils/alert_utils.dart';

import '../../login/login_ui/loginPage.dart';
import '../../tracking/location_bloc/location_bloc.dart';
import '../../tracking/location_bloc/location_event.dart';
import '../contacts_ui/contacts_alert_page.dart';
import 'elevated_cards/elevatedCard.dart';
import 'home_bloc/call/call_bloc.dart';
import 'home_bloc/call/utils/call_utils.dart';

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
    if (user != null && user.displayName != null) {
      setState(() {
        displayName = user.displayName!.split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double fontSize = height * 0.05;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CallBloc()),
        BlocProvider(create: (_) => LocationBloc()),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen[50],
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(displayName,
                    style: TextStyle(
                        fontSize: fontSize * 0.5, fontWeight: FontWeight.bold)),
                accountEmail:
                Text(FirebaseAuth.instance.currentUser?.email ?? "No Email"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      FirebaseAuth.instance.currentUser?.photoURL ??
                          "https://www.gravatar.com/avatar/placeholder"),
                ),
                decoration: BoxDecoration(color: Colors.green[700]),
              ),
              ListTile(
                leading: Icon(Icons.call),
                title: Text("Contacts to Call"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.notification_add),
                title: Text("Contacts to Alert"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlertContactsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: () {},
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
        body: BlocListener<CallBloc, CallState>(
          listener: (context, state) {
            if (state is CallLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Calling... 📞")),
              );
            } else if (state is CallFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${state.errorMsg} ❌")),
              );
            }
          },
          child: Padding(
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
                    ElevatedCard(
                      icon: Icons.sos,
                      color: Colors.red,
                      label: "SOS",
                      onTap: () {  },
                    ),
                    ElevatedCard(
                      icon: Icons.call,
                      color: Colors.green,
                      label: "Call",
                      onTap: () {
                        clickToCall(context);
                      },
                    ),
                    ElevatedCard(
                      icon: Icons.location_on,
                      color: Colors.blue,
                      label: "Location",
                      onTap: () {
                        context.read<LocationBloc>().add(ShareLiveLocation());
                      },
                    ),
                  ],
                ),
                SizedBox(height: height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedCard(
                      icon: Icons.access_alarms,
                      color: Colors.orange,
                      label: "Alarm",
                      onTap: () {  },
                    ),
                    ElevatedCard(
                      icon: Icons.local_police_outlined,
                      color: Colors.purple,
                      label: "Police", onTap: () {  },
                    ),
                    ElevatedCard(
                      icon: Icons.warning_amber,
                      color: Colors.red[900]!,
                      label: "Alert", onTap: () {
                        sendSmsToAlertContacts(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

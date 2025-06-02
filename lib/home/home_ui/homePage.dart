import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safer/home/contacts_ui/contacts_call_page.dart';
import 'package:safer/home/home_ui/home_bloc/location/location_sharing_bloc.dart';

import '../../login/login_ui/loginPage.dart';
import '../contacts_ui/Contact_location_Page.dart';
import 'elevated_cards/elevatedCard.dart';
import 'home_bloc/call/call_bloc.dart';
import 'home_bloc/call/utils/call_utils.dart';
import 'home_bloc/contacts/contacts_bloc.dart';

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
    context.read<ContactsBloc>().add(FetchSavedContactsEvent());
  }

  void getDisplayName() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.displayName != null) {
      setState(() {
        displayName = user.displayName!.split(" ")[0];
      });
    }
  }

  Future<bool> ensureLocationPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location permission denied ❌")),
        );
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location permission permanently denied ❌")),
      );
      return false;
    }
    return true;
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double fontSize = height * 0.05;

    return BlocProvider(
      create: (_) => CallBloc(),
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
              // ListTile(
              //   leading: Icon(Icons.notification_add),
              //   title: Text("Contacts to Alert"),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => AlertContactsPage(),
              //       ),
              //     );
              //   },
              // ),
              ListTile(
                leading: Icon(Icons.location_on_outlined),
                title: Text("Contacts to send Location"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactLocationPage(),
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
        body: MultiBlocListener(
          listeners: [
            BlocListener<CallBloc, CallState>(
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
            ),
            BlocListener<LocationSharingBloc, LocationSharingState>(
              listener: (context, state) {
                if (state is LocationSending) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sending location...")));
                } else if (state is LocationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location sent successfully")));
                } else if (state is LocationFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${state.message}")));
                }
              },
            ),
          ],
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
                      onTap: () async {
                        final state = context.read<ContactsBloc>().state;
                        if (state is ContactsLoaded) {
                          context.read<LocationSharingBloc>().add(ShareLocationEvent(selectedContacts: state.selectedContacts));
                        }
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
                    // ElevatedCard(
                    //   icon: Icons.warning_amber,
                    //   color: Colors.red[900]!,
                    //   label: "Alert", onTap: () {
                    //     sendSmsToAlertContacts(context);
                    //   },
                    // ),
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

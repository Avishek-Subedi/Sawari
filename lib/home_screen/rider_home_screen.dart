import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({Key? key}) : super(key: key);

  @override
  _RiderHomeScreenState createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Riderrr"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.of(this.context)
                      .pushReplacementNamed('/LoginScreen'));
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }
}

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:sawari/auth/login_screen.dart';
import 'package:sawari/auth/signup_screen.dart';
import 'package:sawari/home_screen/rider_home_screen.dart';
import 'package:sawari/home_screen/user_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: GoogleFonts.firaCode().fontFamily,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/SplashScreen': (BuildContext context) => SplashScreen(),
        '/LoginScreen': (BuildContext context) => LoginScreen(),
        '/SignUpScreen': (BuildContext context) => SignUpScreen(),
        '/UserHomeScreen': (BuildContext context) => UserHomeScreen(),
        '/RiderHomeScreen': (BuildContext context) => RiderHomeScreen(),
      },
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      isLoggedIn();
    });
    super.initState();
  }

  void isLoggedIn() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final user = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (user['userType'] == 1) {
        Navigator.of(context).pushReplacementNamed('/UserHomeScreen');
      } else {
        Navigator.of(context).pushReplacementNamed('/RiderHomeScreen');
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/LoginScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'lib/assets/images/sawari_animation.json',
            ),
            AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                TypewriterAnimatedText(
                  'Sawari'.toUpperCase(),
                  speed: Duration(
                    milliseconds: 200,
                  ),
                  textStyle: Theme.of(context)
                      .textTheme
                      .headline3
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
              isRepeatingAnimation: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

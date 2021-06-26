import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:sawari/widgets/circularProgressLoader.dart';
import 'package:sawari/widgets/willPopScopeAlert.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode passwordNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;
  String? _errorMessage;

  String? userId;

  Future<String> signIn(String email, String password) async {
    print('===========>' + email);
    final user = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password))
        .user;

    return user!.uid;
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (mounted)
        setState(() {
          _errorMessage = "";
          _isLoading = true;
        });

      try {
        final userId = await signIn(
            emailController.text.trim(), passwordController.text.trim());
        if (userId != null) {
          print('Signed in: $userId');

          final user = await FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .get();
          print(user['userType']);

          if (user['userType'] == 1) {
            Navigator.of(this.context).pushReplacementNamed('/UserHomeScreen');
          } else {
            Navigator.of(this.context).pushReplacementNamed('/RiderHomeScreen');
          }
          Fluttertoast.showToast(
              msg: "LoginSuccess",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.blue,
              textColor: Colors.white);
          if (mounted)
            setState(() {
              _isLoading = false;
            });
        } else {
          if (mounted)
            setState(() {
              _isLoading = false;

              _errorMessage = "Something went wrong";
            });
          Fluttertoast.showToast(
              msg: _errorMessage!,
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.red,
              textColor: Colors.white);
        }
      } catch (e) {
        if (mounted)
          setState(() {
            _isLoading = false;

            _errorMessage = e.toString();
          });
        Fluttertoast.showToast(
            msg: _errorMessage!,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    } else {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () => WillPopScopeAlert().onBackPress(context: context),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: LayoutBuilder(
                    builder: (context, constraint) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraint.maxHeight,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: Text(
                                              "Welcome,",
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        "Sign in to continue !",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 40),
                                      width: MediaQuery.of(context).size.width,
                                      height: 200,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Lottie.asset(
                                              'lib/assets/images/sawari_animation.json',
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Sawari".toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 30),
                                      width: MediaQuery.of(context).size.width,
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 18),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    0xff, 250, 94, 142),
                                                width: 2.0),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.person,
                                            color: Colors.grey,
                                          ),
                                          labelText: 'Email ID',
                                          hintText: 'Email ID',
                                        ),
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () {
                                          FocusScope.of(context)
                                              .requestFocus(passwordNode);
                                        },
                                        validator: (String? value) {
                                          final pattern =
                                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                          RegExp regex = RegExp(pattern);
                                          if (value!.isEmpty) {
                                            return 'Enter email';
                                          } else if (!regex.hasMatch(value))
                                            return 'Enter Valid Email';
                                          else
                                            return null;
                                        },
                                        controller: emailController,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 30),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: TextFormField(
                                        focusNode: passwordNode,
                                        style: TextStyle(fontSize: 18),
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    0xff, 250, 94, 142),
                                                width: 2.0),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: Colors.grey,
                                          ),
                                          suffixIcon: IconButton(
                                              icon: FaIcon(
                                                _obscureText
                                                    ? FontAwesomeIcons.eyeSlash
                                                    : FontAwesomeIcons.eye,
                                                color: Colors.deepOrange,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _obscureText = !_obscureText;
                                                });
                                              }),
                                          labelText: 'Password',
                                          hintText: 'Password',
                                        ),
                                        obscureText: _obscureText,
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'Enter password';
                                          } else if (value.length < 6) {
                                            return "Password too short";
                                          }
                                          return null;
                                        },
                                        controller: passwordController,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "Forget Password ?",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                        _validateAndSubmit();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 20),
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xfffffa578e),
                                                Color(0xfffffda68e)
                                              ],
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Center(
                                          child: Text(
                                            'Login',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(this.context)
                                          .pushNamed('/SignUpScreen');
                                    },
                                    child: Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                        child: RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                                fontFamily: 'Balsamiq Sans'),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: "I'm a new user,",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              TextSpan(
                                                text: ' Sign Up !',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                      0xff, 251, 114, 160),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _isLoading ? CircularProgressLoader() : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:sawari/widgets/circularProgressLoader.dart';
import 'package:sawari/widgets/willPopScopeAlert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode addressNode = FocusNode();
  final FocusNode contactNode = FocusNode();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;
  String? _errorMessage;
  int? accountType;
  // Perform email signup
  void _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });

      try {
        final user =
            (await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ))
                .user;

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user!.uid)
            .set({
          'userType': accountType,
          'email': emailController.text.trim(),
          'fullName': nameController.text.trim(),
          'photoUrl': "null",
          'id': user.uid,
          'address': addressController.text.trim(),
          'contact': contactController.text.trim(),
          'createdAt': DateTime.now(),
        });
        await FirebaseAuth.instance.signOut();
        Fluttertoast.showToast(
            msg: "Sign Up Success",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.blue,
            textColor: Colors.white);
        Navigator.of(this.context).pushReplacementNamed('/LoginScreen');
      } catch (e) {
        setState(() {
          _isLoading = false;

          _errorMessage = e.toString();
          Fluttertoast.showToast(
              msg: _errorMessage ?? "Something went wrong",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.red,
              textColor: Colors.white);
        });
      }
    } else {}
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
                                    DropdownFormField<int>(
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Select Account Type';
                                        }
                                      },
                                      onSaved: (value) {
                                        setState(() {
                                          accountType = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        // border: UnderlineInputBorder(),
                                        // filled: true,
                                        labelText: 'Choose account type',
                                      ),
                                      initialValue: null,
                                      items: [
                                        DropdownMenuItem<int>(
                                          value: 1,
                                          child: Text('User'),
                                        ),
                                        DropdownMenuItem<int>(
                                          value: 2,
                                          child: Text('Rider'),
                                        )
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 30),
                                      width: MediaQuery.of(context).size.width,
                                      child: TextFormField(
                                        controller: nameController,
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
                                            Icons.person,
                                            color: Colors.grey,
                                          ),
                                          labelText: 'Full Name',
                                          hintText: 'Full Name',
                                        ),
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () {
                                          FocusScope.of(context)
                                              .requestFocus(emailNode);
                                        },
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'Enter Full Name';
                                          } else if (value.length < 4) {
                                            return "Name too short";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 30),
                                      width: MediaQuery.of(context).size.width,
                                      child: TextFormField(
                                        controller: emailController,
                                        focusNode: emailNode,
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
                                            Icons.email,
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
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 30),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: TextFormField(
                                        controller: passwordController,
                                        textInputAction: TextInputAction.next,
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
                                        onEditingComplete: () {
                                          FocusScope.of(context)
                                              .requestFocus(addressNode);
                                        },
                                        obscureText: _obscureText,
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'Enter password';
                                          } else if (value.length < 6) {
                                            return "Password too short";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 30),
                                      width: MediaQuery.of(context).size.width,
                                      child: TextFormField(
                                        controller: addressController,
                                        focusNode: addressNode,
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
                                            Icons.person,
                                            color: Colors.grey,
                                          ),
                                          labelText: 'Address',
                                          hintText: 'Address',
                                        ),
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () {
                                          FocusScope.of(context)
                                              .requestFocus(contactNode);
                                        },
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'Enter address';
                                          } else if (value.length < 4) {
                                            return "Address too short";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 30),
                                      width: MediaQuery.of(context).size.width,
                                      child: TextFormField(
                                        controller: contactController,
                                        focusNode: contactNode,
                                        style: TextStyle(fontSize: 18),
                                        keyboardType: TextInputType.number,
                                        maxLength: 10,
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
                                          labelText: 'Phone Number',
                                          hintText: 'Phone Number',
                                        ),
                                        textInputAction: TextInputAction.done,
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'Enter phone number';
                                          } else if (value.length < 4) {
                                            return "Phone number too short";
                                          }
                                          return null;
                                        },
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
                                            'Sign Up',
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
                                      Navigator.of(context).pop();
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
                                                text: "Already a member,",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              TextSpan(
                                                text: ' Log In',
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

class DropdownFormField<T> extends FormField<T> {
  DropdownFormField({
    Key? key,
    InputDecoration? decoration,
    T? initialValue,
    List<DropdownMenuItem<T>>? items,
    bool autovalidate = false,
    FormFieldSetter<T>? onSaved,
    FormFieldValidator<T>? validator,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          autovalidate: autovalidate,
          initialValue: items!.contains(initialValue) ? initialValue : null,
          builder: (FormFieldState<T> field) {
            final InputDecoration effectiveDecoration = (decoration ??
                    const InputDecoration())
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);

            return InputDecorator(
              decoration: effectiveDecoration.copyWith(
                  errorText: field.hasError ? field.errorText : null),
              isEmpty: field.value == '' || field.value == null,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  value: field.value,
                  isDense: true,
                  onChanged: field.didChange,
                  items: items.toList(),
                ),
              ),
            );
          },
        );
}

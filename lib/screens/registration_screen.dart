import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rider/screens/login_screen.dart';
import 'package:rider/screens/main_page.dart';

import '../brand_colors.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

// firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  void registerUser() async {
    User? user = (await _auth
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .catchError((ex) {
      print("error : $ex");
    }))
        .user;
    if (user != null) {
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.mobile &&
          connectivityResult != ConnectivityResult.wifi) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No Internet Connection !")));
      }
      // reference from fireStore
      DocumentReference ref =
          FirebaseFirestore.instance.collection("users").doc(user.uid);
      // user data
      Map<String, dynamic> userData = {
        "fullName": fullNameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "id": user.uid,
      };
      ref.set(userData).catchError((ex) {
        print("Error Registeration : $ex");
      }).whenComplete(() => print("Registered Successfully"));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
          (route) => false);
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: globalKey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: 70,
              ),
              Image(
                alignment: Alignment.center,
                image: AssetImage("images/logo.png"),
                height: 100,
                width: 100,
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                "Create Rider account",
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      style: TextStyle(fontSize: 14),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "FullName",
                          labelStyle: TextStyle(fontSize: 14),
                          helperStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )),
                      controller: fullNameController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: phoneController,
                      style: TextStyle(fontSize: 14),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: "Phone Number",
                          labelStyle: TextStyle(fontSize: 14),
                          helperStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: emailController,
                      style: TextStyle(fontSize: 14),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Email Address",
                          labelStyle: TextStyle(fontSize: 14),
                          helperStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(fontSize: 14),
                          helperStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () {
                        registerUser();
                      },
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: BrandColors.colorGreen,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          alignment: Alignment.center,
                          height: 38,
                          child: Text(
                            "Register",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                  ],
                ),
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text("Have an account ? sign In here !"))
            ],
          ),
        ),
      ),
    ));
  }
}

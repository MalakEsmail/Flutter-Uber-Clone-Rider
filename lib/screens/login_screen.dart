import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rider/brand_colors.dart';
import 'package:rider/screens/main_page.dart';
import 'package:rider/screens/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void loginUser() async {
    User? user = (await _auth
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .catchError((ex) {
      print("error : $ex");
    }))
        .user;
    if (user != null) {
      DocumentSnapshot result = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      if (result.exists) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
            (route) => false);
      }
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
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
                "Sign In as Rider",
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
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
                      onTap: () async {
                        ConnectivityResult connectivityResult =
                            await Connectivity().checkConnectivity();
                        if (connectivityResult != ConnectivityResult.mobile &&
                            connectivityResult != ConnectivityResult.wifi) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("No Internet Connection !")));
                        }
                        loginUser();
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
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                  ],
                ),
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationScreen()));
                  },
                  child: Text("Dont have an account sign up here !"))
            ],
          ),
        ),
      ),
    ));
  }
}

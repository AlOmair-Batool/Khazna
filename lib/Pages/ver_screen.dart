import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:sim/Pages/home_screen.dart';
import 'package:sim/Pages/login_screen.dart';
import 'package:sim/Pages/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if(!isEmailVerified)
      sendVerificationEmail();

    timer = Timer.periodic(Duration(seconds: 30), (_) =>
        checkEmailVerified(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async{

    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if(isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {

    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
    setState(() => canResendEmail = false);
    await Future.delayed(Duration(seconds: 30));
    setState(() => canResendEmail = true);

  }


  @override
  Widget build(BuildContext context) =>

      isEmailVerified
          ? HomeScreen()
          : Scaffold(
        appBar: AppBar(
          title: Text('Verify Email'),
          titleTextStyle: TextStyle(color: Colors.black ,
              fontSize: 20,
              fontWeight: FontWeight.bold ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.teal.shade200),
            onPressed: () {
              //passing this to our root
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'A verification email has been sent to your Email',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,

              ),
              SizedBox(height: 24
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal.shade300,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  minimumSize: Size.fromHeight(50),

                ),
                icon: Icon(Icons.email, color: Colors.white, size:32 ),
                label: Text(
                  'Resent Email',
                  style: TextStyle(fontSize:24),

                ),
                onPressed: canResendEmail ? sendVerificationEmail : null,

              ),

              SizedBox(height: 8),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal.shade300,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    minimumSize: Size.fromHeight(50),
                  ),
                  icon: Icon(Icons.email, color: Colors.teal.shade300, size:1 ),
                  label: Text(
                    'Log in',
                    style: TextStyle(fontSize:24),
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  }
              )

            ],
          ),
        ),
      );
}

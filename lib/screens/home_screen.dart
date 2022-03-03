import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sim/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:telephony/telephony.dart';
import 'dart:async';

onBackgroundMessage(SmsMessage message) {
  debugPrint("onBackgroundMessage called");
}
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
//hailah
  String _message = "";
  final telephony = Telephony.instance;
  List<SmsMessage> messages = <SmsMessage>[];
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    getAllSMS();

  }
//hailah
  getAllSMS() async{
     messages = await telephony.getInboxSms(
         // filter: SmsFilter.where(SmsColumn.ADDRESS)
         //     .equals("6505551213")
     );


    for (var element in messages) {
      print(element.address);
      print(element.body);
      print(element.subject);

    }

  }

//end
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SmartIncomeManager"),
        backgroundColor: Colors.brown.shade200,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 150,
                //child: Image.asset("assets/logo.png", fit: BoxFit.contain),
              ),
              /*Text(
                "Welcome",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),*/

              Center(child: Text("Last 5 SMS:")),
              Center(child: Text(messages[0].body!)),
              Center(child: Text(messages[1].body!)),
              Center(child: Text(messages[2].body!)),
              Center(child: Text(messages[3].body!)),

              SizedBox(
                height: 20,
              ),
              Text("${loggedInUser.firstName} ${loggedInUser.secondName}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    height: 3,
                  )),
              Text("${loggedInUser.email}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  )),
              SizedBox(
                height: 35,
              ),
              ActionChip(
                  label: Text("Logout"),
                  backgroundColor: Colors.brown.shade200,
                  onPressed: () {
                    logout(context);
                  }),

            ],
          ),
        ),
      ),
    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}

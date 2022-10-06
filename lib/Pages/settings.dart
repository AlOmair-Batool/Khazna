import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sim/theme/colors.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  // // editing Controller
  // final firstNameEditingController = new TextEditingController();
  // final secondNameEditingController = new TextEditingController();
  // final emailEditingController = new TextEditingController();
  final passwordEditingController = TextEditingController();
  // final confirmPasswordEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: primary,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            const Text(
              "Settings",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: const [
                Icon(
                  AntDesign.user,
                  color: primary,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Account",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 0.8,
            ),
            const SizedBox(
              height: 10,
            ),
            buildAccountOptionRow(context, "Change password"),
            buildAccountOptionRow(context, "Language"),
            buildAccountOptionRow(context, "Privacy and security"),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: const [
                Icon(
                  Icons.notifications_none_rounded,
                  color: primary,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Notifications",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500), //
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 0.8,
            ),
            const SizedBox(
              height: 10,
            ),
            buildNotificationOptionRow("Updates", true),
            buildNotificationOptionRow("Daily encouragements", false),
            const SizedBox(
              height: 50,
            ),

          ],
        ),
      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isActive,
              onChanged: (bool val) {},
            ))
      ],
    );
  }
  //change password
  Widget textForm(){
    return TextFormField(
      validator: (val){
        if(val!.length <6){
          return 'Please enter password with min 6 char length!';
        }else{
          return null;
        }
      },
      key: _formKey,
      controller: passwordEditingController, ///////////////////////////////////////////////////////////////////////////////
      decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 0.0),),
          isDense: true,
          label: Text("Reset password")
      ),
    );
  }
  // Button
  // Widget alertDialog(String title, String message) {
  //   return AlertDialog(
  //     title: Text("$title") ,
  //     content: Text("$message"),
  //   );
  // }
  // void check() async{
  //   DocumentReference ref = (await FirebaseFirestore.instance.collection('users')) as DocumentReference<Object?>;
  //
  //   setState(() {
  //     ref.update(
  //         { 'password': passwordEditingController.value.text}
  //     );
  //
  //   });
  //
  // }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (_){
              return AlertDialog(

                title: const Text("New Passward"),
                content: SizedBox(
                  width: 250,
                  height: 250,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        textForm(),
                        ElevatedButton(
                          onPressed: (){
                            setState(() {
                              passwordEditingController.clear();
                            });
                            // Navigator.pop(context);
                          },
                          child: const Text("Update"),
                        )
                      ]),
                ),
              );
            });


      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.grey[600],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
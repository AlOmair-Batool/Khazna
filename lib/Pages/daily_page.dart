import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sim/theme/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sim/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telephony/telephony.dart';
import 'package:intl/intl.dart';

import 'dart:convert';

import '../json/daily_json.dart';
import 'dart:developer';
onBackgroundMessage(SmsMessage message) {
  debugPrint("onBackgroundMessage called");
}
class DailyPage extends StatefulWidget {
  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  //messeges retrieving
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String _message = "";
  final telephony = Telephony.instance;
  List<SmsMessage> messages = <SmsMessage>[];

  //variables needed for printing contents of the messages on the transactions list
  String message1 = "";
  String? message2 = "";
  List <String> transactionType = [];
  List <String> amount=[];
  List <String> date=[];
  List <String> time=[];
  List <String> icon=[];
  int totalAmount = 0;


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


  getAllSMS() async {
    messages = await telephony.getInboxSms(

        filter: SmsFilter.where(SmsColumn.ADDRESS)
            .equals("alinmabank"),
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.ASC)]

    );


    for (var message in messages) {
      //identification of Alinma messages
      //String message1 = "Deposit ATM Amount: 250 SAR Account: **8000 On: 2022-03-14 21:52";
      message1 = message.body!;
      log(message1);
      String message2 = message1.toLowerCase();

      var msgDate = message.date!;
      var dt = DateTime.fromMillisecondsSinceEpoch(msgDate);
      var dt2 = DateFormat('dd/MM/yyyy').format(dt);
      //var d24 = DateFormat('dd/MM/yyyy, HH:mm').format(dt);
      bool flag = false;
      if (message2.contains("withdrawal") || message2.contains("purchase") ||
          message2.contains("mada atheer pos purchase") ||
          message2.contains("debit transfer internal")
          || message2.contains("pos purchase") ||
          message2.contains("atheer pos")
          || message2.contains("online purchase")) {
        transactionType.insert(0, "Withdrawal");

        icon.insert(0, "assets/images/Withdrawl.png");
        date.insert(0, dt2.toString());
        flag = true;

      }
      else if (message2.contains("deposit") || message2.contains("refund") ||
          message2.contains("credit transfer internal") ||
          message2.contains("reverse transaction")) {
        transactionType.insert(0, "Deposit");

        icon.insert(0, "assets/images/Deposit.png");
        date.insert(0, dt2.toString());
        flag = true;
      }
      //date extraction
      // RegExp dateReg = RegExp(r'(\d{4}-\d{2}-\d{2})');

      //date extraction for AlAhli
      // When try it on alahli please remove the comment the comment alinma regex

      if (flag) {
        //time extraction (also works for alahli since it's the same structure
        RegExp timeReg = RegExp(r'(\d{2}:\d{2})');

        var timeMatch = timeReg.firstMatch(message2);
        if (timeMatch != null) {
          time.insert(0, timeMatch.group(0).toString());
        }
        /* RegExp dateReg = RegExp(r'(\d{4}-\d{2}-\d{2})');
        var dateMatch = dateReg.firstMatch(message2);

       if (dateMatch != null) {
          date.insert(0, msgDate.toString());*/
      }
      //amount regex
      var amountReg = RegExp(r'(?<=amount *:?)(.*)(?=sar)');
      //var amountReg = RegExp(r'(?<=amount *:?)(.*)(?=sar)');
      var amountBeforeMatch = amountReg.firstMatch(message2);
      String amountBefore = "";

      if (amountBeforeMatch != null) {
        amountBefore = amountBeforeMatch.group(0).toString();
      }
      var amountNumReg = RegExp(r'[0-9]+');
      var amountAfterMatch = amountNumReg.firstMatch(amountBefore);
      if (amountAfterMatch != null) {
        amount.insert(0, amountAfterMatch.group(0).toString());
      }


    }
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    for (var i = 0; i < transactionType.length; i++) {
      totalAmount += int.parse(amount[i]);
      DocumentReference ref = await FirebaseFirestore.instance.collection(
          'Test')
          .add({
        'Date': date[i],
        'Time': time[i],
        'Type': transactionType[i],
        'Amount': amount[i],
      });
      ref.update({
        'userID': uid
      });

          }

  }



  int activeDay = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
    );
  }
  Widget getBody() {

    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: white, boxShadow: [
                BoxShadow(
                  color: grey.withOpacity(0.01),
                  spreadRadius: 10,
                  blurRadius: 3,
                  // changes position of shadow
                ),
              ]),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 60, right: 20, left: 20, bottom: 25),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily Transaction",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: black),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            // tell batool
            /*Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: Column(
    children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      if (date.length == 0)
    Container(
    width: (size.width - 40) * 0.7,
    child: Row(
    children: [
    Container(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    "No Message has been found..",
    style: TextStyle(
    fontSize: 15,
    color: black,
    fontWeight: FontWeight.w500),
    overflow: TextOverflow.ellipsis,
    ),
    SizedBox(height: 5),

    ],
    ),
    )
    ],
    ),

    ),]
    ),
    ],
    ),
            ),*/

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                //tell batool date.length
                  children: List.generate(daily.length, (index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: (size.width - 40) * 0.7,
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: grey.withOpacity(0.1),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        icon[index],
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Container(
                                    width: (size.width - 90) * 0.5,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          //daily[index]['name'],
                                          transactionType[index],

                                          style: TextStyle(
                                              fontSize: 15,
                                              color: black,
                                              fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          // daily[index]['date'],
                                          date[index]+" "+time[index],
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: black.withOpacity(0.5),
                                              fontWeight: FontWeight.w400),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),

                            ),

                            //money container
                            Container(
                              width: (size.width - 40) * 0.3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    //daily[index]['price'],
                                    amount[index]+" SAR",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 65, top: 8),
                          child: Divider(
                            thickness: 0.8,
                          ),
                        )
                      ],
                    );
                  })),
            ),
          ],
        )
      //No message





    );

  }
}

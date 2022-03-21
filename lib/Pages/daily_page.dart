import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sim/theme/colors.dart';

import '../json/daily_json.dart';
import '../json/day_month.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sim/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'package:telephony/telephony.dart';
import 'dart:async';

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
      filter: SmsFilter.where(SmsColumn.ADDRESS).equals("alinmabank")
        /*filter: SmsFilter.where(SmsColumn.ADDRESS).equals("SNB-AlAhli")*/

    );

    for (var message in messages) {


    //identification of Alinma messages
    //String message1 = "Deposit ATM Amount: 250 SAR Account: **8000 On: 2022-03-14 21:52";
     message1 = message.body!;



    String message2 = message1.toLowerCase();






    if (message2.contains("withdrawal") || message2.contains("purchase") ||
        message2.contains("debit transfer internal")) {
      transactionType.insert(0, "Withdrawal");
      icon.insert(0,"assets/images/Withdrawl.png");
    }

    else if (message2.contains("deposit") || message2.contains("refund") ||
        message2.contains("credit transfer internal") || message2.contains("reverse transaction")) {
      transactionType.insert(0,"Deposit");
      icon.insert(0,"assets/images/Deposit.png");
    }

    //amount regex
    // var amountReg = RegExp(r'(?<=amount *:?)(.*)(?=sar)');
    var amountReg = RegExp(r'(?<=amount *:?)(.*)(?=sar)');
    var amountBeforeMatch = amountReg.firstMatch(message2);
    String amountBefore = "";

    if(amountBeforeMatch != null) {
       amountBefore = amountBeforeMatch.group(0).toString();
    }
    var amountNumReg = RegExp(r'[0-9]+');
    var amountAfterMatch = amountNumReg.firstMatch(amountBefore);

    if(amountAfterMatch != null) {
      amount.insert(0,amountAfterMatch.group(0).toString());
    }






    //date extraction
    RegExp dateReg = RegExp(r'(\d{4}-\d{2}-\d{2})');

    //date extraction for AlAhli
     // When try it on alahli please remove the comment the comment alinma regex
     // RegExp dateReg = RegExp(r'(\d{4}-\d{2}-\d{2})');
    var dateMatch = dateReg.firstMatch(message2);

    //time extraction (also works for alahli since it's the same structure
    RegExp timeReg = RegExp(r'(\d{2}:\d{2})');


    var timeMatch = timeReg.firstMatch(message2);

    if (dateMatch != null && timeMatch != null) {

      date.insert(0,dateMatch.group(0).toString());
      time.insert(0,timeMatch.group(0).toString());
    }
  }
  }//end of loop



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
                        Icon(AntDesign.search1)
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(days.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                activeDay = index;
                              });
                            },
                            child: Container(
                              width: (MediaQuery.of(context).size.width - 40) / 7,
                              child: Column(
                                children: [
                                  Text(
                                    days[index]['label'],
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: activeDay == index
                                            ? primary
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: activeDay == index
                                                ? primary
                                                : black.withOpacity(0.1))),
                                    child: Center(
                                      child: Text(
                                        days[index]['day'],
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: activeDay == index
                                                ? white
                                                : black),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
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
        ));
  }
}

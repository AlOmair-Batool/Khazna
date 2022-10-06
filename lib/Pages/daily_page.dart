import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sim/theme/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sim/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telephony/telephony.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


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
  final String _message = "";
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
  int transLen = 0;
  double totalAmount = 0;
  double monthlyAllowance = 0;
  double savingPoint = 0;


  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    getAllSMS();

  }




  String type = '';

  _getType(params) async {
      final response = await http.post(
        Uri.parse("http://159.223.227.189:7000/type"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(params),
      );
      if (jsonDecode(response.body)["msg_type"].toString() == "2")
        {setState(() {
          type = "Withdrawals";
        });
        print("Withdrawals");}
      else if (jsonDecode(response.body)["msg_type"].toString() == "0"){
        setState(() {
          type = "Deposit";
        });
      print("Deposit");}
      else{
        setState(() {
          type = "None";
        });
        print("NONE");}
  }

  getAllSMS() async {
    messages = await telephony.getInboxSms(
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.ASC)],
//where(SmsColumn.DATE).lessThan("1664841600")
        filter: SmsFilter.where(SmsColumn.ADDRESS)
        .equals("SNB-AlAhli").or(SmsColumn.ADDRESS).equals("FransiSMS").or(SmsColumn.ADDRESS).equals("alinmabank")


    );



    for (var message in messages) {
      //identification of Alinma messages
      //String message1 = "Deposit ATM Amount: 250 SAR Account: **8000 On: 2022-03-14 21:52";
      message1 = message.body!;
      log(message1);
      Map<String, dynamic> params =  {
        "msg": message1};

      await _getType(params);


      String message2 = message1.toLowerCase();

      var msgDate = message.date!;
      //print(msgDate);
      var dt = DateTime.fromMillisecondsSinceEpoch(msgDate);
      var dt2 = DateFormat('dd/MM/yyyy').format(dt);
      bool flag = false;
      if (type == "Withdrawals") {
        transactionType.insert(0, "Withdrawal");

        icon.insert(0, "assets/images/Withdrawl.png");
        date.insert(0, dt2.toString());

        flag = true;
        setState(() {
          type = "None";
        });

      }
      else if (type == "Deposit") {
        transactionType.insert(0, "Deposit");

        icon.insert(0, "assets/images/Deposit.png");
        date.insert(0, dt2.toString());

        flag = true;
        setState(() {
          type = "None";
        });
      }
      else
        continue;
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
          print(timeMatch.group(0).toString());

        }else
          time.insert(0, "00:00");

      }
      //amount regex
      var amountNumReg = RegExp(r'[0-9]*\.[0-9]+');
      var amountMatch = amountNumReg.firstMatch(message2);
      if (amountMatch != null) {
        amount.insert(0, amountMatch.group(0).toString());
      }
      else {
        var amountReg = RegExp(r'[0-9]*.(?=SAR)');
        var amountBeforeMatch = amountReg.firstMatch(message2);
        String amountBefore = "";

        if (amountBeforeMatch != null) {
          amountBefore = amountBeforeMatch.group(0).toString();
        }
        var amountNumReg = RegExp(r'[0-9,]+');
        var amountAfterMatch = amountNumReg.firstMatch(message2);
        if (amountAfterMatch != null) {
          amount.insert(0, amountAfterMatch.group(0).toString());
        } else
          amount.insert(0, "0 SAR");
      }

    }


    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    for (var i = 0; i < transactionType.length; i++) {
      totalAmount += int.parse(amount[i]);

      /*DocumentReference ref = await FirebaseFirestore.instance.collection(
          'Test')
          .add({
        'Date': date[i],
        'Time': time[i],
        'Type': transactionType[i],
        'Amount': amount[i],
      });
      ref.update({
        'userID': uid
      });*/

          }

    monthlyAllowance = totalAmount * 0.8;
        savingPoint = totalAmount * 0.2;

  }


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
                      children: const [
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
            const SizedBox(
              height: 30,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                  children: List.generate(transactionType.length, (index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
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
                                  const SizedBox(width: 15),
                                  SizedBox(
                                    width: (size.width - 90) * 0.5,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          //daily[index]['name'],
                                          transactionType[index],

                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: black,
                                              fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
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
                            SizedBox(
                              width: (size.width - 40) * 0.3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    amount[index]+" SAR",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 65, top: 8),
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

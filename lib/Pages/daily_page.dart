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
  List <String> transactionType20 = [];
  List <String> amount20=[];
  List <String> date20=[];
  List <String> time20=[];

  double balance = 0;
  double monthlyAllowance = 0;
  double savingPoint = 0;
  double income= 0;


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
  //getting message type using SVM model
  _getType(params) async {
      final response = await http.post(
        Uri.parse("http://159.223.227.189:6000/type"),
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

  //return messages from banks across Saudi
  getAllSMS() async {
    //11 banks
    messages = await telephony.getInboxSms(
        filter: SmsFilter.where(SmsColumn.ADDRESS).equals("RiyadBank")
            .or(SmsColumn.ADDRESS).equals("FransiSMS")
            .or(SmsColumn.ADDRESS).equals("alinmabank")
            .or(SmsColumn.ADDRESS).equals("BankAlbilad")
            .or(SmsColumn.ADDRESS).equals("SNB-AlAhli")
            .or(SmsColumn.ADDRESS).equals("SAIB")
            .or(SmsColumn.ADDRESS).equals("SABB")
            .or(SmsColumn.ADDRESS).equals("AlJaziraSMS")
            .or(SmsColumn.ADDRESS).equals("AlRajhiBank")
            .or(SmsColumn.ADDRESS).equals("ANB")
            .or(SmsColumn.ADDRESS).equals("meemKSA")
    );

    var counter = 20;
    for (var message in messages) {
      if(counter==0) break;
      message1 = message.body!;
      log(message1);
      Map<String, dynamic> params = {"msg": message1};
      //Run SVM model
      await _getType(params);
      //SMS processing after getting the type.
      String message2 = message1.toLowerCase();
      var date1 = DateTime.fromMillisecondsSinceEpoch(message.date!);
      var date2 = DateFormat('dd/MM/yyyy').format(date1);
      //to save the day of the message to accumulate last 27th day
      var day = DateFormat('dd').format(date1);
      bool flag = false;
      //"type" is assigned by SVM model
     //type = Withdrawal
      if (type == "Withdrawals") {
        transactionType20.insert(0, "Withdrawal");
        icon.insert(0, "assets/images/Withdrawl.png");
        date20.insert(0, date2.toString());
        flag = true;
        setState(() {
          type = "None";
        });
      }
      //type = Deposit
      else if (type == "Deposit") {
        transactionType20.insert(0, "Deposit");
        icon.insert(0, "assets/images/Deposit.png");
        date20.insert(0, date2.toString());
        flag = true;
        setState(() {
          type = "None";
        });
      }
      else {
        continue;
      }
      //parse other variables
     //1. Extract time
      if (flag) {
        RegExp timeReg = RegExp(r'(\d{2}:\d{2})');
        var timeMatch = timeReg.firstMatch(message2);
        if (timeMatch != null) {
          time20.insert(0, timeMatch.group(0).toString());
          print(timeMatch.group(0).toString());
        } else {
          time20.insert(0, "00:00");
        }
      }

      //2. Extract amount
      var amountNumReg = RegExp(r'[0-9]*\.[0-9]+');
      var amountMatch = amountNumReg.firstMatch(message2);
      if (amountMatch != null) {
        amount20.insert(0, amountMatch.group(0).toString());
      }
      else {
        var amountReg = RegExp(r'[0-9]+\*[0-9]+');
        var amountBeforeMatch = message2.replaceAll(amountReg, '');
        var amountNumReg = RegExp(r'[0-9,]+');
        var amountAfterMatch = amountNumReg.firstMatch(amountBeforeMatch);
        if (amountAfterMatch != null) {
          amount20.insert(0, amountAfterMatch.group(0).toString());
        } else {
          amount20.insert(0, "0 SAR");
        }
      }
      counter = counter - 1;
    }



    //send to firestore + all calculations
    var countForFireStore = 100;
    for (var message in messages) {
      if(counter==0) break;
      message1 = message.body!;
      log(message1);
      Map<String, dynamic> params = {"msg": message1};
      await _getType(params);
      String message2 = message1.toLowerCase();
      var date1 = DateTime.fromMillisecondsSinceEpoch(message.date!);
      var date2 = DateFormat('dd/MM/yyyy').format(date1);
      var month = DateFormat('MM').format(date1);
      var day = DateFormat('dd').format(date1);
      bool flag = false;

      if (type == "Withdrawals") {
        transactionType.insert(0, "Withdrawal");
        icon.insert(0, "assets/images/Withdrawl.png");
        date.insert(0, date2.toString());
        flag = true;
        setState(() {
          type = "None";
        });
      }
      else if (type == "Deposit") {
        transactionType.insert(0, "Deposit");
        icon.insert(0, "assets/images/Deposit.png");
        date.insert(0, date2.toString());
        flag = true;
        setState(() {
          type = "None";
        });
      }
      else {
        continue;
      }

      if (flag) {
        RegExp timeReg = RegExp(r'(\d{2}:\d{2})');
        var timeMatch = timeReg.firstMatch(message2);
        if (timeMatch != null) {
          time.insert(0, timeMatch.group(0).toString());
          print(timeMatch.group(0).toString());
        } else {
          time.insert(0, "00:00");
        }
      }

      var amountNumReg = RegExp(r'[0-9]*\.[0-9]+');
      var amountMatch = amountNumReg.firstMatch(message2);
      if (amountMatch != null) {
        amount.insert(0, amountMatch.group(0).toString());
      }
      else {

        var amountReg = RegExp(r'[0-9]+\*[0-9]+');
        var amountBeforeMatch = message2.replaceAll(amountReg, '');
        String amountBefore = "";

        var amountNumReg = RegExp(r'[0-9,]+');
        var amountAfterMatch = amountNumReg.firstMatch(amountBeforeMatch);
        if (amountAfterMatch != null) {
          amount.insert(0, amountAfterMatch.group(0).toString());
        } else {
          amount.insert(0, "0 SAR");
        }
      }

      //A. Find the 27 of this month or the month before


      final now = DateTime.now();
      var thisMonth = DateFormat('MM').format(now);
      bool isItThisMonth = true;
      var usedMonth = "";

      if (day == "27" && isItThisMonth) {
        usedMonth = month;
        isItThisMonth=false;
      }

      if (type == "Deposit" && day == "27" && month == usedMonth) {
        income += int.parse(amount[countForFireStore]);
        balance += int.parse(amount[countForFireStore]);
      } else if (type == "Deposit") {
        balance += int.parse(amount[countForFireStore]);
      } else if (type == "Withdrawals") {
        balance -= int.parse(amount[countForFireStore]);
      }
      savingPoint = income * 0.2;

      countForFireStore = countForFireStore - 1;

    }


    //read from database
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    //works for sending 100 SMS messages to Firestore
    for (var i = 0; i < transactionType.length; i++) {
    DocumentReference ref = await FirebaseFirestore.instance.collection(
        'Test3')
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

    /*for (var i = 0; i < transactionType.length; i++) {
      totalAmount += int.parse(amount[i]);
    }*/


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
                      children: const [
                        Text(
                          "Latest Transactions",
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
                  children: List.generate(transactionType20.length, (index) {
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
                                          //transactionType[index],
                                          transactionType20[index],

                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: black,
                                              fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          date20[index]+" "+time20[index],
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
                                    amount20[index] + " SAR",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.black87),
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

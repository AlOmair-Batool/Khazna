import 'dart:convert';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:sim/theme/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sim/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telephony/telephony.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../json/json_daily.dart';
import 'dart:developer';
import 'package:sim/classes/language_constants.dart';



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
  List <int> epochTime=[];


  List <String> icon=[];
  List <String> transactionType20 = [];
  List <String> amount20=[];
  List <String> date20=[];
  List <String> time20=[];
  List <int> epochTime20=[];



  List <String> newTransactionType = [];
  List <String> newAmount =[];
  List <String> newDate =[];
  List <String> newTime =[];

  double balance = 0;
  double monthlyAllowance = 0;
  double savingPoint = 0;
  double income= 0;
  String monthSend = "";

  //don't add duplicate entries in database
  int time200 =0 ;
 int newdatte =0;



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

  //return messages from banks across Saudi
  getAllSMS() async {
    //11 banks
    messages = await telephony.getInboxSms(
        filter: SmsFilter.where(SmsColumn.ADDRESS).equals("RiyadBank")
            .or(SmsColumn.ADDRESS).equals("FransiSMS")
            //.or(SmsColumn.ADDRESS).equals("alinmabank")
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
      if (counter == 0) break;
      message1 = message.body!;

      log(message1);
      Map<String, dynamic> params = {"msg": message1};
      //Run SVM model
      await _getType(params);
      //SMS processing after getting the type.
      String message2 = message1.toLowerCase();
      var date1 = DateTime.fromMillisecondsSinceEpoch(message.date!);
      epochTime20.insert(0, message.date!);
      var date2 = DateFormat('dd/MM/yyyy').format(date1);
      //to save the day of the message to accumulate last 27th day
      var day = DateFormat('dd').format(date1);
      bool flag = false;
      //"type" is assigned by SVM model
      //type = Withdrawal
      if (type == "Withdrawals") {
        transactionType20.insert(0,          translation(context).ww);
        icon.insert(0, "assets/images/Withdrawl.png");
        date20.insert(0, date2.toString());
        flag = true;
      }
      //type = Deposit
      else if (type == "Deposit") {
        transactionType20.insert(0, translation(context).dep);
        icon.insert(0, "assets/images/Deposit.png");
        date20.insert(0, date2.toString());
        flag = true;
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
        } else {
          time20.insert(0, "00:00");
        }
      }

      //2. Extract amount
      var amountNumReg = RegExp(r'\d,[0-9]*\.[0-9]+');
      var amountMatch = amountNumReg.firstMatch(message2);
      var amountMatch2 = amountMatch?.group(0);
      var removeComma = RegExp(r'[,]+');
      var remove = amountMatch2.toString().replaceAll(removeComma, "");

      if (amountMatch != null) {
        amount20.insert(0, remove);
      }
      else {
        var amountNumReg = RegExp(r'[0-9]*\.[0-9]+');
        var amountMatch = amountNumReg.firstMatch(message2);
        if (amountMatch != null) {
          amount20.insert(0, amountMatch.group(0).toString());

        }else {
          var amountReg = RegExp(r'[0-9]+\*[0-9]+');
          var amountBeforeMatch = message2.replaceAll(amountReg, '');
          String amountBefore = "";

          var amountNumReg = RegExp(r'[0-9,]+');
          var amountAfterMatch = amountNumReg.firstMatch(amountBeforeMatch);

          // amountNumReg = RegExp(r'[0-9,]+');
          // amountMatch = amountNumReg.firstMatch(message2);
         if (amountAfterMatch != null) {
            amount20.insert(0, amountAfterMatch.group(0).toString());
          }else{
           amount20.insert(0, "0 SAR");
         }


        }

      }


      if (counter == 5) {
        newdatte = message.date!;
      }
      counter = counter - 1;
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;


    var timeDup = "";
    var amountDup = "";
    var dateDup ="";
    var typeDup ="";
    int epochDup = 0;
    var userID = null;
    //works for sending 100 SMS messages to Firestore
    QuerySnapshot snap = await FirebaseFirestore.instance.collection(
        "transaction").where('userID', isEqualTo: uid).get();
    snap.docs.forEach((document) {
      userID = document['userID'];
    });

    QuerySnapshot snap3 = await FirebaseFirestore.instance.collection(
        "transaction").orderBy("epochTime", descending: true).limit(1).where('userID', isEqualTo: uid).get();

    for (var document in snap3.docs) {
      timeDup = document['Time'].toString();
      amountDup = document['Amount'].toString();
      typeDup = document['Type'].toString();
      dateDup = document['Date'].toString();
      epochDup = document['epochTime'];
    }


    bool stopDup = false;
    int newCounter = 19;
    for(int i=0; i<transactionType20.length; i++){
     //if(stopDup == true) break;
     if(userID == null) break;

        if(epochTime20 [newCounter] == epochDup) {

          break;
        }
         else{ DocumentReference ref2 = await FirebaseFirestore.instance.collection("transaction")
              .add({
            'Date': date20[newCounter],
            'Time': time20[newCounter],
            'Type': transactionType20[newCounter],
            'Amount': amount20[newCounter],
            'epochTime' : epochTime20[newCounter],
          });
          ref2.update({
            'userID': uid
          });

          newCounter =  newCounter -1;
        }


    }

    //send to firestore + all calculations////////////////////////////////////////////////////////////
    String day = "";

    int numOfSMS = 0;
    bool itIs27 = false;
    bool stopCounting = false;
    for (var message in messages) {
      //if there is any thing stored in database it will not excute the loop

     // if (userID != null) break;
      if (stopCounting == true) break;
      message1 = message.body!;
      log(message1);
      Map<String, dynamic> params = {"msg": message1};
      await _getType(params);
      String message2 = message1.toLowerCase();
      var date1 = DateTime.fromMillisecondsSinceEpoch(message.date!);
      epochTime.insert(0, message.date!);
      var date2 = DateFormat('dd/MM/yyyy').format(date1);
      var month = DateFormat('MM').format(date1);
      day = DateFormat('dd').format(date1);
      bool flag = false;

      double amount2 = 0;

      if (type == "Withdrawals") {
        transactionType.insert(0, "Withdrawal");
        date.insert(0, date2.toString());
        flag = true;
      }
      else if (type == "Deposit") {
        transactionType.insert(0, "Deposit");
        date.insert(0, date2.toString());
        flag = true;
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

var amountNumReg = RegExp(r'\d,[0-9]*\.[0-9]+');
var amountMatch = amountNumReg.firstMatch(message2);
var amountMatch2 = amountMatch?.group(0);
var removeComma = RegExp(r'[,]+');
var remove = amountMatch2.toString().replaceAll(removeComma, "");

      if (amountMatch != null) {
      amount.insert(0, remove);
      amount2 = double.parse(remove);
      }
    else {
        var amountNumReg = RegExp(r'[0-9]*\.[0-9]+');
        var amountMatch = amountNumReg.firstMatch(message2);
        if (amountMatch != null) {
          amount.insert(0, amountMatch.group(0).toString());
          amount2 = double.parse(amountMatch.group(0).toString());
        }else {
          var amountReg = RegExp(r'[0-9]+\*[0-9]+');
          var amountBeforeMatch = message2.replaceAll(amountReg, '');
          String amountBefore = "";

          var amountNumReg = RegExp(r'[0-9,]+');
          var amountAfterMatch = amountNumReg.firstMatch(amountBeforeMatch);

          // amountNumReg = RegExp(r'[0-9,]+');
          // amountMatch = amountNumReg.firstMatch(message2);
          if (amountAfterMatch != null) {
            amount.insert(0, amountAfterMatch.group(0).toString());
            amount2 = double.parse(amountAfterMatch.group(0).toString());
          }else{
            amount.insert(0, "0 SAR");
          }


        }

      }

      //A. Find the 27 of this month or the month before


      final now = DateTime.now();
      var thisMonth = DateFormat('MM').format(now);



      if (day == "27" && type == "Deposit") {
        print("entred day 27");
        itIs27 = true;

      }

      if(day != "27" && itIs27 == true && numOfSMS >= 50){
        stopCounting == true;
      }

      /*if (numOfSMS >= 50 && itIs27 == true) {
        stopCounting == true;
      }*/


      if (flag) {
        if (type == "Deposit" && day == "27") {
          income = income + amount2;
          balance = balance + amount2;
        } else if (type == "Deposit") {
          balance = balance + amount2;
        }
        if (type == "Withdrawals") {
          balance = balance - amount2;
        }
      }


      numOfSMS = numOfSMS + 1;

    }

    //read from database
    if (userID == null) {
      print("entered");
      for (var i = 0; i < transactionType.length; i++) {
        DocumentReference ref = await FirebaseFirestore.instance.collection(
            "transaction")
            .add({
          'Date': date[i],
          'Time': time[i],
          'Type': transactionType[i],
          'Amount':amount[i],
          'epochTime' : epochTime[i],
        });
        ref.update({
          'userID': uid
        });
      }
    }

    var userIDCal = null;

    int indexx = 3;
//send user variables to database
    QuerySnapshot snap2 = await FirebaseFirestore.instance.collection(
        "userCalculations").where('userID', isEqualTo: uid).get();
    snap2.docs.forEach((document) {
      userIDCal = document['userID'];
    });



   if(userIDCal==null) {
      DocumentReference ref = await FirebaseFirestore.instance.collection(
      "userCalculations")
      .add({
    'income': income,
    'balance': balance,
    'savingPoint': income * 0.20,
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
                      children:  [
                        Text(
                          translation(context).daily_transaction,
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
                                    amount20[index] + translation(context).sar,
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
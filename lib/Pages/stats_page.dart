import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sim/theme/colors.dart';
import 'package:sim/widget/chart.dart';
import 'dart:convert';
import 'package:sim/Pages/function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sim/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:sim/classes/language_constants.dart';


class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  bool _isLoading=false; //bool variable created

  int activeDay = 3;
  double income = 0.0;
  double totalAmount =0;
  var userID;
  //getting values from firestore
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  external int get millisecondsSinceEpoch;
  getAllTransactions() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    //final uid = "EJ19NxkmHMMLMJgLcMdP9FfKRSb2";
    final uid = user?.uid;
    userID = user?.uid;

    QuerySnapshot snap = await
    FirebaseFirestore.instance.collection("userCalculations").where('userID',isEqualTo:uid).get();

    snap.docs.forEach((document) {
      if(document['income']!= null && document['balance'] !=null){
      income = document['income'];
      totalAmount = document['balance'];
      }
      else
        income  = 0.0;

    });

    print("income");
    print(income);

  }

    getAllTransactionschart() async {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final uid = user?.uid;
      //final uid = "EJ19NxkmHMMLMJgLcMdP9FfKRSb2";

      userID = user?.uid;

      setState(() {
        _isLoading=true;
      });
    QuerySnapshot snap2 = await
    FirebaseFirestore.instance.collection("transaction").orderBy("epochTime", descending: true).where('userID',isEqualTo:uid).get();

    X_test = [];
    mean = [];
    bool flag =true;
    var temp ="";
    double amount = 0.0;
    snap2.docs.forEach((document) {
      if(document['Type'] == "Withdrawal"){
      var dt = document['Date'].split('/');
      var dt_corr = dt[2]+"-"+dt[1]+"-"+dt[0];

      if(flag){
        temp = dt_corr;
        flag  = false;}

      if(dt_corr == temp){
      temp = dt_corr;
      amount += double.parse(document['Amount']);
     }
      else
        { X_test.add(temp);
        mean.add(amount);
        amount= double.parse(document['Amount']);
        temp = dt_corr;

        }

    }
    });
    if(mean.length == 0){
        X_test = ["2022-03-09"];
        mean = [0.0];
        _isLoading=true;
      }
    else
      _isLoading=false;


      X_test =  X_test.reversed.toList();
    mean =  mean.reversed.toList();


    print("DB X_test");
    print(X_test);
    print(mean);


  }

  var data;
  String output = '0 SAR';
  double pred_output = 0.0;
  List X_test = ["2022-03-09"];
  List mean = [0.0];
  bool showAvg = false;
  // predecting GP
  predict() async {
    data = await fetchdata('http://159.223.227.189:7000/api');
    var decoded = jsonDecode(data);
    print("pred_output");
  print(income/double.parse(decoded['output']).abs());
    setState(() {
      if(decoded['output'] != null)
      pred_output = double.parse(decoded['output']).abs();
      else
        pred_output = 1;

    });
  }

  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) =>predict());

    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });

    getAllTransactions();
    getAllTransactionschart();
    print("model_values");
    print(X_test);

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
    List expenses = [
      {
        "icon": Icons.check,
        "color": const Color(0xFF40A083),
        "label": translation(context).cb,
        "cost": totalAmount.toStringAsFixed(2)+ translation(context).sar
      },
      {
        "icon": Icons.show_chart,
        "color": const Color(0xFF0071BC),
        "label":  translation(context).eb,
        "cost": (income/pred_output).toStringAsFixed(2) +translation(context).sar
      }
    ];


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
                  top: 50, right: 20, left: 20, bottom: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      Text(
                        translation(context).stats,
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
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              width: double.infinity,
              height: 360,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: grey.withOpacity(0.01),
                      spreadRadius: 10,
                      blurRadius: 3,
                      // changes position of shadow
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translation(context).dsb ,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xff67727d)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 45,
                      bottom: 2,
                      child: !_isLoading?
                      SizedBox(
                        width: (size.width - 60),
                        height: (size.height - 10),

                        child: LineChart(
                          mainData(X_test, mean),),
                      )
                          : Container(
                        padding: const EdgeInsets.all(50),
                        margin:const EdgeInsets.all(50) ,
                        //widget shown according to the state
                        child: Center(
                          child: const CircularProgressIndicator(
                            backgroundColor: Colors.black26,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                primary //<-- SEE HERE
                            ),        ),
                        ),
                      ),
                    ),

                    //const CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Wrap(
              spacing: 20,
              children: List.generate(expenses.length, (index) {
                return Container(
                  width: (size.width - 60) / 2,
                  height: 160,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: grey.withOpacity(0.01),
                          spreadRadius: 10,
                          blurRadius: 3,
                          // changes position of shadow
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 20, bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: expenses[index]['color']),
                          child: Center(

                              child:  Icon(
                                expenses[index]['icon'],
                                color: Colors.white,
                              )),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              expenses[index]['label'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Color(0xff67727d)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              expenses[index]['cost'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.5,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }))
        ],
      ),
    );
  }



}
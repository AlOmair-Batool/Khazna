import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sim/theme/colors.dart';
import 'package:sim/widget/chart.dart';
import 'dart:convert';
import 'package:sim/Pages/function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sim/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';


class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  bool _isLoading=false; //bool variable created

  int activeDay = 3;
  double income = 0;
  double totalAmount =0;

  var userID;
  //getting values from firestore
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  external int get millisecondsSinceEpoch;
  getAllTransactions() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    QuerySnapshot snap = await
    FirebaseFirestore.instance.collection("userCalculations").where('userID',isEqualTo:uid).get();

    snap.docs.forEach((document) {
      income = document['income'];
      totalAmount = document['balance'];

    });
  }

  var data;
  String output = '0 SAR';
  double pred_output = 0.0;
  List X_test = [];
  List mean = [];
  bool showAvg = false;
  // predecting GP
  predict() async {
    data = await fetchdata('http://159.223.227.189:7000/api');
    var decoded = jsonDecode(data);
    print("pred_out");
    print(double.parse(decoded['output']));
    setState(() {
      pred_output = double.parse(decoded['output']);
      output = double.parse(decoded['output']).toStringAsFixed(2) + " SAR";
    });
  }

  model_data() async {

    setState(() {
      _isLoading=true;
    });
//for demo I had use delayed method. When you integrate use your api //call here.

    print("CHECK");

    data = await fetchdata('http://159.223.227.189:6000/predict_v4');
    var decoded = jsonDecode(data);

    setState(() {
      X_test = decoded["date"];
      mean = decoded["amount"];
      _isLoading=false;

    });
  }



  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) =>predict());
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) =>model_data());
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
    print("model_values");
    print(output);
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
        "label": "Current balance",
        "cost": totalAmount.toString()+" SAR"
      },
      {
        "icon": Icons.show_chart,
        "color": const Color(0xFF0071BC),
        "label": "Expected balance",
        "cost": ( pred_output).abs().toStringAsFixed(2) +" SAR"
        // "cost": (totalAmount/pred_output).abs().toStringAsFixed(2) +" SAR"
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
                    children: const [
                      Text(
                        "Spending analytics",
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
                            "Daily Spending Behaviour",
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
                      child:  !_isLoading
                          ?SizedBox(
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
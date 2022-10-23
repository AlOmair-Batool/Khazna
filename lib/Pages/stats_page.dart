import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sim/classes/language_constants.dart';
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
  double totalAmount =0;
  //getting values from firestore
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  external int get millisecondsSinceEpoch;
  getAllTransactions() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    QuerySnapshot snap = await
    FirebaseFirestore.instance.collection('Test').get();

    for (var document in snap.docs) {
      totalAmount = totalAmount + int.parse(document['Amount']);
    }
  }

  String url = 'http://159.223.227.189:7000/api';
  var data;
  String output = '0 SAR';
  List X_test = [];
  List mean = [];

  bool showAvg = false;
  predict() async {
    data = await fetchdata(url);
    var decoded = jsonDecode(data);
    print(decoded['output']);
    setState(() {
      output = decoded['output'].substring(0, 6) + translation(context).sar;
    });
  }

  model_data() async {

    setState(() {
      _isLoading=true;
    });
//for demo I had use delayed method. When you integrate use your api //call here.

    print("CHECK");

    data = await fetchdata('http://159.223.227.189:6000/predict');
    var decoded = jsonDecode(data);
    print("CHECK");
    //print(jsonDecode(data['X_test']));
    print(decoded["X_test"]);

    setState(() {
      X_test = decoded["X_test"];
      mean = decoded["mean"];
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
        "label": translation(context).current_balance,
        "cost": totalAmount.toString()+translation(context).sar
      },
      {
        "icon": Icons.show_chart,
        "color": const Color(0xFF0071BC),
        "label": translation(context).expected_balance,
        "cost": '$output${translation(context).sar}',
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
                  top: 60, right: 20, left: 20, bottom: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        translation(context).stats,
                        style: const TextStyle(
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

                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child:  !_isLoading
                          ?SizedBox(
                        width: (size.width - 20),
                        height: 270,
                        child: LineChart(
                            mainData(X_test, mean),),
                      )
                      : Container(
                            padding: const EdgeInsets.all(50),
                            margin:const EdgeInsets.all(50) ,
                            color: primary,
                        //widget shown according to the state
                            child: Center(
                            child: const CircularProgressIndicator(),
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
            height: 20,
          ),
          Wrap(
              spacing: 20,
              children: List.generate(expenses.length, (index) {
                return Container(
                  width: (size.width - 60) / 2,
                  height: 170,
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
                        left: 25, right: 25, top: 20, bottom: 20),
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
                                  fontSize: 11.5,
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

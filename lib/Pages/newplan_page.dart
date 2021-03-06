import 'package:sim/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sim/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';


class NewPlanPage extends StatefulWidget {
  @override
  _NewPlanPageState createState() => _NewPlanPageState();
}

class _NewPlanPageState extends State<NewPlanPage> {
  late double totalAmount = 0 ;
  late double savingPoint = 0 ;
  late double monthlyAllowance= 0;
  late double dailyAllowance = 0;

  int activeDay = 3;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();


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

    getAllTransactions();
  }



  getAllTransactions() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    QuerySnapshot snap = await
    FirebaseFirestore.instance.collection('Test').get();

    snap.docs.forEach((document) {
      totalAmount = totalAmount + int.parse(document['Amount'] );
      monthlyAllowance = totalAmount * 0.8;
      savingPoint = totalAmount * 0.2;
      dailyAllowance = monthlyAllowance*0.03;



    });


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
      appBar: AppBar(
        title: Text("My Plan"),
        toolbarHeight: 75,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(color: black,
            fontSize: 19,
            fontWeight: FontWeight.bold
        ),

        automaticallyImplyLeading: false,

        elevation: 0,

      ),

    );


  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
     List budget_json = [

      {
        "name": "Monthly Allowance",
        "price": monthlyAllowance.toString()+" SAR",
        "label_percentage": "80%",
        "percentage": 0.8,
        "color": red
      },
      {
        "name": "Savings",
        "price": savingPoint.toString()+" SAR",
        "label_percentage": "20%",
        "percentage": 0.2,
        "color": blue
      },
       {
         "name": "Total amount",
         "price": totalAmount.toString()+" SAR",
         "label_percentage": "100%",
         "percentage": 1,
         "color": green
       },

       {
         "name": "Daily allowance",
         "price": dailyAllowance.toString()+" SAR",
         "label_percentage": "",
         "percentage": 1,
         "color": white
       }
    ];



    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(color: grey.withOpacity(0.01), boxShadow: [
              BoxShadow(
                color: grey.withOpacity(0.01),

            spreadRadius: 10,
                blurRadius: 3,
                // changes position of shadow
              ),
            ]),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 30, right: 10, left: 20, bottom: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  <Widget>[

                  Text('This plan shows your daily, monthly \n allowance and saving point', style: TextStyle( color: Colors.black.withOpacity(0.8),

                  fontSize:16,
                  fontWeight: FontWeight.w400
              )),
              SizedBox(
                height: 0,
              ),
                   ] ,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
                children: List.generate(budget_json.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      width: double.infinity,
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
                        padding: EdgeInsets.only(
                            left: 25, right: 25, bottom: 20, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              budget_json[index]['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color(0xff67727d).withOpacity(0.6)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      budget_json[index]['price'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    budget_json[index]['label_percentage'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: Color(0xff67727d).withOpacity(0.6)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Stack(
                              children: [
                                Container(
                                  width: (size.width - 40),
                                  height: 4,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0xff67727d).withOpacity(0.1)),
                                ),
                                Container(
                                  width: (size.width - 40) *
                                      budget_json[index]['percentage'],
                                  height: 4,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: budget_json[index]['color']),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })),
          )
        ],
      ),
    );
  }
}

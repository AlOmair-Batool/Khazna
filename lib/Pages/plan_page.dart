import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sim/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sim/theme/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PlanPage extends StatefulWidget {
  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  late List<TotalData> _chartData;


  @override
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

    _chartData = getChartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: grey.withOpacity(0.05),

        appBar: AppBar(
          title: Text("My Plan"),
          backgroundColor: Colors.white,
          toolbarHeight: 85,
          titleTextStyle: TextStyle(color: Colors.black ,
            fontSize: 19,
            fontWeight: FontWeight.bold,
            height: 3,
          ),
          titleSpacing: -35,
          elevation: 0,
        ),

        body: Column(
        children: <Widget>[

              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Wrap(
                      spacing: -97,
                      //runSpacing: 50,

                      children: <Widget>[
                        Padding(padding: const EdgeInsets.all(30.0),),
                        Text(
                          'Hello' "  ${loggedInUser.firstName}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            height: 4,

                          ),
                        ),
                        Text(
                        'To achieve your goals, We advice you to follow the plan below!',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          height: 10,

                          //textBaseline:

                        ),
                      ),
        ],
                    ),

                    ],
              ),

            //],

          //),

           Row(

               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[


                 Container(

                   margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                   width: 370,
                   height: 80,
                   decoration: BoxDecoration(
                     //Text('j'),

                       color: Color(0xff43AA8B),
                       //Color(0xff43AA8B),
                       borderRadius: BorderRadius.circular(12),
                       boxShadow: [
                         BoxShadow(
                           color: grey.withOpacity(0.01),
                           spreadRadius: 10,
                           blurRadius: 3,
                           // changes position of shadow
                         ),
                       ]),
                   child: SizedBox(
                     //child: Center(
                       child: Container(

                         padding: const EdgeInsets.all(10.0),
                         margin: EdgeInsets.all(22.0),
                         child: Text(
                           'Daily Allowance =',
                           textAlign: TextAlign.left,
                           //textDirection: TextDirection.rtl,
                           style: TextStyle(
                             fontWeight: FontWeight.bold,
                             fontSize: 17,
                             color: Colors.white,
                             height: 1,
                           ),


                         ),
                       ),

                     //),
                   ),
                 ),
               ],
           ),

         Row(
          children: <Widget> [
           Container(
            padding: const EdgeInsets.all(13.0),
            margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
        child: SfCircularChart(
          legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom
          ),
          //title: ChartTitle(
              //text: 'To achieve your goals, We advice yo to follow the plan below!',
              // Aligns the chart title to left
            //  alignment: ChartAlignment.near,
              //textStyle: TextStyle(
                //color: Colors.black,
                //fontSize: 14,
              //)
          //),

          margin: EdgeInsets.all(1),


          series: <CircularSeries>[
            PieSeries<TotalData, String>(
              dataSource: _chartData,
              animationDuration: 4500,
              animationDelay: 2000,
              xValueMapper: (TotalData data, _) => data.x,
              yValueMapper: (TotalData data, _) => data.y,
              //dataLabelMapper: (TotalData data, _) => data.text,
              pointColorMapper: (TotalData data, _) => data.color,
              dataLabelSettings: DataLabelSettings(isVisible: true),
              radius: '105%',
              //pointShaderMapper: (1),
              strokeColor: Colors.grey.shade400,
              strokeWidth: 0.5,

            )
          ],),
      ),
      ],
      ),
    ],
        ),

    //),
      ),

    );

  }


  List<TotalData> getChartData(){
    final List<TotalData> chartData = [
      TotalData('Savings',2000,Color(0xff43AA8B)),
      TotalData('Monthly Allowance',4500, Colors.grey.shade300),
    ];

    return chartData;
  }
}

class TotalData{

  final Color color;

  TotalData(this.x, this.y, this.color);
  final String x;
  final int y;
  //final String text;
  //final Shader shader;


}


// return Scaffold(
//backgroundColor: grey.withOpacity(0.05),

//appBar: AppBar(
//title: Text("My Plan"),
//backgroundColor: Colors.white,
//toolbarHeight: 108,
//titleTextStyle: TextStyle(color: Colors.black ,
//  fontSize: 19,
//fontWeight: FontWeight.bold,
//height: 4.5,
//),
//titleSpacing: -35,
//elevation: 0,
//),
//);
//}



//  {

//         "icon": Icons.check,
//         "color": const Color(0xFF40A083),
//     "label": "Current balance",
//         "cost": "6500 SAR"
//       },
//       {
//         "icon": Icons.show_chart,
//         "color": const Color(0xFF0071BC),
//         "label": "Expected balance",
//         "cost": "2645 SAR"
//       }


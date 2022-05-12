import 'package:sim/core/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sim/theme/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:telephony/telephony.dart';
import 'package:intl/intl.dart';

class PlanPage extends StatefulWidget {
  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {

  late List<TotalData> _chartData;

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
  double totalAmount = 0;
  double monthlyAllowance = 0;
  double savingPoint = 0;
  double dailyAllowance = 0;

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
    for (var i = 0; i < transactionType.length; i++) {
      totalAmount += int.parse(amount[i]);

    }

    monthlyAllowance = totalAmount * 0.8;
    savingPoint = totalAmount * 0.2;
    dailyAllowance = monthlyAllowance * 0.3;
    // monthlyAllowance = 3000;
    // savingPoint = 500;
    // dailyAllowance = 100;
    _chartData = getChartData();
    setState(() {

    });

  }

  @override
  void initState() {
    _chartData = getChartData();
    super.initState();
    getAllSMS();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: grey.withOpacity(0.05),
        appBar: AppBar(
          title: Text("My Plan"),
          backgroundColor: Colors.white,
          toolbarHeight: 75,
          titleTextStyle: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: black,
            height: 1,
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
                  direction: Axis.vertical,
                  spacing: -97,
                  //runSpacing: 50,
                  children: <Widget>[
                    //Padding(padding: const EdgeInsets.all(30.0),),
                    Text(
                      'Hello' "  ${currentUser!.firstName}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        height: 4,

                      ),
                    ),
                    Text(
                      'To achieve your goals, we advice you to follow the plan below:',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        height: 11,

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
                  width: MediaQuery.of(context).size.width - 40,
                  height: 80,
                  decoration: BoxDecoration(
                      color: primary,
                      //Color(0xff43AA8B),
                      borderRadius: BorderRadius.circular(10),
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
                        'Daily Allowance = $dailyAllowance',
                        textAlign: TextAlign.left,
                        //textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
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
                  //padding: const EdgeInsets.all(13.0),
                  margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
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
      TotalData('Savings',savingPoint.toInt(),Color(0xFF4D908E)),
      TotalData('Monthly Allowance',monthlyAllowance.toInt(), Colors.grey.shade300),
    ];

    return chartData;
  }
}

class TotalData{

  final Color color;

  TotalData(this.x, this.y, this.color);
  final String x;
  final int y;

}
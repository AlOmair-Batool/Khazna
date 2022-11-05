//@dart=2.8
// ignore_for_file: unnecessary_const, prefer_const_literals_to_create_immutables, deprecated_member_use, sized_box_for_whitespace, use_key_in_widget_constructors

import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sim/Pages/login_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sim/Pages/auth_file.dart';
import 'package:sim/Pages/local_notify_manager.dart';
import 'package:sim/Pages/login_screen.dart';
import 'package:sim/core/enums.dart';
import 'package:sim/core/functions/format_date.dart';
import 'package:sim/core/functions/validation.dart';
import 'package:sim/core/global.dart';
import 'package:sim/core/models/field.dart';
import 'package:sim/theme/colors.dart';
import 'package:sim/Pages/local_notify_manager.dart';
import 'package:sim/classes/language_constants.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final oldPasswordEditingController = TextEditingController();
  final newPasswordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();


  final notificationTitle = TextEditingController();
  final notificationBody = TextEditingController();
  bool receiveNotification;
  DateTime scheduleNotificationDateTime;

  Future<List<ReceiveNotification>> getCustomNotifications() async{
    SharedPreferences shared = await SharedPreferences.getInstance();
    List<ReceiveNotification> customNotificationsList = [];
    String customNotification = shared.getString('custom_notification');
    if(customNotification != null && customNotification != ''){
      var customNotifications = jsonDecode(customNotification);
      for(var map in customNotifications){
        customNotificationsList.add(ReceiveNotification.fromMap(map));
      }
    }
    return customNotificationsList;
  }

  @override
  void initState() {
    (SharedPreferences.getInstance()).then((value) {
      bool showNotification = value.getBool('show_notification');
      if(showNotification != null && !showNotification){
        showNotification = false;
        OneSignal.shared.disablePush(true);
      }else{
        showNotification = true;
      }
      receiveNotification = showNotification;
      setState(() {

      });
      return value;
    });


    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: primary,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
             Text(
              translation(context).settings,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                const Icon(
                  AntDesign.user,
                  color: primary,
                ),
                const SizedBox(
                  width: 8,
                ),
                 Text(
                  translation(context).account,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 0.8,
            ),
            const SizedBox(
              height: 10,
            ),
            buildAccountOptionRow(context, translation(context).change_password),
            buildAccountOptionRow(context, translation(context).language),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: primary,
                ),
                const SizedBox(
                  width: 8,
                ),
                 Text(
                  translation(context).notifications,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500), //
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 0.8,
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<List<ReceiveNotification>>(
                future: getCustomNotifications(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    if(snapshot.data.isNotEmpty){
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (con,index){
                          return Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            child: ListTile(
                              title: Text(snapshot.data[index].title),
                              leading: Text((index + 1).toString()),
                              subtitle: Text('${snapshot.data[index].body} \n ${formatDate(snapshot.data[index].scheduleDate)}'),
                              trailing: IconButton(
                                onPressed: () async{
                                  SharedPreferences shared = await SharedPreferences.getInstance();
                                  List<ReceiveNotification> customNotificationsList = [];
                                  String customNotification = shared.getString('custom_notification');
                                  if(customNotification != null && customNotification != ''){
                                    var customNotifications = jsonDecode(customNotification);
                                    for(var map in customNotifications){
                                      customNotificationsList.add(ReceiveNotification.fromMap(map));
                                    }
                                  }
                                  List<Map<String,dynamic>> notificationMapList = [];
                                  await localNotifyManager.deleteNotification(ReceiveNotification(id: snapshot.data[index].id));
                                  customNotificationsList.removeWhere((element) => element.id == snapshot.data[index].id);
                                  for(ReceiveNotification notification in customNotificationsList){
                                    notificationMapList.add(notification.toMap());
                                  }
                                  shared.setString('custom_notification', jsonEncode(notificationMapList));
                                  setState(() {

                                  });
                                },
                                icon: Icon(FontAwesomeIcons.trashAlt,color: Colors.red,),
                              ),
                            ),
                          );
                        },
                      );
                    }else{
                      return Container(height: 50,alignment: Alignment.center,child: Text(translation(context).ncn));
                    }
                  }else{
                    return Container(height: 50,alignment: Alignment.center,child: CircularProgressIndicator());
                  }

                }
            ),


            buildNotificationOptionRow(translation(context).daily_encouragements, receiveNotification),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translation(context).cust,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[600]), //
                ),
                InkWell(
                    onTap: (){
                      showDialog(context: context, builder: (con){
                        return AlertDialog(

                          title:  Text(translation(context).add_cus),
                          content: Container(
                            width: 250,
                            height: 250,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  TextFormField(
                                    controller: notificationTitle, ///////////////////////////////////////////////////////////////////////////////
                                    decoration:  InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black, width: 0.0),),
                                        isDense: true,
                                        label:  Text( translation(context).notit)
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  TextFormField(
                                    controller: notificationBody, ///////////////////////////////////////////////////////////////////////////////
                                    decoration:  InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black, width: 0.0),),
                                        isDense: true,
                                        label: Text(translation(context).nobod)
                                    ),
                                  ),
                                  const SizedBox(height: 5,),

                                  const SizedBox(height: 10,),
                                  ElevatedButton(
                                    onPressed: () async{
                                      if(await validate([
                                        Field(field: notificationTitle.text,type: ValidationType.isEmpty,hint: 'Enter notification title'),
                                        Field(field: notificationBody.text,type: ValidationType.isEmpty,hint: 'Enter notification body'),
                                      ], context, true)){
                                        if(scheduleNotificationDateTime != null){
                                          SharedPreferences shared = await SharedPreferences.getInstance();
                                          List<ReceiveNotification> customNotificationsList = [];
                                          String customNotification = shared.getString('custom_notification');
                                          if(customNotification != null && customNotification != ''){
                                            var customNotifications = jsonDecode(customNotification);
                                            for(var map in customNotifications){
                                              customNotificationsList.add(ReceiveNotification.fromMap(map));
                                            }
                                          }
                                          List<Map<String,dynamic>> notificationMapList = [];
                                          int notificationId = Random().nextInt(9999);
                                          ReceiveNotification receiveNotification = ReceiveNotification(id: notificationId,title: notificationTitle.text,body: notificationBody.text,scheduleDate: scheduleNotificationDateTime);
                                          await localNotifyManager.scheduleNotification(receiveNotification);
                                          customNotificationsList.add(receiveNotification);
                                          for(ReceiveNotification notification in customNotificationsList){
                                            notificationMapList.add(notification.toMap());
                                          }
                                          shared.setString('custom_notification', jsonEncode(notificationMapList));
                                          Navigator.pop(context);
                                          scheduleNotificationDateTime = null;
                                          notificationTitle.clear();
                                          notificationBody.clear();
                                          setState(() {

                                          });
                                        }else{
                                          showAlertDialog(context, translation(context).snd , false);
                                        }

                                      }
                                    },
                                    child:  Text(translation(context).add),
                                  )
                                ]),
                          ),
                        );
                      });
                    },child: Icon(Icons.add,color: primary,size: 25,))
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: OutlinedButton(
                style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
  ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                child:  Text(translation(context).logout,
                    style: const TextStyle(
                        fontSize: 16, letterSpacing: 1.5, color: black)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isActive,
              onChanged: (bool val) async{
                receiveNotification = val;
                if(val){
                  (await SharedPreferences.getInstance()).setBool('show_notification',true);
                  showNotification = true;
                  OneSignal.shared.disablePush(false);
                }else{
                  (await SharedPreferences.getInstance()).setBool('show_notification',false);
                  showNotification = false;
                  OneSignal.shared.disablePush(true);
                }
                setState(() {

                });
              },
            ))
      ],
    );
  }
  //change password
  Widget textForm(){
    return Column(
      children: [
        TextFormField(
          validator: (val){
            if(val.length <6){
              return 'Please enter password with min 6 char length!';
            }else{
              return null;
            }
          },
          controller: oldPasswordEditingController, ///////////////////////////////////////////////////////////////////////////////
          decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0.0),),
              isDense: true,
              label: Text("Old password")
          ),
          obscureText: true,
        ),
        const SizedBox(height: 5,),
        TextFormField(
          validator: (val){
            if(val.length <6){
              return 'Please enter password with min 6 char length!';
            }else{
              return null;
            }
          },
          obscureText: true,
          controller: newPasswordEditingController, ///////////////////////////////////////////////////////////////////////////////
          decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0.0),),
              isDense: true,
              label: Text("New password")
          ),
        ),
        const SizedBox(height: 5,),
        TextFormField(
          validator: (val){
            if(val.length <6){
              return 'Please enter password with min 6 char length!';
            }else{
              return null;
            }
          },
          obscureText: true,
          controller: confirmPasswordEditingController, ///////////////////////////////////////////////////////////////////////////////
          decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0.0),),
              isDense: true,
              label: const Text("Confirm password")
          ),
        ),
      ],
    );
  }
  // Button
  // Widget alertDialog(String title, String message) {
  //   return AlertDialog(
  //     title: Text("$title") ,
  //     content: Text("$message"),
  //   );
  // }
  // void check() async{
  //   DocumentReference ref = (await FirebaseFirestore.instance.collection('users')) as DocumentReference<Object?>;
  //
  //   setState(() {
  //     ref.update(
  //         { 'password': passwordEditingController.value.text}
  //     );
  //
  //   });
  //
  // }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (_){
              return AlertDialog(

                title: const Text("New Password"),
                content: Container(
                  width: 250,
                  height: 250,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        textForm(),
                        const SizedBox(height: 10,),
                        ElevatedButton(
                          onPressed: () async{
                            if(await validate([
                              Field(field: oldPasswordEditingController.text,type: ValidationType.isEmpty,hint: 'Enter old password'),
                              Field(field: newPasswordEditingController.text,type: ValidationType.isEmpty,hint: 'Enter new password'),
                              Field(field: newPasswordEditingController.text,type: ValidationType.isOver,overNum: 6,hint: 'Please enter password with min 6 char length!'),
                              Field(field: confirmPasswordEditingController.text,type: ValidationType.isEmpty,hint: 'Enter confirm password'),
                            ], context, true)){
                              if(newPasswordEditingController.text.trim() == confirmPasswordEditingController.text.trim()){
                                bool result = await UserController().updatePassword(oldPasswordEditingController.text,newPasswordEditingController.text,context);
                                if(result){
                                  oldPasswordEditingController.clear();
                                  newPasswordEditingController.clear();
                                  confirmPasswordEditingController.clear();
                                  Navigator.pop(context);
                                  showAlertDialog(context,'Password updated', true);
                                  Navigator.popUntil(context, (route) {
                                    return route.isFirst;
                                  });
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (con){
                                    return LoginScreen();
                                  }));
                                }else{

                                }
                              }else{
                                showAlertDialog(context,'Password doesn\'t match', false);
                              }
                            }

                          },
                          child: const Text("Update"),
                        )
                      ]),
                ),
              );

            });


      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.grey[600],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

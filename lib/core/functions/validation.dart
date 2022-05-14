//@dart=2.8
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sim/core/enums.dart';
import 'package:sim/core/models/field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: missing_return
Future<bool> validate(List<Field> fields,BuildContext context,bool showAlert) async{
  int counter = 0;
  for(Field field in fields){
    if(field.type == ValidationType.isEmpty) {
      if (field.field
          .trim()
          .isEmpty) {
        showAlertDialog(context, field.hint, false);

        return false;
      } else {
        counter++;
        if (counter == fields.length) {
          return true;
        }
      }
    }else if(field.type == ValidationType.none){
      counter++;
      if (counter == fields.length) {
        return true;
      }
    }
    else if(field.type == ValidationType.isNumber){
      bool isDigit = true;
      try{
        num.parse(field.field);
      }catch(e){
        print(e.toString());
        isDigit = false;
      }
      if(!isDigit){
        showAlertDialog(context, field.hint, false);
        return false;
      }else{
        counter++;
        if (counter == fields.length) {
          return true;
        }
      }
    }
    else if(field.type == ValidationType.isPositive){
      bool isPositive = true;
      if(num.parse(field.field) >= 0){
        isPositive = true;
      }else{
        isPositive = false;
      }

      if(!isPositive){
        showAlertDialog(context, field.hint, false);
        return false;
      }else{
        counter++;
        if (counter == fields.length) {
          return true;
        }
      }
    }
    else if(field.type == ValidationType.isOver){
      if(field.field.length < field.overNum){
        showAlertDialog(context, field.hint, false);
        return false;
      }else{
        counter++;
        if (counter == fields.length) {
          return true;
        }
      }
    }
    else if(field.type == ValidationType.optionalNumber){
      if(field.field.trim().isEmpty){
        counter++;
        if (counter == fields.length) {
          return true;
        }
      }else{
        bool isDigit = true;
        try{
          num.parse(field.field);
        }catch(e){
          print(e.toString());
          isDigit = false;
        }
        if(!isDigit){
          showAlertDialog(context, field.hint, false);
          return false;
        }else{
          counter++;
          if (counter == fields.length) {
            return true;
          }
        }
      }
    }
    else if(field.type == ValidationType.checkInternrt){
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          counter++;
          if (counter == fields.length) {
            return true;
          }
        }else{
          if(showAlert) {
            showAlertDialog(context, 'No internet connection', false);
          }
          return false;
        }
      }catch(e){
        print(e.toString());
        if(showAlert) {
          showAlertDialog(context, 'No internet connection', false);
        }
        return false;
      }
    }
  }
}

showAlertDialog(BuildContext context , String message , bool state) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(

    content: Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Center(
                child: FaIcon(state ?  FontAwesomeIcons.solidCheckCircle:FontAwesomeIcons.hourglassHalf ,color: state ?  Colors.green : Colors.red ,size: 40,)),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  // show the dialog


  showDialog(
    context: context,
    builder: (BuildContext con) {
      Future.delayed(const Duration(seconds: 2), () {
        try {
          Navigator.of(con).pop(true);
        }catch(e){
        }
      });
      return alert;
    },
  );
}
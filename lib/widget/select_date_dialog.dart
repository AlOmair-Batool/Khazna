//@dart=2.8
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:sim/core/functions/format_date.dart';

class SelectDateDialog extends StatefulWidget {
  Function getDate;
  SelectDateDialog(this.getDate);
  @override
  _SelectDateDialogState createState() => _SelectDateDialogState();
}

class _SelectDateDialogState extends State<SelectDateDialog> {
  DateTime scheduleNotificationDateTime;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () async{
        DatePicker.showDateTimePicker(context,
            showTitleActions: true,
            minTime: DateTime.now(),
            maxTime: DateTime.now().add(const Duration(days: 9999)), onConfirm: (date) {
              scheduleNotificationDateTime = date;
              print(scheduleNotificationDateTime);
              widget.getDate(scheduleNotificationDateTime);
              setState(() {

              });
            }, locale: LocaleType.en);
      },
      child: Text(scheduleNotificationDateTime == null?'Select notification Date':formatDate(scheduleNotificationDateTime)),
    );
  }
}

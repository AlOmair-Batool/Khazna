//@dart=2.8


String formatDate(DateTime date) {
  DateTime currentDate = DateTime.now();
  if(currentDate.day == date.day){
    return '${date.day}-${date.month}-${date.year} ${getHour(date.hour)}:${date.minute} ${getMoN(date.hour)}';
  }else{
    return '${date.day} / ${date.month} / ${date.year} ';
  }

}


String getHour(int hour){
  if(hour == 24 || hour == 12 || hour == 0){
    return '12';
  }else{
    return (hour % 12).toString();
  }
}

String getMoN(int hour){
  if(hour >= 12 && hour < 24){
    return 'PM' ;
  }else{
    return 'AM' ;
  }
}


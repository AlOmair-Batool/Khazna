import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sim/Pages/auth_file.dart';

UserController userController = Get.put(UserController());


class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;

  UserModel({this.uid, this.email, this.firstName, this.secondName});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['userID'],
      email: map['email'],
      firstName: map['firstname'],
      secondName: map['secondname'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstname': firstName,
      'secondname': secondName,
    };
  }
}
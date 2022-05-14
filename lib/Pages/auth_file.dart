//@dart=2.8
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sim/Pages/root_app.dart';
import 'package:sim/core/functions/validation.dart';
import 'package:sim/core/global.dart';
import 'package:sim/model/user_model.dart';


class UserController extends GetxController{

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController otpController = TextEditingController();




  void signInUser(context)async
  {
    String email = emailController.text;
    String password = passwordController.text;

    try{
      final User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)).user;
      print(user.email);
      Map<String,dynamic> userData = (await FirebaseFirestore.instance.collection('users').where('email',isEqualTo: emailController.text).get()).docs.first.data();
      print(userData);
      currentUser = UserModel.fromMap(userData);
      emailController.clear();
      passwordController.clear();
      Navigator.push(context, MaterialPageRoute(builder: (_)=> RootApp()));

    }catch  (e) {
      print(e);
      print(emailController.text);
      print(passwordController.text);
      emailController.clear();
      passwordController.clear();
      showSnackBar("Incorrect email or Passward!", context);

    }
  }



  void signUpUser(context) async {
    try{ // do this
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      DocumentReference ref = await FirebaseFirestore.instance.collection('users')
          .add({
        'firstname': firstNameController.text,
        'secondname': secondNameController.text,
        'email': emailController.text,
      });

      ref.update({
        'userID': ref.id
      }

      );

      firstNameController.clear();
      secondNameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      showSnackBar("Signup Success", context);
    }catch(error){
      showSnackBar("Email is already in use by another account! ", context);

    }
  }

  void forgotPassword(context)async{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
    showSnackBar("Please check your email inbox!", context);
    emailController.clear();
  }

  void showSnackBar(String message, BuildContext context) {
    final snackBar = SnackBar(
        content: Text(message),
        backgroundColor: Colors.red
    );


    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<bool> updatePassword(String oldPassword,String newPassword,BuildContext context) async{
    try {
      User currentUser = FirebaseAuth.instance.currentUser;
      var aurhCredential = EmailAuthProvider.credential(
          email: currentUser.email.toString(), password: oldPassword);
      var authResult = await currentUser.reauthenticateWithCredential(
          aurhCredential);
      authResult.user.updatePassword(newPassword);



      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      //   return Login();
      // }));
      return true;
    }catch(e){
      showAlertDialog(context,'Wrong password', false);
      return false;
    }
  }
}
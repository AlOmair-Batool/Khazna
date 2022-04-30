import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sim/Pages/root_app.dart';
import 'package:sim/core/global.dart';
import 'package:sim/model/user_model.dart';


class UserController extends GetxController{

  TextEditingController emailController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();

  TextEditingController firstNameController = new TextEditingController();
  TextEditingController secondNameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  TextEditingController confirmPasswordController = new TextEditingController();

  TextEditingController otpController = new TextEditingController();




  void signInUser(context)async
  {
    String email = emailController.text;
    String password = passwordController.text;

    try{
      final User? user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)).user;
      print(user!.email);
      Map<String,dynamic> userData = (await FirebaseFirestore.instance.collection('users').where('email',isEqualTo: emailController.text).get()).docs.first.data();
      print('11111111111111');
      print(userData);
      print('22222222222222');
      currentUser = UserModel.fromMap(userData);
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

    };
  }

  void forgotPassword(context)async{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
    showSnackBar("Please check your email inbox!", context);
    emailController.clear();
  }

  void showSnackBar(String message, BuildContext context) {
    final snackBar = new SnackBar(
        content: new Text(message),
        backgroundColor: Colors.red
    );


    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
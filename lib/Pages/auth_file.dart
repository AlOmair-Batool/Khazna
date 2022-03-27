import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sim/Pages/root_app.dart';
// import 'home_page.dart';


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
      // emailController.clear();
      // passwordController.clear();

      // Get.to(HomeScreen());
      Navigator.push(context, MaterialPageRoute(builder: (_)=> RootApp()));

    }
    on FirebaseAuthException catch  (e) {
      emailController.clear();
      passwordController.clear();
      showSnackBar("Incorrect username or Passward!", context);
      onClose();
      print('Failed with error code: ${e.code}');
      print(e.message);
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
        // 'phone': phoneController.text,
        // 'password': passwordController.text,
      });

      ref.update({
        'userID': ref.id
      }

      );

      firstNameController.clear();
      secondNameController.clear();
      emailController.clear();
      // phoneController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      showSnackBar("Signup Success", context);
    }catch(error){
      showSnackBar("Email is already in use by another account! ", context);

    };
    // await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text)
    // .catchError((signUpError){
    //   print(" The errrrrrrrrrrrooooooooooorrrrrrrrrrrrrr :$signUpError");
    // });


  }

  void forgotPassword(context)async{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
    showSnackBar("Please check your email inbox!", context);
    emailController.clear();
  }

  void showSnackBar(String message, scaffoldContext) {
    final snackBar = new SnackBar(
        content: new Text(message),
        backgroundColor: Colors.red
    );

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    Scaffold.of(scaffoldContext).showSnackBar(snackBar);
  }



// void verified(){
//   emailController.clear();
//   otpController.clear();
//   passwordController.clear();
//   userNameController.clear();
//   confirmPasswordController.clear();
//   phoneController.clear();
// }


}

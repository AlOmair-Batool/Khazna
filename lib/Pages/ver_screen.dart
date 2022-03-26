import 'package:flutter/material.dart';

// import 'dart:ffi';

import 'package:email_auth/email_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sim/pages/auth_file.dart';
import 'login_screen.dart';
import 'package:sim/Pages/login_screen.dart';




class UserEmailAuth extends StatefulWidget {

  @override
  _UserEmailAuthState createState() => _UserEmailAuthState();
}

class _UserEmailAuthState extends State<UserEmailAuth> {
  UserController userController = Get.put(UserController());
  final verificationForm = FormGroup({
    'email': FormControl(validators: [Validators.required]),
    'otp': FormControl(validators: [Validators.required]),
  });

  final _formKey = GlobalKey<FormState>();


  // Controllers
  // TextEditingController _emailCotroller = TextEditingController();
  // TextEditingController _otpController = TextEditingController();
  // Methods for OTP
  Future<bool> sendOTP()async{
    EmailAuth  emailAuth = EmailAuth(sessionName: "khazna");
    bool res= await emailAuth.sendOtp(recipientMail: userController.emailController.value.text);
    if(res){
      return res;
    }
    else{
      return res;
    }
  }

  Future<bool> verifyOTP()async{
    EmailAuth  emailAuth = EmailAuth(sessionName: "Khazna");
    bool res= await emailAuth.validateOtp(recipientMail: userController.emailController.value.text,
        userOtp: userController.otpController.value.text);
    return res;
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'Email Verification',
                    style: TextStyle(
                      // fontFamily: CustomFonts.sitkaFonts,
                      color:Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                ],
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body:SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child:ReactiveForm(
                  formGroup: verificationForm,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 136,
                                // width: Sizes.s136,
                                // child: Image.asset('logo'.png),
                              ),

                              const SizedBox(height: 24),
                              TextFormField(

                                controller: userController.emailController,
                                validator: (val){
                                  String pattern = r'\w+@\w+\.\w+';
                                  RegExp regex = RegExp(pattern);
                                  if(val!.isEmpty){
                                    return 'Email required.';
                                  }else if(!regex.hasMatch(val)){
                                    return 'Invalid Email Format';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.black, width: 0.0),
                                    ),
                                    suffixIcon: TextButton(
                                      onPressed: (){
                                        sendOTP();
                                        showDialog(
                                          context: context,
                                          builder: (_){
                                            return alertDialog("OTP sent !", "");
                                          },
                                        );
                                        // userController.emailController.clear();
                                      },
                                      child: Text('Send OTP', style: TextStyle(fontSize: 15, color:Colors.black, fontWeight: FontWeight.w900 ),),
                                    ),
                                    isDense: true,
                                    label: Text("Email")
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                obscureText: true,
                                validator: (val){
                                  // String pattern = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$";
                                  // RegExp regex = RegExp(pattern);
                                  if(val!.isEmpty)
                                    return "Otp required! ";
                                  return null;
                                },
                                controller: userController.otpController,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.black, width: 0.0),
                                    ),
                                    isDense: true,
                                    label: Text("Enter OTP ")
                                ),
                              ),


                              const SizedBox(height: 24),
                              ReactiveFormConsumer(
                                builder: (context, formGroup, child) {
                                  return ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.teal.shade100),
                                    ),
                                    child: Text("Verify", style: TextStyle(color: Colors.black),),
                                    // title: 'Verify OTP',
                                    onPressed: (){
                                      // if(_formKey.currentState!.validate())
                                      // {
                                      //   userController.signInUser(context);
                                      // }
                                      verifyOTP().then((value){
                                        if(_formKey.currentState!.validate()){
                                          if(value== true){
                                            userController.signUpUser(context);
                                            showDialog(
                                              context: context,
                                              builder: (_){
                                                return alertDialog("OTP Verified !", "Thanks for your patience");
                                              },
                                            );
                                            setState(() {
                                              Future.delayed(Duration(seconds: 3) , navigation); // do this

                                            });
                                            // userController.verified();
                                          }else{
                                            showDialog(
                                              context: context,
                                              builder: (_){
                                                return alertDialog("Invalid OTP", "Please try again!");
                                              },
                                            );
                                          }
                                        }
                                      }


                                      );

                                    },

                                  );
                                },
                              ),
                              const SizedBox(height: 16),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ),
            )
        ));
  }
  void navigation(){
    Navigator.push(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
  }
  Widget alertDialog(String title, String message) {
    return AlertDialog(
      title: Text("$title") ,
      content: Text("$message"),
    );


  }


}

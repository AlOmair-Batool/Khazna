import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sim/classes/language_constants.dart';
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
    bool res= emailAuth.validateOtp(recipientMail: userController.emailController.value.text,
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
                  Text(
                    translation(context).email_verification,
                    style: TextStyle(
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
                              const SizedBox(
                                height: 136,
                              ),

                              const SizedBox(height: 24),
                              TextFormField(

                                controller: userController.emailController,
                                validator: (val){
                                  String pattern = r'\w+@\w+\.\w+';
                                  RegExp regex = RegExp(pattern);
                                  if(val!.isEmpty){
                                    return translation(context).email_required;
                                  }else if(!regex.hasMatch(val)){
                                    return translation(context).invalid_format;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black, width: 0.0),
                                    ),
                                    suffixIcon: TextButton(
                                      onPressed: (){
                                        sendOTP();
                                        showDialog(
                                          context: context,
                                          builder: (_){
                                            return alertDialog(translation(context).otp_sent, "");
                                          },
                                        );
                                        // userController.emailController.clear();
                                      },
                                      child:  Text(translation(context).send_otp, style: TextStyle(fontSize: 15, color:Colors.black, fontWeight: FontWeight.w900 ),),
                                    ),
                                    isDense: true,
                                    label:  Text(translation(context).email)
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                obscureText: true,
                                validator: (val){
                                  if(val!.isEmpty) {
                                    return translation(context).otp_required;
                                  }
                                  return null;
                                },
                                controller: userController.otpController,
                                decoration:  InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black, width: 0.0),
                                    ),
                                    isDense: true,
                                    label: Text(translation(context).enter_otp)
                                ),
                              ),


                              const SizedBox(height: 24),
                              ReactiveFormConsumer(
                                builder: (context, formGroup, child) {
                                  return ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.teal.shade100),
                                    ),
                                    child: Text(translation(context).verify, style: TextStyle(color: Colors.black),),
                                    onPressed: (){
                                      verifyOTP().then((value){
                                        if(_formKey.currentState!.validate()){
                                          if(value== true){
                                            userController.signUpUser(context);
                                            showDialog(
                                              context: context,
                                              builder: (_){
                                                return alertDialog(translation(context).otp_verified, translation(context).thanks);
                                              },
                                            );
                                            setState(() {
                                              Future.delayed(const Duration(seconds: 3) , navigation); // do this

                                            });
                                          }
                                          else{
                                            showDialog(
                                              context: context,
                                              builder: (_){
                                                return alertDialog(translation(context).invalid_otp, translation(context).try_again);
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
    Navigator.push(context, MaterialPageRoute(builder: (_)=> const LoginScreen()));
  }
  Widget alertDialog(String title, String message) {
    return AlertDialog(
      title: Text(title) ,
      content: Text(message),
    );
  }
}
import 'package:sim/Pages/ver_screen.dart';
import 'package:flutter/material.dart';
import 'package:sim/theme/colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sim/pages/auth_file.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // final _auth = FirebaseAuth.instance;
  UserController userController = Get.find();
  final signUpForm = FormGroup({
    'username': FormControl(validators: [Validators.required]),
    'email': FormControl(validators: [Validators.required]),
    'phoneNumber': FormControl(validators: [Validators.required]),
    'password': FormControl(validators: [Validators.required]),
    'confirmPassword': FormControl(validators: [Validators.required]),
  });

  final _formKey = GlobalKey<FormState>(); // work from here


  @override
  Widget build(BuildContext context) {
    //firstname field
    final firstNameField = TextFormField(
        autofocus: false,
        controller: userController.firstNameController,
        keyboardType: TextInputType.name,

        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },

        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(
              Icons.account_circle_outlined,
              color: primary),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        )
    );

    //secondName field
    final secondNameField = TextFormField(
        autofocus: false,
        controller: userController.secondNameController,
        keyboardType: TextInputType.name,

        validator: (value) {
          if (value!.isEmpty) {
            return ("Second Name cannot be Empty");
          }
          return null;
        },

        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(
              Icons.account_circle_outlined,
              color: primary),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Second Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        )
    );

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: userController.emailController,
        keyboardType: TextInputType.emailAddress,
        //validator: (){},
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },

        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(
              Icons.mail_outlined,
              color: primary),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        )
    );

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: userController.passwordController,
        obscureText: true,
        //validator: (){},
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required!");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },

        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(
              Icons.vpn_key_outlined,
              color: primary),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        )
    );

    //confirmPassword field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: userController.confirmPasswordController,
        obscureText: true,
        //validator
        validator: (value) {
          if (value!.isEmpty) {
            return ("Password is required!");
          } else if (userController.confirmPasswordController.text !=
              userController.confirmPasswordController.text) {
            return "Password don't match";
          }
          return null;
        },

        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(
              Icons.vpn_key_outlined,
              color: primary),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        )
    );


    //sign up button
    final signUpButton = Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(30),
      color: primary,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          minWidth: MediaQuery
              .of(context)
              .size
              .width,
          onPressed: () {
            if(_formKey.currentState!.validate())
            {
              if(userController.passwordController.text == userController.confirmPasswordController.text)
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserEmailAuth()),
                );
              }
              else
              {
                userController.showSnackBar("Password not match", context);
              }
            }
          },

          child: Text("Register", textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
          )),

    );
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Register"),
        titleTextStyle: TextStyle(color: Colors.black ,
            fontSize: 20,
            fontWeight: FontWeight.bold ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primary),
          onPressed: () {
            //passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                    ),
                    SizedBox(height: 60),
                    firstNameField,

                    SizedBox(height: 20),
                    secondNameField,

                    SizedBox(height: 20),
                    emailField,

                    SizedBox(height: 20),
                    passwordField,

                    SizedBox(height: 20),
                    confirmPasswordField,
                    SizedBox(height: 20),
                    signUpButton,
                    SizedBox(height: 15,)
                  ],
                ),
              ),
            ),

          ),
        ),
      ),
    );
  }

  void signUp(){
    Navigator.push(context, MaterialPageRoute(builder: (_)=> UserEmailAuth()));
  }
}
import 'package:sim/Pages/registration_screen.dart';
import 'package:sim/Pages/reset_screen.dart';
import 'package:flutter/material.dart';
import 'package:sim/theme/colors.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sim/pages/auth_file.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserController userController = Get.put(UserController());
  final loginForm = FormGroup({
    'email': FormControl(validators: [Validators.required]),
    'password': FormControl(validators: [Validators.required]),
  });

  final _formKey = GlobalKey<FormState>();
  // form key


  @override
  Widget build(BuildContext context) {

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: userController.emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) { //validator
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

        // onSaved: (value) {
        //   emailController.text = value!;
        // },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.mail_outlined,
            color: primary,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        )
    );

    //password
    final passwordField = TextFormField(
        autofocus: false,
        controller: userController.passwordController,
        obscureText: true,

        //validator: (){},
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
          return null;
        },

        // onSaved: (value) {
        //   passwordController.text = value!;
        // },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: const Icon(
              Icons.vpn_key_outlined,
              color: primary),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        )
    );

    final loginButton = Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(30),
      color: primary,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed : (){
            if(_formKey.currentState!.validate()){
              userController.signInUser(context);
            }else{

            }

          },

          child: const Text("Login", textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
          )),

    );


    return Scaffold(

      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(color: Colors.black ,
            fontSize: 20,
            fontWeight: FontWeight.bold

        ),

        automaticallyImplyLeading: false,

        elevation: 0,

      ),
      backgroundColor: Colors.white,

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
                    const Text('Welcome Back to Khazna!', style: TextStyle( color: Colors.black,
                        fontSize:28,
                        fontWeight: FontWeight.w500
                    )),
                    const Text('Please fill your registered information below:', style: TextStyle( color: Colors.grey,
                      fontSize:15,
                      height: 2,
                    )
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    const SizedBox(height: 60),
                    emailField,
                    const SizedBox(height: 20),
                    passwordField,
                    const SizedBox(height: 35),
                    loginButton,
                    const SizedBox(height: 25),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Don't have an account? ", style: TextStyle( color: Colors.black,
                            fontSize:15,
                            height: 2,
                          )),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegistrationScreen()));
                            },
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                  height: 2,
                                  fontSize: 15),
                            ),
                          ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Forget password? ", style: TextStyle( color: Colors.black,
                            fontSize:15,
                            height: 2,
                          )),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ResetScreen()));
                            },
                            child: const Text(
                              "Reset",
                              style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                  height: 2,
                                  fontSize: 15),
                            ),
                          ),
                        ])
                  ],
                ),
              ),
            ),

          ),
        ),
      ),
    );
  }
}
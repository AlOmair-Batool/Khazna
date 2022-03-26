import 'package:sim/Pages/registration_screen.dart';
import 'package:sim/Pages/root_app.dart';
import 'package:sim/Pages/ver_screen.dart';
import 'package:sim/Pages/reset_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sim/theme/colors.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // form key
  final _formKey = GlobalKey<FormState>();
  bool isEmailVerified = false;

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
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

        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.mail_outlined,
            size: 22,
            color: primary,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        )
    );

    //password
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,

        //validator: (){},
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },

        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(
              Icons.key_outlined,
              size: 22,
              color: primary),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        )
    );

    final loginButton = Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(30),
      color: primary,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          minWidth: MediaQuery.of(context).size.width,
          onPressed : (){
            signIn(emailController.text, passwordController.text);
          },
          child: Text("Login", textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
          )),

    );


    return Scaffold(

      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(color: Colors.black ,
            fontSize: 20,
            fontWeight: FontWeight.bold

        ),


        elevation: 0,

      ),
      backgroundColor: Colors.grey.shade100,

      body: Center(


        child: SingleChildScrollView(

          child: Container(
            color: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(

                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('Welcome back to Khazna!', style: TextStyle( color: Colors.black,
                      fontSize:28,
                      fontWeight: FontWeight.w500,

                    )),
                    Text('Please fill the registered information below', style: TextStyle( color: Colors.grey,
                      fontSize:15,
                      fontWeight: FontWeight.w400,
                      height: 2,
                    )
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    SizedBox(height: 60),
                    emailField,
                    SizedBox(height: 20),
                    passwordField,
                    SizedBox(height: 35),
                    loginButton,
                    SizedBox(height: 25),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Don't have an account? ", style: TextStyle( color: Colors.black,
                            fontSize:15,
                            height: 4,
                          )),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationScreen()));
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w500,
                                  height: 4,
                                  fontSize: 15),
                            ),
                          ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Forget password? ", style: TextStyle( color: Colors.black,
                            fontSize:15,
                            height: 2,
                          )),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ResetScreen()));
                            },
                            child: Text(
                              "Reset",
                              style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w500,
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

  // login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {

      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
        Fluttertoast.showToast(msg: "Login Successful"),
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RootApp())),
      })
          .catchError((e)
      {
        Fluttertoast.showToast(msg: e!.message);
      });

    }

  }


}

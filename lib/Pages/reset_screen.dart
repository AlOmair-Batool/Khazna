import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sim/theme/colors.dart';


class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {

  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = new TextEditingController();

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
              color: primary),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        )
    );

    final resetButton = Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(30),
      color: primary,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed : (){
            _auth.sendPasswordResetEmail(email: emailController.text);
            Navigator.of(context).pop();
          },
          child: Text("Reset", textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
          )),

    );




    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text("Reset Password"),
        titleTextStyle: TextStyle(color: Colors.black ,
            fontSize: 20,
            fontWeight: FontWeight.bold ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
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

            color: white,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Form(
                  key: _formKey,
                  child: Column(

                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Trouble logging in?', style: TextStyle( color: Colors.black,
                            fontSize:28,
                            fontWeight: FontWeight.w500,
                            height:4,
                        )),
                        Text('Enter your email and we will send you a link to get back into your account.',textAlign: TextAlign.center, style: TextStyle( color: Colors.grey,
                          fontSize:15,
                          height: 1.5,

                        )),
                        SizedBox(
                          ),
                        SizedBox(height: 40),
                        emailField,
                        SizedBox(height: 25),
                        resetButton,
                        SizedBox(height: 15),


                      ])

              ),
            ),
          ),

        ),
      ),
    );
  }
}
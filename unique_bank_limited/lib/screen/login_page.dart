import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unique_bank_limited/screen/home_page.dart';
import 'package:unique_bank_limited/screen/signup_page.dart';
import 'package:unique_bank_limited/widgets/form_container_widget.dart';

import '../global/toast.dart';
import '../user_auth/firebase_auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isSigning=false;

  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[800],
        title: Text(
          "Login Page",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ Image.network(
              'https://scontent.fdac24-4.fna.fbcdn.net/v/t39.30808-6/434984163_2469458396575873_8550119930709752364_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=5f2048&_nc_ohc=RIHFpb2oXH4Ab7Ysejj&_nc_ht=scontent.fdac24-4.fna&oh=00_AfCXPAwt39UikzJKrJPmqiOpK6zesWVh5xwTbCoUyeOoxw&oe=6613CCC1',
              width: 300, // Adjust the width as needed
              height: 300, // Adjust the height as needed
            ),
              Text(
                "Login",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 30),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              SizedBox(height: 10),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: _signin,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _isSigning ? CircularProgressIndicator(color: Colors.white,): Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account"),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signin() async {

    setState(() {
      _isSigning=true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;
    User? user = await _auth.signinWithEmailAndPassword(email, password);

    setState(() {
      _isSigning=false;
    });

    if (user != null) {
      showToast(message:"User is successfully signed in");
      // Navigator.pushNamed(context,"/home");
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      showToast(message:"Some error occurred");
    }
  }
}

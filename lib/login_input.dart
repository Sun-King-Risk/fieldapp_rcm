
import 'dart:convert';

import 'package:fieldapp_rcm/routing/bottom_nav.dart';
import 'package:fieldapp_rcm/services/auth_services.dart';
import 'package:fieldapp_rcm/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/db.dart';

class LoginInput extends StatefulWidget {
  const LoginInput({super.key});

  @override
  _LoginState createState() => _LoginState();
}
class _LoginState extends State<LoginInput> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void _signupPressed() {
    // You can add your navigation logic here to go to the sign-up page.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }
  Future _loginPressed()  async{
    // You can add your authentication logic here.
    String email = _emailController.text;
    String password = _passwordController.text;
    final url =  Uri.parse('${AppUrl.baseUrl}/signin');
    final response = await http.post(
      url,
      body: {
        'username': email,
        'password': password,
      },
    );
    print(response.statusCode);
    print("dem");
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      print("Failed to sign in");
      throw Exception('Failed to sign in.');
    }
    print('Email: $email, Password: $password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo/sk.png',
              ),
              Form(child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: _loginPressed,
                    child: const Text('Login'),
                  ),
                ],
              )),
              const GoogleSignInButton(),
              TextButton(
                onPressed: _signupPressed,
                child: const Text('Don\'t have an account? Sign up',style:TextStyle(color:Colors.red),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      )
          : OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
        onPressed: () async {
          setState(() {
            _isSigningIn = true;
          });
          User? user = await Authentication.signInWithGoogle(context: context);
          setState(() {
            _isSigningIn = false;
          });
          if (user != null) {
            String? email;
            Navigator.of(context).pushReplacement(

              MaterialPageRoute(
                builder: (context) => const NavPage(

                ),
              ),
            );



          }else{
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginInput(

                ),
              ),
            );
          }
        },
        child: const Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/logo/google.png"),
                height: 35.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Sign in with Email',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
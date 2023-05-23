import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController =  TextEditingController();
  final _usernameController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _countryController = TextEditingController();
  final _regionController = TextEditingController();
  final _areaController = TextEditingController();
  final _roleController = TextEditingController();


  Future _submitForm() async{
    String jsonData = '{"name": "John", "age": 30, "city": "New York"}';
      Map<String, dynamic> data = jsonDecode(jsonData);
      print(data);

    final url = Uri.parse('https://28ec-102-89-32-124.eu.ngrok.io/api/signup');
    print(_emailController.text);
    print(url);
    if (_formKey.currentState!.validate()) {

  // Add your sign-up logic here.
  String email = _emailController.text;
  String password = _passwordController.text;
  String confirmpassword = _passwordController.text;
  String username = _usernameController.text;
  String firstname = _firstnameController.text;
  String lastname = _lastnameController.text;
  String country = _countryController.text;
  String region = _regionController.text;
  String area = _areaController.text;
  String role = _roleController.text;
  String jsonData = '{"username": "username2","email": "email@1.sk","pass1": "password","pass2":"password","fname": "firstname","lname": "lastname","country": "country","region": "region","area": "area","role": "role"}';
      Map<String, dynamic> data = jsonDecode(jsonData);
  print(data);

  print('Email: $email');
  print('Password: $password');
  print('Confirm role: $role');
  /*Map<String, dynamic> body = {
    "username": username,
    "email": email,
    "pass1": password,
    "pass2":confirmpassword,
    "fname": firstname,
    "lname": lastname,
    "country": country,
    "region": region,
    "area": area,
    "role": role,
  };*/
  var headers = {
    "Accept": "application/json",
    "method":"POST",
    "body":jsonData,
  };
  final response = await http.post(
    url,
    headers: headers,

  );
  print({
    "username": username,
    "email": email,
    "pass1": password,
    "pass2":confirmpassword,
    "fname": firstname,
    "lname": lastname,
    "country": country,
    "region": region,
    "area": area,
    "role": role,
  });
  print("Status code 1: ${response.body}");
  if (response.statusCode == 200) {
    print("Status code 2: ${response.statusCode}");
    return json.decode(response.body);
  } else {
    print("Status code 3: ${response.statusCode}");
    throw Exception('Failed to sign up.');
  }
  }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: Text('Sign up'),
  ),
  body: Padding(
  padding: EdgeInsets.all(16.0),
  child: SingleChildScrollView(
    child: Form(
    key: _formKey,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    TextFormField(
    controller: _usernameController,
    decoration: InputDecoration(
    labelText: 'Username',
    ),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Please enter your Username';
    }
    return null;
    },
    ),
    SizedBox(height: 16.0),
    TextFormField(
    controller: _emailController,
    decoration: InputDecoration(
    labelText: 'Email',
    ),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Please enter your Email';
    }
    return null;
    },
    ),
    SizedBox(height: 16.0),
    TextFormField(
    controller: _passwordController,
    obscureText: true,
    decoration: InputDecoration(
    labelText: 'Password',
    ),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Please enter your password';
    }
    },
    ),
      TextFormField(
        controller: _confirmPasswordController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Confirm Password',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please confirm your password';
          }
          if (value != _passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },),

      TextFormField(
        controller: _firstnameController,
        decoration: InputDecoration(
          labelText: 'Firstname',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your Firstname';
          }
          return null;
        },
      ),
      TextFormField(
        controller: _lastnameController,
        decoration: InputDecoration(
          labelText: 'Lastname',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your Lastname';
          }
          return null;
        },
      ),
      TextFormField(
        controller: _countryController,
        decoration: InputDecoration(
          labelText: 'Country',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your Country';
          }
          return null;
        },
      ),
      TextFormField(
        controller: _regionController,
        decoration: InputDecoration(
          labelText: 'Region',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your Region';
          }
          return null;
        },
      ),
      TextFormField(
        controller: _areaController,
        decoration: InputDecoration(
          labelText: 'Area',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your Area';
          }
          return null;
        },
      ),
      TextFormField(
        controller: _roleController,
        decoration: InputDecoration(
          labelText: 'Role',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your Role';
          }
          return null;
        },
      ),
    SizedBox(height: 32.0),
    ElevatedButton(
    onPressed:_submitForm,
    child: Text('Sign up'),
    ),
    ],
    ),
    ),
  ),
  ),
  );
  }
  }

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:fieldapp_rcm/aws_bucket.dart';
import 'package:fieldapp_rcm/step_form.dart';
import 'package:fieldapp_rcm/utils/themes/theme.dart';
import 'package:fieldapp_rcm/widget/drop_down.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fieldapp_rcm/routing/nav_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/servicecontrol/v2.dart';
import 'package:http/http.dart' as http;
import 'package:aws_s3_private_flutter/aws_s3_private_flutter.dart';
import 'package:aws_s3_private_flutter/export.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_task.dart';
import 'amplifyconfiguration.dart';
import 'dashboard.dart';
import 'firebase_options.dart';
import 'models/db.dart';
import 'multTeam.dart';
import 'multform.dart';
import 'new_design.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _configureAmplify();

  runApp(
      MyApp());
}
Future<void> _configureAmplify() async {
  try {
    final storage = AmplifyStorageS3();
    final auth = AmplifyAuthCognito();


    await Amplify.addPlugins([
      auth,
      storage,
  ]);

    await Amplify.configure(amplifyconfig);
  } on Exception catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;
  void getUserAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? auth = prefs.getBool('isLogin');
    setState(() {
      isLogin = auth!;
    });

  }
  @override
  void initState() {
    super.initState();
    getUserAuth();
  }


  @override
  Widget build(BuildContext context) {
    late String selectedTask='';
    late String selectedSubTask='';
    late String regionselected ='';
    late String areaselected ='';
    late String agentselected= '';
    late String priority = '';
    late String target;
    List? _myActivities;
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home:NavPage(),
    );
    /*return Authenticator(
        signUpForm: SignUpForm.custom(
          fields: [
            SignUpFormField.email(required: true),

      SignUpFormField.name(required: true),
      SignUpFormField.custom(
          title: 'Country',
          attributeKey: CognitoUserAttributeKey.custom('Country'),
        required: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a Country';
          }
          return null;
        },

      ),
            SignUpFormField.custom(
              title: 'Zone',
              attributeKey: CognitoUserAttributeKey.custom('Zone'),
              required: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a Zone';
                }
                return null;
              },

            ),
            SignUpFormField.custom(
              title: 'Region',
              attributeKey: CognitoUserAttributeKey.custom('Region'),
              required: true,

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a Region';
                }
                return null;
              },


            ),
            SignUpFormField.custom(
              title: 'Role',
              attributeKey: const CognitoUserAttributeKey.custom('Role'),
              required: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a Region';
                }
                return null;
              },



            ),

            SignUpFormField.password(),
            SignUpFormField.passwordConfirmation(),

        ],

        ),
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        builder: Authenticator.builder(
        ),
        home:NavPage(),
      ),
    );*/
  }

}


class LoginSignUp extends StatefulWidget {
  const LoginSignUp({super.key});

  @override
  State<LoginSignUp> createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {
  @override
  void initState() {
    super.initState();
    listItems("country");
    _configureAmplify();
  }
  Future<StorageItem?> listItems(key) async {
    try {
      StorageListOperation<StorageListRequest, StorageListResult<StorageItem>>
      operation =  await Database.listItems();

      Future<StorageListResult<StorageItem>> result = operation.result;
      List<StorageItem> resultList = (await operation.result).items;
      resultList = resultList.where((file) => file.key.contains(key)).toList();
      if (resultList.isNotEmpty) {
        // Sort the files by the last modified timestamp in descending order
        resultList.sort((a, b) => b.lastModified!.compareTo(a.lastModified!));
        StorageItem latestFile = resultList.first;
        RegionTask(latestFile.key);
        print(latestFile.key);
        print("Key: $key");

        return resultList.first;

      } else {
        print('No files found in the S3 bucket with key containing "$key".');
        return null;
      }
    } on StorageException catch (e) {
      safePrint('Error listing items: $e');
    }
  }
  Future<void> RegionTask(key) async {
    List<String> uniqueRegion = [];
    print("object: $key");

    try {
      StorageGetUrlResult urlResult = await Amplify.Storage.getUrl(
          key: key)
          .result;

      final response = await http.get(urlResult.url);
      final jsonData = jsonDecode(response.body);
      print('File_team: $jsonData');
      for (var item in jsonData) {
        //String region = item['Region'];
        //region?.add(region);
        if(item['Region'] == null){
        }else{
          uniqueRegion.add(item['Region']);
        }

      }
      setState(() {
        data = jsonData;
        region = uniqueRegion.toSet().toList();
        safePrint('File_team: $jsonData');
        isLoading = false;
      });
    } on StorageException catch (e) {
      safePrint('Could not retrieve properties: ${e.message}');
      rethrow;
    }
  }
  bool isLoading = true;
  List? data = [];
  List<String> region= [];

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      // `authenticatorBuilder` is used to customize the UI for one or more steps
      authenticatorBuilder: (BuildContext context, AuthenticatorState state) {
        switch (state.currentStep) {
          case AuthenticatorStep.signIn:
            return CustomScaffold(
              state: state,
              // A prebuilt Sign In form from amplify_authenticator
              body: SignInForm(
              ),
              // A custom footer with a button to take the user to sign up
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () => state.changeStep(
                      AuthenticatorStep.signUp,
                    ),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            );
          case AuthenticatorStep.signUp:
            return CustomScaffold(
              state: state,
              // A prebuilt Sign Up form from amplify_authenticator
              body: Container(
                  child: AppDropDown(
                    disable: false,
                    label: 'Country',
                    hint: 'COuntry',
                    items: region,
                    onChanged: (value ) {
                      setState(() {

                      });
                    },),

              ),
              // A custom footer with a button to take the user to sign in
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () => state.changeStep(
                      AuthenticatorStep.signIn,
                    ),
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            );
          case AuthenticatorStep.confirmSignUp:
            return CustomScaffold(
              state: state,
              // A prebuilt Confirm Sign Up form from amplify_authenticator
              body: ConfirmSignUpForm(),
            );
          case AuthenticatorStep.resetPassword:
            return CustomScaffold(
              state: state,
              // A prebuilt Reset Password form from amplify_authenticator
              body: ResetPasswordForm(),
            );
          case AuthenticatorStep.confirmResetPassword:
            return CustomScaffold(
              state: state,
              // A prebuilt Confirm Reset Password form from amplify_authenticator
              body: const ConfirmResetPasswordForm(),
            );
          default:
          // Returning null defaults to the prebuilt authenticator for all other steps
            return null;
        }
      },
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        builder: Authenticator.builder(),
        home: NavPage(),
      ),
    );
  }
}

/// A widget that displays a logo, a body, and an optional footer.
class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.state,
    required this.body,
    this.footer,
  });

  final AuthenticatorState state;
  final Widget body;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // App logo
              Padding(
                padding: EdgeInsets.only(top: 32),
                child: Center(child:Image.asset(
                  'assets/logo/sk.png',
                )),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: body,
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: footer != null ? [footer!] : null,
    );
  }
}


class LoginSignupApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: LoginSignupPage(),
    );
  }
}

class LoginSignupPage extends StatefulWidget {
  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}
enum AuthMode { Login, Signup }
class _LoginSignupPageState extends State<LoginSignupPage> {
  final _formKey = GlobalKey<FormState>();

   String _email ='';
   String _password ='';
   String _confirmPassword ='';
   String role ='';
   String zone ='';
   String region ='';
   String area ='';
   String country ='';
   String firstname ='';
   String lastname ='';
  AuthMode _authMode = AuthMode.Login;

  Future<void> _submitForm() async {
    print(_authMode);
    if (_formKey.currentState!.validate()) {
      var connection = await Database.connect();
      if(_authMode == AuthMode.Login){
        var results = await connection.query( "SELECT * FROM fieldappusers_feildappuser WHERE email = @email AND password = @password",
          substitutionValues: {"email":_email,"password": _password},);
        SharedPreferences prefs = await SharedPreferences.getInstance();



        if (results.isNotEmpty) {
          print(results);
          var Row = results[0];
          prefs.setString('email', Row[4]);
          prefs.setString('name', Row[6]);
          prefs.setString('country', Row[8]);
          prefs.setString('zone', Row[10]);
          prefs.setString('region', Row[9]);
          prefs.setString('area', Row[14]);
          prefs.setString('role', Row[11]);
          prefs.setString('email', _email);
          prefs.setBool('isLogin',true);
          print(prefs.get('name'));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavPage()));
        }else{
          final snackBar = SnackBar(
            content: Text('Incorrect credentials please try again'),
            duration: Duration(seconds: 3),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }else {
        try{
          await  connection.execute("insert into fieldappusers_feildappuser (username,email,password, first_name,last_name,country,zone,region,area,role,is_superuser,is_staff,is_active) values ('$_email','$_email','$_password','$firstname','$lastname','$country','$zone','$region','$zone','$role','false','true','true')   ");
        }catch (e) {
          print('Error executing query: $e');
        } finally {
          await connection.close();
        }
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(10,100.0,0,0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(_authMode == AuthMode.Signup)
                  Column(children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'First Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your First Name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        firstname = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Last Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Last Name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        lastname = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Country'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Country';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        country = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Zone'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Zone';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        zone = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Region'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Region';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        region = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Role'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Role';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        role = value;
                      },
                    ),
                  ],),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _password = value;
                  },
                ),
                if (_authMode == AuthMode.Signup)

                  TextFormField(
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter confirm password';
                      } else if (value != _password) {
                        return 'Password does not match';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _confirmPassword = value;
                      });
                    },
                  ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  child: Text(_authMode == AuthMode.Login ? 'Login' : 'Sign Up'),
                  onPressed: _submitForm,
                ),
                TextButton(
                  child: Text(_authMode == AuthMode.Login ? 'Create Account' : 'Back to Login'),
                  onPressed: () {
                    setState(() {
                      _authMode = _authMode == AuthMode.Login ? AuthMode.Signup : AuthMode.Login;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





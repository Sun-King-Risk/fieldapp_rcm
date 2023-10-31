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
      if(auth != null){
        isLogin = auth!;
      }

    });

  }
  @override
  void initState() {
    super.initState();
    getUserAuth();
    print(isLogin);
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
      home: isLogin?NavPage():LoginSignupApp(),
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
    CoutryData("country");
    _configureAmplify();
  }
  Future<void> CoutryData(key) async {
    List<String> uniqueCountry = [];
    print("object: $key");

    try {

      StorageGetUrlResult urlResult = await Amplify.Storage.getUrl(
          key: key)
          .result;

      final response = await http.get(urlResult.url);
      final jsonData = jsonDecode(response.body);
      print('File_team: $jsonData');

      print(jsonData.length);

      for (var item in jsonData) {
        uniqueCountry.add(item['Region']);

      }
      setState(() {
        countrydata = uniqueCountry.toSet().toList();
        data = jsonData;
        isLoading = false;

      });
    } on StorageException catch (e) {
      safePrint('Could not retrieve properties: ${e.message}');
      rethrow;
    }
  }
  bool isLoading = true;
  List? data = [];
  List<String> countrydata = [];
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

  bool isLoading = true;
  List? data = [];
  List<String> zonedata = [];
  List<String> regiondata = [];
  List<String> countrydata = [];
  List<String> areadata = [];
  AuthMode _authMode = AuthMode.Login;

  Future<void> _submitForm() async {
    print(_authMode);
    if (_formKey.currentState!.validate()) {
      var connection = await Database.connect();
      if(_authMode == AuthMode.Login){
        final response = await http.post(
          Uri.parse('https://sun-kingfieldapp.herokuapp.com/api/auth/signin'), // Replace with your API endpoint URL.
          body: {
            'email': _email,
            'pass1': _password,
          },
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();

        if (response.statusCode== 200) {
          var results = await connection.query( "SELECT * FROM fieldappusers_feildappuser WHERE email = @email",
              substitutionValues: {"email":_email});
          var Row = results[0];
          prefs.setString('email', Row[4]);
          prefs.setString('name', Row[6] + ' ' + Row[7]);
          prefs.setString('country', Row[8]);
          prefs.setString('zone', Row[14]);
          prefs.setString('region', Row[9]);
          prefs.setString('area', Row[10]);
          prefs.setString('role', Row[11]);
          prefs.setString('email', _email);
          prefs.setBool('isLogin',true);
          print(prefs.get('name'));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavPage()));
        }else{
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          String successMessage = responseData['error'];
          final snackBar = SnackBar(
            content: Text(successMessage),
            duration: Duration(seconds: 3),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }else {
        try{
          final response = await http.post(
            Uri.parse('https://sun-kingfieldapp.herokuapp.com/api/auth/signup'),
            body: {
              'username' : _email,
              'fname' :firstname ,
              'lname' : lastname,
              'email' : _email,
              'country' :country,
              'zone' : zone,
              'region' :region ,
              'area' : area,
              'role' : role,
              'pass1' : _password,
              'pass2' : _confirmPassword,

            },
          );
          if(response.statusCode == 201){
            final Map<String, dynamic> responseData = jsonDecode(response.body);
            String successMessage = responseData['message'];
            final snackBar = SnackBar(

              content: Text(successMessage),
              duration: Duration(seconds: 3),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            setState(() {
              _authMode = AuthMode.Login;
            });
          }else{
            print(response.body);
            final Map<String, dynamic> responseData = jsonDecode(response.body);
            String successMessage = responseData['error'];
            final snackBar = SnackBar(
              content: Text(successMessage),
              duration: Duration(seconds: 3),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            print(successMessage);
          }
        }catch (e) {
          print('Error executing query: $e');
        } finally {
          await connection.close();
        }
        }
    }
  }
  Future<StorageItem?> listItems(key) async {
    try {
      StorageListOperation<StorageListRequest, StorageListResult<StorageItem>>
      operation = await Amplify.Storage.list(
        options: const StorageListOptions(
          accessLevel: StorageAccessLevel.guest,
          pluginOptions: S3ListPluginOptions.listAll(),
        ),
      );

      Future<StorageListResult<StorageItem>> result = operation.result;
      List<StorageItem> resultList = (await operation.result).items;
      resultList = resultList.where((file) => file.key.contains(key)).toList();
      if (resultList.isNotEmpty) {
        // Sort the files by the last modified timestamp in descending order
        resultList.sort((a, b) => b.lastModified!.compareTo(a.lastModified!));
        StorageItem latestFile = resultList.first;

        CoutryData(latestFile.key);
        return resultList.first;
      } else {
        print('No files found in the S3 bucket with key containing "$key".');
        return null;
      }
      safePrint('Got items: ${resultList.length}');
    } on StorageException catch (e) {
      safePrint('Error listing items: $e');
    }
  }
  Future<void> CoutryData(key) async {
    List<String> uniqueCountry = [];
    print("data Object: $key");


    try {
      StorageGetUrlResult urlResult = await Amplify.Storage.getUrl(
          key: key)
          .result;

      final response = await http.get(urlResult.url);
      final jsonData = jsonDecode(response.body);
      print('File_team: $jsonData');

      print(jsonData.length);

      for (var item in jsonData) {
        uniqueCountry.add(item['Country']);

      }
      setState(() {
        countrydata = uniqueCountry.toSet().toList();
        data = jsonData;
        isLoading = false;

      });
    } on StorageException catch (e) {
      safePrint('Could not retrieve properties: ${e.message}');
      rethrow;
    }
  }
  Future<void> Zone() async {
    List<String> uniqueZone = [];
    final jsonZone = data?.where((item) => item['Country'] == country).toList();
    for (var ZoneList in jsonZone!) {
      String Zone = ZoneList['Zone'];
      //region?.add(region);
      uniqueZone.add(Zone);
    }
    setState(() {

      zonedata = uniqueZone.toSet().toList();
      safePrint('File_team: $data');
    });
    //safePrint('Area: $area');
  }
  Future<void> Region() async {
    List<String> uniqueRegion= [];
    final jsonArea = data?.where((item) => item['Zone'] == zone && item['Country']== country).toList();
    for (var RegionList in jsonArea!) {
      String region = RegionList['Region'];
      //region?.add(region);
      uniqueRegion.add(region);
    }
    setState(() {

      regiondata = uniqueRegion.toSet().toList();
      safePrint('File_team: $regiondata');
    });
    //safePrint('Area: $area');
  }
  Future<void> _showForgotPasswordDialog() async {
    final TextEditingController emailController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forgot Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Please enter your email to reset your password.'),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Reset Password'),
              onPressed: () {
                // Add your password reset logic here, e.g., send a password reset email
                // You can use the emailController.text to get the user's email
                // After the password reset is initiated, you can close the dialog.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> Area() async {
    List<String> uniqueArea = [];
    final jsonArea = data?.where((item) => item['Region'] == region && item['Country']== country).toList();
    for (var areaList in jsonArea!) {
      String area = areaList['Current Area'];
      //region?.add(region);
      uniqueArea.add(area);
    }
    setState(() {

      areadata = uniqueArea.toSet().toList();
      safePrint('File_team: $areadata');
    });
    //safePrint('Area: $area');
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    listItems("country");

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
                Center(
                    child: Image.asset('assets/logo/sk.png'),),
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
                    SizedBox(height: 10,),
                    AppDropDown(
                        disable: false,
                        label: "Country",
                        hint: "Country",
                        items: countrydata,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Country';
                          }
                          return null;
                        },
                        onChanged: (value){
                          country = value;
                          setState(() {
                            zone = "";
                            zonedata = [];
                          });
                          Zone();
                        }),
                    SizedBox(height: 10,),
                    AppDropDown(
                        disable: false,
                        label: "Zone",
                        hint: "Zone",
                        items: zonedata,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Zone';
                          }
                          return null;
                        },
                        onChanged: (value){
                          zone = value;
                          regiondata=[];
                          Region();
                        }),
                    SizedBox(height: 10,),

                    AppDropDown(
                        disable: false,
                        label: "Region",
                        hint: "Region",
                        items: regiondata,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Zone';
                          }
                          return null;
                        },
                        onChanged: (value){
                          region = value;
                          Area();
                        }),
                    SizedBox(height: 10,),
                    AppDropDown(
                        disable: false,
                        label: "Area",
                        hint: "Area",
                        items: areadata,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Area';
                          }
                          return null;
                        },
                        onChanged: (value){
                          area = value;
                        }),
                    SizedBox(height: 10,),
                    AppDropDown(
                        disable: false,
                        label: "Role",
                        hint: "Role",
                        items: const [
                          "Area Collection Executive",
                          "Country Credit Manager",
                          "Zonal Credit Manager",
                          "Senior Credit Analyst",
                          "Regional Collections Manager"
                        ],
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Role';
                          }
                          return null;
                        },
                        onChanged: (value){
                          role = value;
                        }),

                  ],),
                SizedBox(height: 10,),

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
                TextButton(
                  child: Text('Forgot Password?'),
                  onPressed: _showForgotPasswordDialog, // Create this function
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





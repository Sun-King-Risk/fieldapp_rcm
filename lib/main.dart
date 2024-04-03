import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:fieldapp_rcm/utils/themes/theme.dart';
import 'package:fieldapp_rcm/widget/drop_down.dart';
import 'package:fieldapp_rcm/routing/nav_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aws_s3_private_flutter/export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'amplifyconfiguration.dart';
import 'models/db.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();

  runApp(
      const MyApp()
  );
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
      if(auth != null){
        setState(() {
          isLogin = auth;
        });
        print(isLogin);
      }



  }
  @override
  void initState() {
    super.initState();
    getUserAuth();
    print("init $isLogin");
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
    List? myActivities;
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: isLogin?const NavPage():const LoginSignupPage(),
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

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({super.key});

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
  List<String> _selectedValues = [];

  bool isLoading = true;
  List? data = [];
  List<String> zonedata = [];
  List<String> regiondata = [];
  List<String> regionug = [];
  List<String> countrydata = [];
  List<String> areadata = [];
  AuthMode _authMode = AuthMode.Login;

  Future<void> _submitForm() async {

    if (_formKey.currentState!.validate()) {
      if(_authMode == AuthMode.Login){
        final response = await http.post(
          Uri.parse('${AppUrl.baseUrl}/auth/signin'), // Replace with your API endpoint URL.
          body: {
            'email': _email,
            'pass1': _password,
          },
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (response.statusCode== 200) {
          /*var results = await connection.query( "SELECT * FROM fieldappusers_feildappuser WHERE email = @email",
              substitutionValues: {"email":_email});
          var Row = results[0];*/
          prefs.setString('email',_email);
          prefs.setString('name', "Dennis Juma");
          prefs.setString('country','Tanzania');
          prefs.setString('zone', "East");
          prefs.setString('region',"Northern");
          prefs.setString('area', "Arusha");
          prefs.setString('role', 'CCM');
          prefs.setString('email', _email);
          prefs.setBool('isLogin',true);
          print(prefs.get('name'));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavPage()));
        }else{
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          String successMessage = responseData['error'];
          final snackBar = SnackBar(
            content: Text(successMessage),
            duration: const Duration(seconds: 3),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }else {
        try{

          final response = await http.post(
            Uri.parse('${AppUrl.baseUrl}/auth/signup'),
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
              duration: const Duration(seconds: 3),
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
              duration: const Duration(seconds: 3),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            print(successMessage);
          }
        }catch (e) {
          print('Error executing query: $e');
        }
        }
    }
  }
  Future<StorageItem?> listCountry(key) async {
    print("init# $key");
    try {
      StorageListOperation<StorageListRequest, StorageListResult<StorageItem>>
      operation = Amplify.Storage.list(
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
        print("latest ${latestFile.key}");
        return resultList.first;
      } else {
        print('No files found in the S3 bucket with key containing "$key".');
        return null;
      }
      safePrint('Got items: ${resultList.length}');
    } on StorageException catch (e) {
      safePrint('Error listing items: $e');
    }
    return null;
  }
  Future<void> CoutryData(key) async {
    List<String> uniqueCountry = [];
    //print("data Object: $key");


    try {
      StorageGetUrlResult urlResult = await Amplify.Storage.getUrl(
          key: key)
          .result;

      final response = await http.get(urlResult.url);
      final jsonData = jsonDecode(response.body);
      print('File_country: $jsonData');

      //print(jsonData.length);

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
  Future<void> UGregion() async {
    List<String> uniqueRegion= [];
    final jsonArea = data?.where((item) => item['Country']== country).toList();
    for (var RegionList in jsonArea!) {
      String region = RegionList['Region'];
      //region?.add(region);
      uniqueRegion.add(region);
    }
    setState(() {

      regionug = uniqueRegion.toSet().toList();

    });
    //safePrint('Area: $area');
  }
  Future<void> _showForgotPasswordDialog() async {
    final TextEditingController emailController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Forgot Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Please enter your email to reset your password.'),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Reset Password'),
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
    listCountry("country_login");

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10,100.0,0,0),
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
                      decoration: const InputDecoration(labelText: 'First Name'),
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
                      decoration: const InputDecoration(labelText: 'Last Name'),
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
                    AppDropDown(
                        disable: false,
                        label: "Role",
                        hint: "Role",
                        items: const [

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
                          if(value == 'Country Credit Manager'){
                            role = "CCM";
                          }else if(value =='Zonal Credit Manager'||value =='Senior Credit Analyst'){
                            role = "Credit Analyst";
                          }else if(value =='Regional Collections Manager'){
                            role = "RCM";
                          }
                          print(role);
                        }),
                    const SizedBox(height: 10,),
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
                          if(value =='Uganda'){
                            UGregion();
                          }else{
                            Zone();
                          }

                        }),
                    const SizedBox(height: 10,),
                    if(role=='Credit Analyst'|| role=='RCM')
                      if(country== 'Uganda')
                        FormField(builder: (
                            FormFieldState<dynamic> field) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: <Widget>[
                                Text("Region"),
                                InputDecorator(
                                  decoration: InputDecoration(
                                    hintText: 'Select options',
                                    border: OutlineInputBorder(),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: null,
                                      isDense: true,
                                      isExpanded: true,
                                      onChanged: (String? value) {
                                        setState(() {
                                          if (_selectedValues.contains(value!)) {
                                            _selectedValues.remove(value);
                                          } else {
                                            _selectedValues.add(value);
                                            zone = _selectedValues.toString();
                                            print(zone);
                                          }
                                          //state.didChange(_selectedValues);
                                        });
                                      },

                                      items:regionug
                                          .map<DropdownMenuItem<String>>((String? value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value!),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  children: _selectedValues
                                      .map<Widget>((String value) => Chip(
                                    label: Text(value),
                                    onDeleted: () {
                                      setState(() {
                                        _selectedValues.remove(value);
                                        // state.didChange(_selectedValues);
                                      });
                                    },
                                  ))
                                      .toList(),
                                ),
                              ]
                          );
                        },),
                      if(country!= 'Uganda')
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
                    const SizedBox(height: 10,),

                    if(role=='RCM')
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
                    const SizedBox(height: 10,),
                    const SizedBox(height: 10,),


                  ],),
                const SizedBox(height: 10,),

                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
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
                  decoration: const InputDecoration(labelText: 'Password'),
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
                    decoration: const InputDecoration(labelText: 'Confirm Password'),
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
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(_authMode == AuthMode.Login ? 'Login' : 'Sign Up'),
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
                  onPressed: _showForgotPasswordDialog,
                  child: const Text('Forgot Password?'), // Create this function
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





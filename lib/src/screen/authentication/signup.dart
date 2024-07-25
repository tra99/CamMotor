import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:cammotor_new_version/src/screen/authentication/forgetpss.dart';
import 'package:cammotor_new_version/src/screen/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String username="";
  
  final TextEditingController _usernameController=TextEditingController();
  final TextEditingController _gmailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.green,
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _signIn() async{
    final String username=_usernameController.text;
    final String gmail=_gmailController.text;
    final String password=_passwordController.text;

    final response=await http.post(
      // Uri.parse('http://143.198.217.4:1026/api/auth/register'),
      Uri.parse('${dotenv.env['BASE_URL']}/auth/register'),
      body: {
        'name':username,
        'email':gmail,
        'password':password,
        'password_confirmation':password
      }
    );
    // sign success
    if(response.statusCode==200){
      final responseData=json.decode(response.body);
      final token=responseData['token'];

      // store token in local
      SharedPreferences prefs=await SharedPreferences.getInstance();
      await prefs.setString('token', token);
    }
    else{
      final err=jsonDecode(response.body)['message'];
      print(err);
    }
  }

  Future<String?>_getToken() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  void initState() {
    super.initState();
    _checkToken();
  }
  Future<void>_checkToken()async{
    final token=await _getToken();
    if(token!=null){
      // Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("assets/images/w3.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.9),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left:10.0,right: 10),
                child: Form(
                  key: formKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Image(image: AssetImage("assets/images/logo3.png")),
                      TextFormField(
                        controller: _usernameController,
                        decoration: textInputDecoration.copyWith(
                          labelText: "ឈ្មោះអ្នកប្រើប្រាស់", 
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) {
                          setState(() {
                            username = value; 
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "សូមបញ្ចូលឈ្មោះអ្នករបស់អ្នក"; 
                          }
                          
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _gmailController,
                        decoration: textInputDecoration.copyWith(
                          labelText: "អុីម៉ែល",
                          labelStyle: const TextStyle(color: Colors.white),
                          // Add more decoration options as needed
                        ),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: (value) {
                          return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value!)
                              ? null
                              : "អុីម៉ែលមិនត្រឹមត្រូវ";
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                          labelText: "លេខសំងាត់",
                          labelStyle: const TextStyle(color: Colors.white),
                          // Add more decoration options as needed
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value!.length < 6) {
                            return "លេខសំងាត់ត្រូវតែមានលេខនិងអក្សរ";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgetPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'ភ្លេចលេខសំងាត់?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.04,),
                    SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              _signIn();
                              Future.delayed(
                                const Duration(seconds: 1),
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                  _showSnackBar(context, 'បង្កើតគណនីជោគជ័យ');
                                },
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'បង្កើតគណនី',
                            style: TextStyle(
                                color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    Text.rich(
                      TextSpan(
                        text: "មានគណនីរួចហើយមែនទេ? ​​",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 234, 232, 234),
                          fontSize: 20,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "ចូលគណនី",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 234, 232, 234),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

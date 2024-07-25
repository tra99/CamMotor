import 'dart:async';
import 'dart:convert';
import 'package:cammotor_new_version/src/screen/authentication/forgetpss.dart';
import 'package:cammotor_new_version/src/screen/authentication/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/widget.dart';
import '../homepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String? errorMessage;


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final response = await http.post(
      // Uri.parse('http://143.198.217.4:1026/api/auth/login'),
      Uri.parse('${dotenv.env['BASE_URL']}/auth/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final token = responseData['data'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      print(token);

      _showSnackBar(context, 'ចូលគណនីជោគជ័យ');

      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      });

    } else {
      setState(() {
        errorMessage = 'Incorrect account';
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          errorMessage = null;
        });
      });
    }
  }

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
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(image: AssetImage("assets/images/logo3.png")),
                      TextFormField(
                        controller: _emailController,
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
                      const SizedBox(height: 20),
                        Text(
                          errorMessage ?? '',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              _login();
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
                            'ចូលគណនី',
                            style: TextStyle(
                                color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          text: "មិនទាន់មានគណនី? ​​",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 234, 232, 234),
                            fontSize: 20,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "បង្កើតគណនី",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 234, 232, 234),
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignUpScreen(),
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
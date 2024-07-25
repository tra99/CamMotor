import 'package:cammotor_new_version/src/screen/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../components/widget.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

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
                padding: const EdgeInsets.only(left:10.0,right: 10),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(image: AssetImage("assets/images/logo3.png")),
                      TextFormField(
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
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                          labelText: "លេខសំងាត់ចាស់",
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
                      const SizedBox(height: 20),
                      TextFormField(
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                          labelText: "លេខសំងាត់ថ្មី",
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
                      SizedBox(height: MediaQuery.of(context).size.height*0.04,),
                    SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Future.delayed(
                                const Duration(seconds: 1),
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                  _showSnackBar(context, 'ផ្លាស់ប្តូរលេខសំងាត់ជោគជ័យ');
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
                            'បង្កើត',
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

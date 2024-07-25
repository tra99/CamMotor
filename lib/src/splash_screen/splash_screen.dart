import 'dart:async';
import 'package:cammotor_new_version/src/screen/authentication/login.dart';
import 'package:cammotor_new_version/src/screen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../intro_screen/intro1.dart';

class SplashPage extends StatefulWidget {
  // final VoidCallback onFinish;
  const SplashPage({Key? key, }) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

   @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Simulating a delay for the splash screen (replace with your desired duration)
    await Future.delayed(const Duration(seconds: 2));

    if (token != null && token.isNotEmpty) {
      // User is logged in, navigate to HomePage
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      // User is not logged in, navigate to LoginScreen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 31, 32),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Image(
                image: AssetImage('assets/images/logo3.png'), width: 300),
            GestureDetector(
              child: const Text.rich(
                TextSpan(
                  text: 'CAMMOTO ',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.white),
                  children: <InlineSpan>[
                    TextSpan(
                        text: 'តែងតែនៅជាមួយអ្នក',
                        style: TextStyle(fontSize: 20,color: Colors.white))
                  ],
                ),
              ),
            ),
            const Text(
              'ទំនុកចិត្ត ភាពជឿជាក់ ទំនួលខុសត្រូវ​ និងសុជីវធម៏',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18,color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset('assets/images/intro3.png', width: 200),
            const SizedBox(
              height: 16,
            ),
            Center(
              child: SpinKitThreeBounce(
                size: 50.0,
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: index.isEven
                              ? Colors.purple.shade800
                              : Colors.purple.shade600));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

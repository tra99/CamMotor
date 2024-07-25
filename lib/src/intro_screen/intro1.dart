
import 'package:cammotor_new_version/src/intro_screen/firstscreen.dart';
import 'package:cammotor_new_version/src/intro_screen/forthscreen.dart';
import 'package:cammotor_new_version/src/intro_screen/secondscreen.dart';
import 'package:cammotor_new_version/src/intro_screen/thirdscreen.dart';
import 'package:cammotor_new_version/src/screen/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  // controller move to next page
  PageController _controller = PageController();

  // last page it will jump to LoginScreen
  bool onLastPage=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage=(index==3);
            });
          },
          children:const [
            IntroductionPage1(),
            IntroScreen2(),
            IntroScreen3(),
            IntroScreen4(),
          ],
        ),
        Container(
          alignment: const Alignment(0, 0.8),
          child: Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                    _controller.jumpToPage(3);
                  },
                    child: const Text(
                  'រំលង',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                )),
                onLastPage?
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                  },
                  child: const Text(
                    'រួចរាល់',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ):GestureDetector(
                  onTap: (){
                    _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                  },
                  child: const Text(
                    'បន្ទាប់',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
            alignment: const Alignment(0, 0.85),
            child: SmoothPageIndicator(controller: _controller, count: 4)),
      ]),
    );
  }
}

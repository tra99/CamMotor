import 'package:flutter/material.dart';

class IntroScreen4 extends StatefulWidget {
  const IntroScreen4({Key? key}) : super(key: key);

  @override
  State<IntroScreen4> createState() => _IntroScreen4State();
}

class _IntroScreen4State extends State<IntroScreen4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20,top: 20),
              child: const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'ការលក់',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            const SizedBox(height: 50),
            imageCenter(),
            const SizedBox(height: 60),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(child: stackBox()),
                  const Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView( 
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              'ការជួសជុលម៉ូតូបមាត្រការមានការដោះកន្លែងដល់ការជំរុញម៉ូតូភ្លាមគ្រឿងភ្លើងឬអនឡាញរាត្រីចំនួនបន្តអោយវាមានស្រាប់ការដំបូងមាត្រូនៅទិន្នន័យរ៉ោម៉ែត្',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 60,),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     TextButton(onPressed: (){Get.to(const LoginPage());}, child: const Text('SKIP',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),
                          //     TextButton(onPressed: (){Get.to(const LoginPage());}, child: const Text('NEXT',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)))
                          //   ],
                          // ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Center imageCenter() {
    return Center(child: Image.asset('assets/images/sell1.jpg',width: 125,));
  }

  Container stackBox() {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 35, 31, 32),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      ),
    );
  }
  Row loading(){
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: SizedBox(
            width: 16,
            height: 16,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 217, 217, 217),
              )
              ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: SizedBox(
            width: 16,
            height: 16,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 217, 217, 217),
              )
              ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: SizedBox(
            width: 16,
            height: 16,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 217, 217, 217),
              )
              ),
          ),
        ),
        SizedBox(
          width: 16,
          height: 16,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 94, 58, 53),
            )
            ),
        )
      ],
    );
  }
}

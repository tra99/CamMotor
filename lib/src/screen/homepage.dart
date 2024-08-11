import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cammotor_new_version/src/screen/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/card/card_custom.dart';
import '../providers/bottom_sheet.dart';
import '../services/store_basket.dart';
import 'order_history/order_list.dart';

class HomePage extends StatefulWidget {
  final Uint8List? image;
  final String? serverImage;
  const HomePage({super.key, this.image, this.serverImage});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ImageProvider getImageProvider(Uint8List? image, String? serverImage) {
    if (image != null) {
      return MemoryImage(image);
    } else if (serverImage != null) {
      return NetworkImage(
        "${dotenv.env['BASE_URL']}/storage/$serverImage",
      );

    } else {
      return const AssetImage('assets/images/f1.png');
    }
  }
  List<Map<String, String>> imageList = [
    {"id": "1", "image_path": 'assets/images/slider1.jpg'},
    {"id": "2", "image_path": 'assets/images/slider2.jpg'},
    {"id": "3", "image_path": 'assets/images/slider3.jpg'},
    {"id": "4", "image_path": 'assets/images/slider4.jpg'},
  ];

  final cs.CarouselController carouselController = cs.CarouselController();
  int currentIndex = 0;
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  List<Choices> ch = const <Choices>[
    Choices(name: 'វីឌីអូបង្រៀន', image: AssetImage('assets/images/teaching.png')),
    Choices(name: 'ទីតាំងជួសជុល', image: AssetImage('assets/images/repair.png')),
    Choices(name: 'ទំនិញ', image: AssetImage('assets/images/product.png')),
    Choices(
        name: 'ការលក់', image: AssetImage('assets/images/sell_motor.png')),
  ];
  List<Choices> chs = const <Choices>[
    Choices(name: 'Original', image: AssetImage('assets/images/box.png')),
    Choices(name: 'Copy', image: AssetImage('assets/images/box.png')),
    Choices(name: 'General', image: AssetImage('assets/images/box.png')),
    Choices(name: 'Rpairing', image: AssetImage('assets/images/box.png')),
  ];

  List<String> text2 = [
    'ការជួសជុល',
    'លក់ទំនិញ',
    'គ្រឿងបន្លាស់',
    'ការបង្រៀន',
  ];

  Future<int> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getString('id') ?? '0';
    //  print('Stored User ID: $storedId');
    return int.tryParse(storedId) ?? 0;
  }



  @override
  void initState() {
    fetchUserInfo();
    super.initState();

    _widgetOptions = <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                cs.CarouselSlider(
                  items: imageList.map((item) {
                    return Builder(builder: (BuildContext context) {
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Opacity(
                                opacity: 0.9,
                                child: Image.asset(
                                  item['image_path']!,
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.08,
                            left: MediaQuery.of(context).size.height * 0.1,
                            child: SizedBox(
                            width: 250.0,
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                fontSize: 30.0,
                                fontFamily: 'Bobbers',
                              ),
                              child: AnimatedTextKit(
                                animatedTexts: [
                                 TyperAnimatedText(
                                  'Cammotor ជាទំនុកចិត្តរបស់លោកអ្នក',
                                  textStyle: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 1
                                      ..color =  Colors.white,
                                  ),
                                  speed: const Duration(milliseconds: 100),
                                  textAlign: TextAlign.center
                                ),
                                ],

                                onTap: () {
                                  // print("Tap Event");
                                },
                              ),
                            ),
                          )
                          )
                        ],
                      );
                    });
                  }).toList(),
                  carouselController: carouselController,
                  options: cs.CarouselOptions(
                    scrollPhysics: const BouncingScrollPhysics(),
                    autoPlay: true,
                    aspectRatio: 2,
                    viewportFraction: 1,
                    
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
         Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              child: Center(
                child: GridView.count(
                  childAspectRatio: 12 / 8,
                  crossAxisSpacing: 2,
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  children: List.generate(ch.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        if (index == 0) {
                          // Change to the appropriate screen or action
                        } else if (index == 1) {
                          // Change to the appropriate screen or action (e.g., HomePageChat())
                        } else if (index == 2) {
                          Future<void>.delayed(Duration.zero, () {
                            // ignore: use_build_context_synchronously
                            displayBottomSheet(context);
                          });
                        } else if (index == 3) {
                          // Handle index 3 action
                        }
                      },
                      child: Stack(
                        children: [
                          SelectCard(
                            key: ValueKey(index),
                            ch: ch[index],
                          ),
                          // if (index == 3)
                          //   Positioned(
                          //     top: 5,
                          //     right: 40,
                          //     child: Image.asset("assets/images/sale.png"),
                          //   ),
                          if (index == 0)
                            Positioned(
                              top: 5,
                              right: 20,
                              child: Image.asset('assets/images/warning.png',width: 40,),
                            ),
                          if (index == 1)
                            Positioned(
                              top: 5,
                              right: 20,
                              child: Image.asset('assets/images/warning.png',width: 40,),
                            ),
                          if (index == 3)
                            Positioned(
                              top: 5,
                              right: 20,
                              child: Image.asset('assets/images/warning.png',width: 40,),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),

        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Profit Promotion & Gift',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 105, 114, 106),
                ),
              ),
              Image.asset('assets/images/promotion.png',width: double.infinity),
            ],
          ),
        ],
      ),
      
    FutureBuilder<int>(
      future: _getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == 0) {
          return const Center(child: Text('សូមចូលទៅកាន់គេហទំព័រទំនិញនិងត្រឡប់មកម្តងទៀត'));
        } else {
          final userId = snapshot.data!;
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: getOrderByUser(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('មិនមានបញ្ជាទិញ'));
              } else {
                final orders = snapshot.data!;
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return OrderCard(order: orders[index]);
                  },
                );
              }
            },
          );
        }
      },
    ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/maintanent.png",width: 200,),
          const Text("កំពុងអភិវឌ្ឃន៍",style: TextStyle(fontSize: 32),),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/maintanent.png",width: 200,),
          const Text("កំពុងអភិវឌ្ឃន៍",style: TextStyle(fontSize: 32),),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/maintanent.png",width: 200,),
          const Text("កំពុងអភិវឌ្ឃន៍",style: TextStyle(fontSize: 32),),
        ],
      ),
    ];
  }

  void _onTabItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
   Future<void> fetchUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('token');

    if (authToken != null) {
      try {
        final response = await http.get(
          Uri.parse('${dotenv.env['BASE_URL']}/auth/user/check'),
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);

          setState(() {
            _serverImage = responseData['test']['profile'] ?? '';
          });

          await prefs.setString('id', responseData['test']['id'].toString());
        }
      } catch (e) {
        // Handle error
      }
    }
  }
  Uint8List? _image;
  String? _serverImage;

 @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageProvider;
    if (_image != null) {
      imageProvider = MemoryImage(_image!);
    } else if (_serverImage != null && _serverImage!.isNotEmpty) {
      imageProvider = NetworkImage("${dotenv.env['BASE_URL']}/storage/$_serverImage");
    } else {
      imageProvider = const AssetImage("assets/images/f1.png");
    }
    // ignore: deprecated_member_use
    return WillPopScope(
        onWillPop: () async {
          final value = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Alert'),
                  content: const Text('Do you want to Exit?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('No')),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        SystemNavigator.pop();
                      },
                      child: const Text('Exit'),
                    )
                  ],
                );
              });
          if (value != null) {
            return Future.value(value);
          }
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 217, 217, 217),
            title: Image.asset(
              "assets/images/logo3.png",
              width: 140,
            ),
            centerTitle: false,
            automaticallyImplyLeading: false,
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfileInfoScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: imageProvider,
                  ),
                ),
              )
            ],
          ),
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: const Color.fromARGB(255, 35, 31, 32),
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 36,
                ),
                label: "ទំព័រដើម",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_box, size: 32),
                label: "ការកម្មង់",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.production_quantity_limits, size: 32),
                label: 'ទំនិញ',
                
              ),
              
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_active_outlined, size: 36),
                label: "ដំណឹង",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_outlined, size: 36),
                label: "ម៉ឺនុយ",
              ),
            ],
            onTap: _onTabItem,
          ),
        ));
  }

  Future<void> displayBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Container(
            color: const Color.fromARGB(255, 66, 53, 53),
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: const Color.fromARGB(255, 66, 53, 53),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: const FetchData(),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
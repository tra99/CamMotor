import 'dart:convert';
import 'package:cammotor_new_version/src/screen/order_history/order_page.dart';
import 'package:cammotor_new_version/src/screen/repair/repairscreen.dart';
import 'package:cammotor_new_version/src/screen/sale/sale_screen.dart';
import 'package:cammotor_new_version/src/screen/teach/teachscreenm.dart';
import 'package:cammotor_new_version/src/test/test_screen.dart';
import 'package:http/http.dart' as http;
import 'package:cammotor_new_version/src/screen/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/card/card_custom.dart';
import '../providers/bottom_sheet.dart';
import '../services/store_basket.dart';
import 'order_history/order_list.dart';
import 'package:carousel_slider/carousel_controller.dart' as custom;

class HomePage extends StatefulWidget {
  final Uint8List? image;
  final String? serverImage;
  const HomePage({super.key, this.image, this.serverImage});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ImageProvider<Object> imageProvider;
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

  // final custom.CarouselController carouselController = custom.CarouselController();
  int currentIndex = 0;
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  List<Choices> ch = const <Choices>[
    Choices(
        name: 'វីឌីអូបង្រៀន', image: AssetImage('assets/images/teaching.png')),
    Choices(
        name: 'ទីតាំងជួសជុល', image: AssetImage('assets/images/location.png')),
    Choices(name: 'ទំនិញ', image: AssetImage('assets/images/product.png')),
    Choices(name: 'ការលក់', image: AssetImage('assets/images/buy_sale.png')),
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
    final userId = int.tryParse(storedId) ?? 0;
    print('UserID: $userId');
    return int.tryParse(storedId) ?? 0;
  }

  Future<void> _launchTelegram() async {
    final Uri telegramUri = Uri.parse('https://t.me/cammoto_part'); 

    if (await canLaunchUrl(telegramUri)) {
      await launchUrl(telegramUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $telegramUri';
    }
  }

  Future<void> _launchPhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri.parse('tel:$phoneNumber');

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  @override
  void initState() {
    super.initState();
    imageProvider = getImageProvider(widget.image, widget.serverImage);
    fetchUserInfo();

    _widgetOptions = <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
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
                  // carouselController: carouselController,
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
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 8,left: 8,top: 20),
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
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>const TeachScreen()));
                          } else if (index == 1) {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const RepairScreen()));
                          } else if (index == 2) {
                            // Future<void>.delayed(Duration.zero, () {
                            //   // ignore: use_build_context_synchronously
                            //   displayBottomSheet(context);
                            // });
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const TestProductScreen()));
                          } else if (index == 3) {
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>const SaleScreen()));
                          }
                        },
                        child: SelectCard(
                          key: ValueKey(index),
                          ch: ch[index],
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
              // Image.asset('assets/images/promotion.png',
              //     width: double.infinity),
              Padding(
                padding: const EdgeInsets.only(left: 10,right: 10,),
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey
                  ),
                ),
              )
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
            return const Center(
                child: Text('សូមចូលទៅកាន់គេហទំព័រទំនិញនិងត្រឡប់មកម្តងទៀត'));
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
                  return const OrderPage();
                  // ListView.builder(
                  //   itemCount: orders.length,
                  //   itemBuilder: (context, index) {
                  //     return OrderCard(order: orders[index]);
                  //   },
                  // );
                }
              },
            );
          }
        },
      ),
      Column(
        children: [
          Container(
            width: double.infinity,
            height: 50,
            color: const Color.fromARGB(255, 36, 87, 197),
            child: const Center(
                child: Text(
              'ការទំនាក់ទំនង',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
            )),
          ),
          const SizedBox(height: 20,),
          GestureDetector(
            onTap: _launchTelegram,
            child: SizedBox(
              width: 250,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/TelegramApp.png'),
                      const SizedBox(width: 10,),
                      const Text('012 99 42 44',style: TextStyle(color: Color.fromARGB(255, 0, 137, 249),fontSize: 24,fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          GestureDetector(
            onTap:()=> _launchPhoneCall('012994244'),
            child: SizedBox(
              width: 250,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/phone_contact.png'),
                      const SizedBox(width: 10,),
                      const Text('012 99 42 44',style: TextStyle(color: Color.fromARGB(255, 0, 137, 249),fontSize: 24,fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/maintanent.png",
            width: 200,
          ),
          const Text(
            "កំពុងអភិវឌ្ឃន៍",
            style: TextStyle(fontSize: 32),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/maintanent.png",
            width: 200,
          ),
          const Text(
            "កំពុងអភិវឌ្ឃន៍",
            style: TextStyle(fontSize: 32),
          ),
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
      imageProvider =
          NetworkImage("${dotenv.env['BASE_URL']}/storage/$_serverImage");
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
          backgroundColor: const Color.fromARGB(255, 214, 231, 255),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 0, 137, 249),
            title: Image.asset(
              "assets/images/logo3.png",
              width: 140,
            ),
            centerTitle: false,
            automaticallyImplyLeading: false,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _getUserId();
                      },
                      child: const Icon(
                        Icons.info_rounded,
                        color: Colors.white,
                        size: 46,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ProfileInfoScreen()));
                      },
                      child: CircleAvatar(
                        backgroundImage: imageProvider,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _selectedIndex == 0 ? Colors.blue : Colors.transparent,
                  ),
                  child: Icon(
                    Icons.home,
                    size: 36,
                    color: _selectedIndex == 0 ? Colors.white : Colors.grey,
                  ),
                ),
                label: "ទំព័រដើម",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _selectedIndex == 1 ? Colors.blue : Colors.transparent,
                  ),
                  child: Icon(
                    Icons.check_box,
                    size: 36,
                    color: _selectedIndex == 1 ? Colors.white : Colors.grey,
                  ),
                ),
                label: "ការកម្មង់",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _selectedIndex == 2 ? Colors.blue : Colors.transparent,
                  ),
                  child: Icon(
                    Icons.telegram_rounded,
                    size: 36,
                    color: _selectedIndex == 2 ? Colors.white : Colors.grey,
                  ),
                ),
                label: 'ទំនាក់ទំនង',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _selectedIndex == 3 ? Colors.blue : Colors.transparent,
                  ),
                  child: Icon(
                    Icons.notifications,
                    size: 36,
                    color: _selectedIndex == 3 ? Colors.white : Colors.grey,
                  ),
                ),
                label: "ដំណឹង",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _selectedIndex == 4 ? Colors.blue : Colors.transparent,
                  ),
                  child: Icon(
                    Icons.menu_outlined,
                    size: 36,
                    color: _selectedIndex == 4 ? Colors.white : Colors.grey,
                  ),
                ),
                label: "ម៉ឺនុយ",
              ),
            ],
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          floatingActionButton: _selectedIndex == 2
            ? FloatingActionButton(
                onPressed: _launchTelegram,
                backgroundColor: const Color.fromARGB(255, 0, 137, 249),
                child: const Icon(Icons.telegram_rounded, color: Colors.white,size: 42,),
              )
            : null,
        floatingActionButtonLocation: _selectedIndex == 2
            ? FloatingActionButtonLocation.endFloat
            : null,

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

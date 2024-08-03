import 'package:cammotor_new_version/src/screen/authentication/login.dart';
import 'package:cammotor_new_version/src/screen/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/bottom_sheet.dart';
import '../services/store_basket.dart';
import 'order_history/order_list.dart';

class HomePage extends StatefulWidget {
  final Uint8List? image;
  final String? serverImage;
  const HomePage({Key? key, this.image, this.serverImage}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ImageProvider getImageProvider(Uint8List? image, String? serverImage) {
    if (image != null) {
      return MemoryImage(image);
    } else if (serverImage != null) {
      return NetworkImage(
        "${dotenv.env['BASE_URL']}/storage/$serverImage" ?? "https://icon-library.com/images/no-profile-pic-icon/no-profile-pic-icon-7.jpg",
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

  List<choices> ch = const <choices>[
    choices(name: 'វីឌីអូបង្រៀន', image: AssetImage('assets/images/teaching.png')),
    choices(name: 'ទីតាំងជួសជុល', image: AssetImage('assets/images/repair.png')),
    choices(name: 'ទំនិញ', image: AssetImage('assets/images/product.png')),
    choices(
        name: 'ការលក់', image: AssetImage('assets/images/sell_motor.png')),
  ];
  List<choices> chs = const <choices>[
    choices(name: 'Original', image: AssetImage('assets/images/box.png')),
    choices(name: 'Copy', image: AssetImage('assets/images/box.png')),
    choices(name: 'General', image: AssetImage('assets/images/box.png')),
    choices(name: 'Rpairing', image: AssetImage('assets/images/box.png')),
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
     print('Stored User ID: $storedId');
    return int.tryParse(storedId) ?? 0;
  }

  @override
  void initState() {
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
                                  print("Tap Event");
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
                          if (index == 3)
                            Positioned(
                              top: 5,
                              right: 40,
                              child: Image.asset("assets/images/sale.png"),
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
          return const Center(child: Text('User ID not found'));
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
                return const Center(child: Text('No orders found'));
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
      const Column(
        children: [
          Text("Bonjour"),
          Text("Bonjour"),
        ],
      ),
      const Column(
        children: [
          Text("Bonjour"),
          Text("Bonjour"),
        ],
      ),
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 2, color: Colors.yellow)),
                child: ClipOval(
                  child: Image.asset('assets/images/f1.jpg',
                      fit: BoxFit.cover),
                ),
              ),
              const Text(
                'Username',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              Container(
                width: double.infinity,
                height: 60,
                color: const Color.fromARGB(255, 218, 215, 215),
                child: const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'General information',
                          style: TextStyle(
                              color: Color.fromARGB(255, 45, 26, 248),
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 0, 0, 255),
                  child: Icon(
                    Icons.attach_money_outlined,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  'Top up all service',
                  style: TextStyle(
                    fontSize:18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_right,
                ),
              ),
              const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 214, 33, 33),
                  child: Icon(
                    Icons.balance_outlined,
                    color: Colors.white,
                  ),
                ),
                title: Text('Show main balance',style: TextStyle(
                    fontSize:18,
                    fontWeight: FontWeight.w500,
                  ),),
                trailing: Icon(
                  Icons.arrow_right,
                ),
              ),
              const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 33, 214, 73),
                  child: Icon(
                    Icons.money_off_outlined,
                    color: Colors.white,
                  ),
                ),
                title: Text('Credit card',style: TextStyle(
                    fontSize:18,
                    fontWeight: FontWeight.w500,
                  ),),
                trailing: Icon(Icons.arrow_right),
              ),
              const ListTile(
                leading: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 255, 172, 62),
                    child: Icon(
                      Icons.monetization_on_outlined,
                      color: Colors.white,
                    )),
                title: Text('Payment history',style: TextStyle(
                    fontSize:18,
                    fontWeight: FontWeight.w500,
                  ),),
                trailing: Icon(Icons.arrow_right),
              ),
              Container(
                width: double.infinity,
                height: 60,
                color: const Color.fromARGB(255, 218, 215, 215),
                child: const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Personal information',
                          style: TextStyle(
                              color: Color.fromARGB(255, 45, 26, 248),
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 0, 0, 255),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                title: Text('Change personal detail',style: TextStyle(
                    fontSize:18,
                    fontWeight: FontWeight.w500,
                  ),),
                trailing: Icon(
                  Icons.arrow_right,
                ),
              ),
              const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 255, 172, 62),
                  child: Icon(
                    Icons.key_outlined,
                    color: Colors.white,
                  ),
                ),
                title: Text('Change password',style: TextStyle(
                    fontSize:18,
                    fontWeight: FontWeight.w500,
                  ),),
                trailing: Icon(
                  Icons.arrow_right,
                ),
              ),
              const ListTile(
                leading: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 214, 33, 33),
                    child: Icon(
                      Icons.phone_outlined,
                      color: Colors.white,
                    )),
                title: Text('Contact us',style: TextStyle(
                    fontSize:18,
                    fontWeight: FontWeight.w500,
                  ),),
                trailing: Icon(Icons.arrow_right),
              ),
              Container(
                width: double.infinity,
                height: 60,
                color: const Color.fromARGB(255, 218, 215, 215),
                child: const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Regional',
                          style: TextStyle(
                              color: Color.fromARGB(255, 45, 26, 248),
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 125, 40, 235),
                  child: Icon(
                    Icons.language_outlined,
                    color: Colors.white,
                  ),
                ),
                title: Text('Languages',style: TextStyle(
                    fontSize:18,
                    fontWeight: FontWeight.w500,
                  ),),
                trailing: Icon(Icons.arrow_right),
              ),
               ListTile(
                onTap: () async{
                  await _logout(context);
                },
                leading: const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 255, 172, 62),
                    child: Icon(
                      Icons.logout_outlined,
                      color: Colors.white,
                    )),
                title: const Text('Logout',style: TextStyle(
                    fontSize:18,
                    fontWeight: FontWeight.w500,
                  ),),
                trailing: const Icon(Icons.arrow_right),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  void _onTabItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Container(
                    width: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3.0),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: getImageProvider(widget.image, widget.serverImage),
                          fit: BoxFit.cover,
                      ),
                    ),
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

// for card grid 4 items in home screen
class choices {
  const choices({required this.name, required this.image});
  final String name;
  final ImageProvider image;
}

class SelectCard extends StatelessWidget {
  const SelectCard({Key? key, required this.ch}) : super(key: key);
  final choices ch;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: ch.image, width: 80),
            Text(
              ch.name,
              style: const TextStyle(
                color: Color.fromARGB(255, 105, 114, 106),
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Future<void> _logout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token != null) {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}/auth/logout'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove('token');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        print('Failed to logout from the server: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during logout request: $error');
    }
  }
}




class choice {
  const choice({required this.name, required this.image});
  final String name;
  final ImageProvider image;
}

class SelectCardPopup extends StatelessWidget {
  const SelectCardPopup({Key? key, required this.chs}) : super(key: key);
  final choices chs;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Card(
        color: Colors.grey.shade300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                chs.name,
                style: const TextStyle(
                  color: Color.fromARGB(255, 105, 114, 106),
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        top: -20,
        right: -20,
        child: Image(
          image: chs.image,
          width: 100,
        ),
      )
    ]);
  }
  
}


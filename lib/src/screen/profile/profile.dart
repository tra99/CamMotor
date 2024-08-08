import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../authentication/login.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  _ProfileInfoScreenState createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  String? name = '';
  String? email = '';
  String? profile = '';
  int? userId;
  int? id;
  Uint8List? _image;
  String? _serverImage;
  int? main_balance;
  int? type_userID;

  late TextEditingController _controller1;
  late TextEditingController _controller2;
  late TextEditingController _controller3;
  late TextEditingController _controller4;
  late TextEditingController _controller5;
  late TextEditingController _controller6;
  late TextEditingController _controller7;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _controller3 = TextEditingController();
    _controller4 = TextEditingController();
    _controller5 = TextEditingController();
    _controller6 = TextEditingController();
    _controller7 = TextEditingController();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _controller6.dispose();
    _controller7.dispose();
    super.dispose();
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
          name = responseData['test']['name'] ?? '';
          email = responseData['test']['email'] ?? '';
          profile = responseData['test']['profile'] ?? '';
          userId = responseData['test']['id'];
          id = responseData['test']['id'];
          main_balance = int.tryParse(responseData['test']['main_balance'].toString()) ?? 0;
          type_userID = int.tryParse(responseData['test']['type_userID'].toString()) ?? 0;

          _controller1.text = responseData['test']['name'] ?? '';
          _controller2.text = responseData['test']['email'] ?? '';
          _controller3.text = responseData['test']['telephone'] ?? '';
          _controller4.text = responseData['test']['dateOfBirth'] ?? '';
          _controller5.text = responseData['test']['type_userID']?.toString() ?? '';
          _controller7.text = responseData['test']['main_balance']?.toString() ?? '';

          _serverImage = responseData['test']['profile'] ?? '';
        });

        await prefs.setString('id', responseData['test']['id'].toString());

        // print(responseData);
      } else if (response.statusCode == 401) {
        // print('Unauthorized. Redirecting to login.');
      } else {
        // print('Failed to fetch user info: ${response.statusCode}');
      }
    } catch (e) {
      // print('Exception caught: $e');
    }
  } else {
    // print('Authentication token not found');
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
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          // print('Failed to logout from the server: ${response.statusCode}');
        }
      } catch (error) {
        // print('Error during logout request: $error');
      }
    }
  }

  Future<void> updateProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('token');

    if (authToken != null) {
      final int? fetchedUserId = id;

      if (fetchedUserId != null && fetchedUserId == id) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${dotenv.env['BASE_URL']}/auth/user/update'),
        );
        request.headers['Authorization'] = 'Bearer $authToken';

        if (_image != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'profile',
            _image!,
            filename: 'profile.png',
          ));
        }

        request.fields['id'] = id.toString();
        request.fields['name'] = _controller1.text;
        request.fields['email'] = _controller2.text;
        request.fields['telephone'] = _controller3.text;
        request.fields['main_balance'] = main_balance.toString();

        if (type_userID != null && type_userID! > 0) {
          request.fields['type_userID'] = type_userID.toString();
        }

        request.fields['dateOfBirth'] = _controller4.text;

        // Log the request data
        // print('Request URL: ${request.url}');
        // print('Request Headers: ${request.headers}');
        // print('Request Fields: ${request.fields}');
        if (_image != null) {
          // print('Image is being uploaded');
        } else {
          // print('No image to upload');
        }

        try {
          final response = await request.send();

          if (response.statusCode == 200) {
            print('Profile updated successfully');
            final responseBody = await response.stream.bytesToString();
            print('Response body: $responseBody');

            name = _controller1.text;
            email = _controller2.text;

            String? telephone = _controller3.text;
            String? dateOfBirth = _controller4.text;
            main_balance = int.parse(_controller7.text); 
            if (_image != null) {
              profile = 'profile.png'; 
            }

            await prefs.setString('name', name ?? '');
            await prefs.setString('email', email ?? '');
            await prefs.setString('telephone', telephone);
            await prefs.setInt('main_balance', main_balance ?? 0); 
            await prefs.setString('dateOfBirth', dateOfBirth);
            if (_image != null) {
              await prefs.setString('profile', 'profile.png');
            }

            // print('Updated user data: {id: $id, name: $name, email: $email, telephone: $telephone, main_balance: $main_balance, dateOfBirth: $dateOfBirth, profile: $profile}');
          } else {
            // print('Failed to update profile. Status code: ${response.statusCode}');
            // final responseBody = await response.stream.bytesToString();
            // print('Response body: $responseBody');
          }
        } catch (error) {
          // print('Error updating profile: $error');
        }
      } else {
        // print('Mismatch in user IDs or null ID');
      }
    } else {
      // print('Authentication token not found');
    }
  }

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: const Text(
          'ប្រវត្តិរូបរបស់អ្នកប្រើប្រាស់',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              updateProfileInfo();
            },
            child:  const Text("កែប្រែ",style: TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.w700),),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),

              Stack(
                children: [
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: imageProvider,
                  ),

                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: () {
                        _selectImage(context);
                      },
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),               
                ],
              ),
              
              const SizedBox(
                height: 25,
              ),
              CustomCard(
                labelText: 'ឈ្មោះអ្នកប្រើប្រាស់',
                initialText: '$name',
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Divider(),
              ),
              CustomCard(
                labelText: 'អ៊ីម៉ែល',
                initialText: '$email',
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Divider(),
              ),
              CustomCard(
                labelText: 'លេខទូរស័ព្ទ',
                initialText: '$name',
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Divider(),
              ),
              CustomCard(
                labelText: 'ថ្ងៃខែឆ្នាំកំណើត',
                initialText: '$name',
              ),
              const SizedBox(height: 100,),
              SizedBox(
                width: 200,
                height: 60,
                child: TextButton(
                  autofocus: true,
                  onPressed: () async {
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 80, 70, 72),
                    disabledForegroundColor: Colors.grey.withOpacity(0.38),
                    shadowColor: Colors.grey,
                    side: const BorderSide(color: Colors.white, width: 2),
                    shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    textStyle: const TextStyle(
                      color: Colors.green,
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_outlined, size: 24),
                      Text("ចាកចេញ"),
                    ],
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Upload Profile Image'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  final bytes = await pickedFile.readAsBytes();
                  setState(() {
                    _image = bytes;
                  });
                }
              },
              child: const Text('Take a Photo'),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  final bytes = await pickedFile.readAsBytes();
                  setState(() {
                    _image = bytes;
                  });
                }
              },
              child: const Text('Choose from Gallery'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}

class CustomCard extends StatelessWidget {
  final String initialText;
  final String labelText;
  final IconData? icon;
  final IconData? clearIcon;
  final VoidCallback? onClear;
  const CustomCard({super.key,required this.initialText,required this.labelText, this.icon, this.clearIcon, this.onClear});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(labelText,style: const TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 16),),
          Row(
            children: [
              Text(initialText,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
              Icon(icon)
            ],
          )
        ],
      ),
    );
  }
}
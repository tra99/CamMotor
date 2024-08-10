import 'dart:convert';
import 'dart:typed_data';
import 'package:cammotor_new_version/src/screen/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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
  int? userId;
  Uint8List? _image;
  String? _serverImage;
  int? mainBalance;
  int? typeUserId;
  DateTime? dob;

  late TextEditingController _controllerName;
  late TextEditingController _controllerEmail;
  late TextEditingController _controllerPhone;
  late TextEditingController _controllerDob;
  late TextEditingController _controllerUserType;
  late TextEditingController _controllerBalance;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    _controllerName = TextEditingController();
    _controllerEmail = TextEditingController();
    _controllerPhone = TextEditingController();
    _controllerDob = TextEditingController();
    _controllerUserType = TextEditingController();
    _controllerBalance = TextEditingController();
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerEmail.dispose();
    _controllerPhone.dispose();
    _controllerDob.dispose();
    _controllerUserType.dispose();
    _controllerBalance.dispose();
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
            userId = responseData['test']['id'];
            dob = DateTime.tryParse(responseData['test']['dateOfbirth'] ?? '');
            mainBalance = int.tryParse(responseData['test']['main_balance'].toString()) ?? 0;
            typeUserId = int.tryParse(responseData['test']['type_userID'].toString()) ?? 0;

            _controllerName.text = name!;
            _controllerEmail.text = email!;
            _controllerPhone.text = responseData['test']['telephone'] ?? '';
            _controllerDob.text = responseData['test']['dateOfbirth'] ?? '';
            _controllerUserType.text = responseData['test']['type_userID']?.toString() ?? '';
            _controllerBalance.text = responseData['test']['main_balance']?.toString() ?? '';

            _serverImage = responseData['test']['profile'] ?? '';
          });

          await prefs.setString('id', responseData['test']['id'].toString());
        }
      } catch (e) {
        // Handle error
      }
    }
  }

    String formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> updateProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('token');

    if (authToken != null) {
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

      request.fields['id'] = userId.toString();
      request.fields['name'] = _controllerName.text;
      request.fields['email'] = _controllerEmail.text;
      request.fields['telephone'] = _controllerPhone.text;
      request.fields['main_balance'] = mainBalance.toString();
      request.fields['type_userID'] = typeUserId.toString();
      request.fields['dateOfbirth'] = _controllerDob.text;

      try {
        final response = await request.send();

        if (response.statusCode == 200) {
          setState(() {
            name = _controllerName.text;
            email = _controllerEmail.text;
            mainBalance = int.parse(_controllerBalance.text);
            if (_image != null) {
              _serverImage = 'profile.png';
            }
          });

          await prefs.setString('name', name ?? '');
          await prefs.setString('email', email ?? '');
          await prefs.setInt('main_balance', mainBalance ?? 0);
          await prefs.setString('dateOfbirth', _controllerDob.text);
          if (_image != null) {
            await prefs.setString('profile', 'profile.png');
          }
        }
      } catch (error) {
        // Handle error
      }
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
      backgroundColor: Colors.white,
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
            // onPressed: updateProfileInfo,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const EditProfileScreen()));
            },
            child: const Text(
              "កែប្រែ",
              style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return fetchUserInfo();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: const Color.fromARGB(255, 26, 21, 19)),
                    borderRadius: BorderRadius.circular(64),
                  ),
                  child: CircleAvatar(
                    radius: 64,
                    backgroundImage: imageProvider,
                  ),
                ),
                const SizedBox(height: 25),
                CustomCard(labelText: 'ឈ្មោះអ្នកប្រើប្រាស់', initialText: '$name'),
                const Padding(padding: EdgeInsets.all(10.0), child: Divider()),
                CustomCard(labelText: 'អ៊ីម៉ែល', initialText: '$email'),
                const Padding(padding: EdgeInsets.all(10.0), child: Divider()),
                CustomCard(labelText: 'ទឹកប្រាក់តុល្យភាព', initialText: '$mainBalance'),
                const Padding(padding: EdgeInsets.all(10.0), child: Divider()),
                CustomCard(
                  labelText: 'ថ្ងៃខែឆ្នាំកំណើត',
                  initialText: dob != null ? formatDate(dob) : 'មិនមានទិន្នន័យ',
                ),
        
                const SizedBox(height: 60),
                SizedBox(
                  width: 200,
                  height: 60,
                  child: TextButton(
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.remove('token');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
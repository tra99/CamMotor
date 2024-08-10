import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:cammotor_new_version/src/screen/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

ImageProvider getImageProvider(Uint8List? image, String? serverImage) {
  if (image != null) {
    return MemoryImage(image);
  } else if (serverImage != null) {
    return NetworkImage("${dotenv.env['BASE_URL']}/storage/$serverImage");
  } else {
    return const AssetImage('assets/images/f1.png');
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? name = '';
  String? email = '';
  int? id;
  Uint8List? _image;
  String? _serverImage;
  int? main_balance;
  int? type_userID;
  String? dob;
  int? telephone;

  void _clearImage() {
    setState(() {
      _image = null;
    });
  }

  Future<void> _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('កែប្រែរូបភាព', style: TextStyle(fontWeight: FontWeight.w800)),
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
              child: const Text('ថតរូបភាព', style: TextStyle(fontWeight: FontWeight.w500, decoration: TextDecoration.underline)),
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
              child: const Text('បញ្ជីរូបភាព', style: TextStyle(fontWeight: FontWeight.w500, decoration: TextDecoration.underline)),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('token');

    if (authToken != null) {
      final response = await http.get(
        Uri.parse('${dotenv.env['BASE_URL']}/auth/user/check'),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          name = responseData['test']['name'];
          email = responseData['test']['email'];
          id = responseData['test']['id'];
          _serverImage = responseData['test']['profile'];
          main_balance = responseData['test']['main_balance'];
          type_userID = responseData['test']['type_userID'];
          dob = responseData['test']['dateOfbirth'] ?? 'no data';
          telephone = responseData['test']['phone_number'] != null
              ? int.tryParse(responseData['test']['phone_number'].toString())
              : null;
        });
        print(responseData);
      } else {
        print('Failed to fetch user info');
      }
    } else {
      print('Authentication token not found');
    }
  }

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

  DateTime? _selectedDate;

  void _clearDate() {
    setState(() {
      _selectedDate = null;
      _controller4.clear();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dob = '${picked.year}-${picked.month}-${picked.day}';
        _controller4.text = dob!;
      });
    }
  }

  void _showSuccessDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("អ្នកបានកែប្រែជោគជ័យ!!!", style: TextStyle(color: Colors.green)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileInfoScreen(),
                ),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.green, // Background color
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0), // Padding for the button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
              ),
            ),
            child: const Text(
              "ជោគជ័យ",
              style: TextStyle(
                color: Colors.white, // Text color
                fontSize: 16.0, // Text size
                fontWeight: FontWeight.bold, // Text weight
              ),
            ),
          ),
        ],
      );
    },
  );
}

  Future<File> _downloadFile(String url, String filename) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');

    return file.writeAsBytes(bytes);
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
      // If a new image is selected, add it to the request
      request.files.add(http.MultipartFile.fromBytes(
        'profile',
        _image!,
        filename: 'profile.jpg',
      ));
    } else if (_serverImage != null && _serverImage!.isNotEmpty) {
      // If no new image is selected, fetch the existing one from the server
      final file = await _downloadFile('${dotenv.env['BASE_URL']}/storage/$_serverImage', 'profile.jpg');
      request.files.add(await http.MultipartFile.fromPath(
        'profile',
        file.path,
      ));
    }

    // Add fields from the text controllers
    request.fields['id'] = id.toString();
    request.fields['name'] = _controller1.text.isNotEmpty ? _controller1.text : name!;
    request.fields['email'] = _controller2.text.isNotEmpty ? _controller2.text : email!;
    request.fields['phone_number'] = _controller3.text.isNotEmpty ? _controller3.text : telephone?.toString() ?? '';
    request.fields['main_balance'] = _controller7.text.isNotEmpty ? _controller7.text : main_balance.toString();
    request.fields['type_userID'] = type_userID?.toString() ?? '';
    request.fields['dateOfbirth'] = _controller4.text.isNotEmpty ? _controller4.text : dob!;

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(responseBody);
        if (responseData.containsKey('message')) {
          String backendMessage = responseData['message'];
          _showSuccessDialog();
          print('Server message: $backendMessage');
        } else {
          print('Profile updated successfully');
        }
      } else {
        final Map<String, dynamic> responseData = jsonDecode(responseBody);
        if (responseData.containsKey('error')) {
          String errorMessage = responseData['error']['profile'] ?? 'Unknown error';
          print('Error: $errorMessage');
        } else {
          print('Failed to update profile. Status code: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error updating profile: $error');
    }
  } else {
    print('Authentication token not found');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("កែប្រែប្រវត្តិ"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                CircleAvatar(
                  radius: 64,
                  backgroundImage: getImageProvider(_image, _serverImage),
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
            const SizedBox(height: 16),
            CustomCard(
              onTap: () {},
              controller: _controller1,
              initialText: "ឈ្មោះអ្នកប្រើប្រាស់: $name",
            ),
            const SizedBox(height: 16),
            CustomCard(
              onTap: () {},
              controller: _controller2,
              initialText: 'អ៊ីម៉ែល: $email',
            ),
            const SizedBox(height: 16),
            CustomCard(
              onTap: () {},
              controller: _controller3,
              initialText: 'លេខទូរស័ព្ទ: ${telephone ?? 'សូមបញ្ចូលលេខទូរស័ព្ទ'}',
            ),
            const SizedBox(height: 16),
            CustomCard(
              onTap: () {},
              controller: _controller7,
              initialText: "ទឹកប្រាក់តុល្យភាព: $main_balance",
            ),
            const SizedBox(height: 16),
            CustomCard(
              onTap: () => _selectDate(context),
              onClear: _clearDate,
              controller: _controller4,
              initialText: dob ?? 'សូមបញ្ចូលថ្ងៃខែឆ្នាំកំណើត',
              icon: Icons.calendar_today,
              readOnly: true,
              hasClearButton: true,
            ),
            const SizedBox(height: 80),
            SizedBox(
              width: 200,
              height: 60,
              child: TextButton(
                onPressed: () {
                  updateProfileInfo();
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
                    Icon(Icons.save_alt_rounded, size: 24),
                    SizedBox(width: 10,),
                    Text("រក្សាទុក"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final String? labelText;
  final IconData? icon;
  final bool? readOnly;
  final bool? hasClearButton;
  final String? initialText;
  final String? hintText;

  const CustomCard({
    super.key,
    required this.controller,
    this.onTap,
    this.onClear,
    this.labelText,
    this.icon,
    this.readOnly,
    this.hasClearButton,
    this.initialText,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.07,
      child: TextFormField(
        controller: controller,
        readOnly: readOnly ?? false,
        onTap: onTap,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          prefixText: labelText,
          prefixIcon: icon != null ? Icon(icon) : null,
          suffixIcon: hasClearButton == true
              ? IconButton(
                  onPressed: onClear,
                  icon: const Icon(Icons.clear),
                )
              : null,
          hintText: initialText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

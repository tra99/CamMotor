import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../components/pick_image.dart';

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

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

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

  void _clearImage() {
    setState(() {
      _image = null;
    });
  }

  Future<void> _selectImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final bytes = await pickedImage.readAsBytes();
      setState(() {
        _image = bytes;
      });

      // Upload the selected image to the server
      await updateProfileInfo();
    }
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
        _controller4.text = '${picked.year}-${picked.month}-${picked.day}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              updateProfileInfo();
            },
            child: const Text("Save"),
          )
        ],
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
                if (_image != null || _serverImage != null)
                  Positioned(
                    bottom: -10,
                    right: 80,
                    child: IconButton(
                      onPressed: () {
                        _clearImage();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            CustomCard(
              onTap: () {},
              controller: _controller1,
              initialText: "Username: $name",
            ),
            const SizedBox(height: 16),
            CustomCard(
              onTap: () {},
              controller: _controller2,
              initialText: 'Email: $email',
            ),
            const SizedBox(height: 16),
            CustomCard(
              onTap: () {},
              controller: _controller3,
              labelText: 'Telephone',
            ),
            const SizedBox(height: 16),
            CustomCard(
              onTap: () {},
              controller: _controller7,
              initialText: "Balance: $main_balance",
            ),
            const SizedBox(height: 16),
            CustomCard(
              onTap: () {},
              controller: _controller5,
              initialText: 'Type UserID: $type_userID',
            ),
            const SizedBox(height: 16),
            CustomCard(
              onTap: () => _selectDate(context),
              onClear: _clearDate,
              controller: _controller4,
              labelText: 'Date of Birth',
              icon: Icons.calendar_today,
              readOnly: true,
              hasClearButton: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('token');

    if (authToken != null) {
      final int? fetchedUserId = id; // Assign the fetched user ID

      if (fetchedUserId != null && fetchedUserId == id) {
        // Create a FormData object and append the image file to it
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${dotenv.env['BASE_URL']}/auth/user/update'),
        );
        request.headers['Authorization'] = 'Bearer $authToken';

        // Append the image if available
        if (_image != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'profile',
            _image!,
            filename: 'profile.jpg',
          ));
        }
        request.fields['id'] = id.toString();
        request.fields['name'] = _controller1.text;
        request.fields['email'] = _controller2.text;
        request.fields['telephone'] = _controller3.text;
        request.fields['main_balance'] = _controller4.toString();
        request.fields['type_userID'] = _controller5.toString();

        try {
          final response = await request.send();
          if (response.statusCode == 200) {
            print('Profile updated successfully');
          } else {
            print('Failed to update profile. Status code: ${response.statusCode}');
          }
        } catch (error) {
          print('Error updating profile: $error');
        }
      } else {
        print('Mismatch in user IDs or null ID');
      }
    } else {
      print('Authentication token not found');
    }
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

  const CustomCard({
    Key? key,
    required this.controller,
    this.onTap,
    this.onClear,
    this.labelText,
    this.icon,
    this.readOnly,
    this.hasClearButton,
    this.initialText, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (initialText != null) {
      controller.text = initialText!; 
    }

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
          hintText: labelText,
          prefixIcon: icon != null ? Icon(icon) : null,
          suffixIcon: hasClearButton == true
              ? IconButton(
                  onPressed: onClear,
                  icon: const Icon(Icons.clear),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

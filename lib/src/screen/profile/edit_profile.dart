import 'dart:convert';
import 'dart:io';
import 'package:cammotor_new_version/src/screen/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

ImageProvider getImageProvider(Uint8List? image, File? imageFile, String? serverImage) {
  if (image != null) {
    return MemoryImage(image);
  } else if (imageFile != null) {
    return FileImage(imageFile);
  } else if (serverImage != null && serverImage.isNotEmpty) {
    final url = "${dotenv.env['BASE_URL']}/storage/$serverImage";
    try {
      return NetworkImage(url);
    } catch (e) {
      // print("Failed to load image from $url: $e");
      return const AssetImage('assets/images/f1.png');
    }
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
  int? mainBalance;
  int? typeUserID;
  String? dob;
  int? telephone;
  File? _imageFile;
  bool _isLoading = false; // Loading state variable

  void clearImage() {
    setState(() {
      _image = null;
      _imageFile = null;
    });
  }

  Future<void> _selectImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _image = null;  // Ensure the memory image is cleared when selecting a new image.
      });
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
          name = responseData['test']['name'] ?? '';
          email = responseData['test']['email'] ?? '';
          id = responseData['test']['id'] ?? 0;

          if (responseData['test']['profile'] is List) {
            _serverImage = responseData['test']['profile'].isNotEmpty ? responseData['test']['profile'][0] : null;
          } else {
            _serverImage = responseData['test']['profile']?.toString().isNotEmpty == true
                ? responseData['test']['profile']
                : null;
          }

          mainBalance = responseData['test']['main_balance'] ?? 0;
          typeUserID = responseData['test']['type_userID'] ?? 0;
          dob = responseData['test']['dateOfbirth'] ?? 'no data';
          telephone = responseData['test']['phone_number'] != null
              ? int.tryParse(responseData['test']['phone_number'].toString())
              : null;
        });
      } else {
        // Handle failed fetch
      }
    } else {
      // Handle missing authentication token
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
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                "ជោគជ័យ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showImageRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("កែប្រែបរាជ័យ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),),
          content: const Text("សូមបញ្ចូលរូបភាព",style: TextStyle(fontWeight: FontWeight.w600,),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("យល់ព្រម",style: TextStyle(color: Colors.green),),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateProfileInfo() async {
    if (_imageFile == null && _image == null) {
      _showImageRequiredDialog();
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('token');

    if (authToken != null) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${dotenv.env['BASE_URL']}/auth/user/update'),
      );
      request.headers['Authorization'] = 'Bearer $authToken';

      request.fields['id'] = id.toString();
      request.fields['name'] = _controller1.text.isNotEmpty ? _controller1.text : name!;
      request.fields['main_balance'] = _controller7.text.isNotEmpty ? _controller7.text : mainBalance.toString();
      
      // Ensure the phone number starts with '0'
      String phoneNumber = _controller3.text.isNotEmpty
          ? _controller3.text
          : telephone?.toString() ?? '';
      if (!phoneNumber.startsWith('0')) {
        phoneNumber = '0$phoneNumber';
      }
      request.fields['phone_number'] = phoneNumber;
      
      request.fields['dateOfbirth'] = _controller4.text.isNotEmpty ? _controller4.text : dob!;

      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile',
          _imageFile!.path,
        ));
      } else if (_image != null) {
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/default_profile.png').create();
        file.writeAsBytesSync(_image!);
        request.files.add(await http.MultipartFile.fromPath(
          'profile',
          file.path,
        ));
      }

      try {
        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        // Debugging output
        // print('Response status: ${response.statusCode}');
        // print('Response body: $responseBody');

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(responseBody);
          if (responseData.containsKey('message')) {
            _showSuccessDialog();
          }
        } else {
          // Log the error message returned by the server
          final Map<String, dynamic> responseData = jsonDecode(responseBody);
          if (responseData.containsKey('error')) {
            // print('Error: ${responseData['error']}');
          }
        }
      } catch (error) {
        // print('Error updating profile: $error');
      }
    } else {
      // print('Authentication token not found');
    }

    setState(() {
      _isLoading = false; // Hide loading indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                  backgroundImage: getImageProvider(_image, _imageFile, _serverImage),
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
              initialText: 'លេខទូរស័ព្ទ: 0${telephone?.toString().padLeft(9, '0') ?? 'សូមបញ្ចូលលេខទូរស័ព្ទ'}',
            ),
            const SizedBox(height: 16),
            CustomCard(
              onTap: () {},
              controller: _controller7,
              initialText: "ទឹកប្រាក់តុល្យភាព: $mainBalance",
            ),
            const SizedBox(height: 16),
            CustomCard(
              onTap: () => _selectDate(context),
              onClear: _clearDate,
              controller: _controller4,
              initialText: dob ?? 'សូមបញ្ចូលថ្ងៃខែឆ្នាំកំណើត',
              icon: Icons.calendar_today,
              readOnly: true,
            ),
            const SizedBox(height: 80),
            SizedBox(
              width: 200,
              height: 60,
              child: TextButton(
                onPressed: _isLoading ? null : () {
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
                child: _isLoading 
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    ) 
                  : const Row(
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

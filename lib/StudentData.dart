import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'HomeScreen.dart';

class StudentData extends StatefulWidget {
  final String userName;
  const StudentData({required this.userName, Key? key}) : super(key: key);
  @override
  _StudentDataState createState() => _StudentDataState();
}


class _StudentDataState extends State<StudentData> {
  TextEditingController _dobController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _nickNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  String? _selectedGender;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullNameController.text = prefs.getString('fullName') ?? '';
      _nickNameController.text = prefs.getString('nickName') ?? '';
      _dobController.text = prefs.getString('dob') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _selectedGender = prefs.getString('gender');
      final path = prefs.getString('profileImagePath');
      if (path != null && File(path).existsSync()) {
        _profileImage = File(path);
      }
    });
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', _fullNameController.text);
    await prefs.setString('nickName', _nickNameController.text);
    await prefs.setString('dob', _dobController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('gender', _selectedGender ?? '');
    if (_profileImage != null) {
      await prefs.setString('profileImagePath', _profileImage!.path);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Your profile data has been saved!")),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime eighteenYearsAgo = now.subtract(Duration(days: 18 * 365));
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: eighteenYearsAgo,
      firstDate: DateTime(1900),
      lastDate: eighteenYearsAgo,
    );
    if (pickedDate != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _requestPermissions(ImageSource source) async {
    if (source == ImageSource.camera) {
      var status = await Permission.camera.request();
      if (status.isGranted) {
        _pickImage(source);
      } else {
        _showPermissionDialog("Camera");
      }
    } else {
      var status = await Permission.photos.request();
      if (status.isGranted) {
        _pickImage(source);
      } else {
        _showPermissionDialog("Gallery");
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _showPermissionDialog(String permissionType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("$permissionType Permission Denied"),
        content: Text("Please enable $permissionType access in settings."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
            },
            child: Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _requestPermissions(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _requestPermissions(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final hintColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
        title: Text('Your Profile', style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(userName: widget.userName)),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                  ),
                  GestureDetector(
                    onTap: _showImagePickerOptions,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.edit, color: Colors.white, size: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _fullNameController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Full Name',
                  hintStyle: TextStyle(color: hintColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _nickNameController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Nick Name',
                  hintStyle: TextStyle(color: hintColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _dobController,
                readOnly: true,
                onTap: () => _selectDate(context),
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today, color: hintColor),
                  hintText: 'Date of Birth',
                  hintStyle: TextStyle(color: hintColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _emailController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: hintColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                dropdownColor: Theme.of(context).cardColor,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Gender',
                  hintStyle: TextStyle(color: hintColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                items: ['Male', 'Female', 'Other']
                    .map((e) => DropdownMenuItem(child: Text(e), value: e))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF006EE9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: _saveProfileData,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Center(
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.check,
                            color: Color(0xFF006EE9),
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:chemistry_app/HomeScreen.dart';
import 'package:chemistry_app/LoginScreen.dart';
import 'package:chemistry_app/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentRegistration extends StatefulWidget {
  @override
  _StudentRegistrationState createState() => _StudentRegistrationState();
}

class _StudentRegistrationState extends State<StudentRegistration> {
  bool _obscurePassword = true;
  bool _acceptTerms = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mailController = TextEditingController();

  String email = "", password = "", name = "";
  final _formKey = GlobalKey<FormState>();

  Future<void> savePasswordLocally(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_password", password);
  }

  registration() async {
    if (password != "" && nameController.text != "" && mailController.text != "") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        await savePasswordLocally(password);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Registered Successfully", style: TextStyle(fontSize: 20.0)),
        ));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userName', nameController.text); // 🔹 Save name

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(userName: nameController.text)),
        );
      } on FirebaseAuthException catch (e) {
        String message = "Something went wrong";
        if (e.code == 'weak-password') {
          message = "Password provided is too weak";
        } else if (e.code == "email-already-in-use") {
          message = "Account already exists";
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(message, style: TextStyle(fontSize: 18.0)),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/mainicon.png', height: 100),
                  SizedBox(width: 10),
                  Text(
                    'Learn From Home',
                    style: GoogleFonts.jost(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Getting Started.!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
              Text(
                'Create an Account to Continue your learning',
                style: TextStyle(fontSize: 14, color: isDark ? Colors.grey[400] : Colors.grey[700]),
              ),
              SizedBox(height: 20),

              // Name
              TextFormField(
                controller: nameController,
                validator: (value) => value == null || value.isEmpty ? 'Please Enter Name' : null,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Enter Your Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 15),

              // Email
              TextFormField(
                controller: mailController,
                validator: (value) => value == null || value.isEmpty ? 'Please Enter Email' : null,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Enter your Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 15),

              // Password
              TextFormField(
                controller: passwordController,
                validator: (value) => value == null || value.isEmpty ? 'Please Enter Password' : null,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Enter your Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Terms
              Row(
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (value) => setState(() => _acceptTerms = value!),
                  ),
                  Text('Agree to Terms & Conditions', style: TextStyle(color: textColor)),
                ],
              ),
              SizedBox(height: 10),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _acceptTerms ? Color(0xFF006EE9) : Colors.grey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: _acceptTerms
                      ? () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        email = mailController.text;
                        name = nameController.text;
                        password = passwordController.text;
                      });
                      registration();
                    }
                  }
                      : null,
                  child: Text('Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 20),

              Center(child: Text('Or Continue With', style: TextStyle(color: textColor))),
              SizedBox(height: 10),

              // ✅ Google Sign-In Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => AuthMethods().signInWithGoogle(context),
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.asset('assets/images/google.png'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text(
                    'Already have an Account? SIGN IN',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
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

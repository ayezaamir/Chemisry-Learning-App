import 'package:chemistry_app/forget_password.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'HomeScreen.dart';
import 'StudentRegistration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chemistry_app/service/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Login function
  Future<void> userLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? latestPassword = prefs.getString('userPassword');

      if (latestPassword != null && password != latestPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Please use your latest password.", style: TextStyle(fontSize: 16)),
          ),
        );
        return;
      }
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(userName: email)),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else {
        message = 'Login failed. ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(message, style: TextStyle(fontSize: 16)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color;
    final hintColor = isDark ? Colors.grey[400] : Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/mainicon.png', height: 100),
                              SizedBox(width: 10),
                              Text(
                                'Welcome Back!',
                                style: GoogleFonts.jost(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Login to Continue',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                          ),
                          Text(
                            'Enter your credentials to access your account',
                            style: TextStyle(fontSize: 14, color: hintColor),
                          ),
                          SizedBox(height: 20),

                          // Email field
                          TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email, color: hintColor),
                              hintText: 'Enter your Email',
                              hintStyle: TextStyle(color: hintColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            style: TextStyle(color: textColor),
                          ),
                          SizedBox(height: 15),

                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock, color: hintColor),
                              hintText: 'Enter your Password',
                              hintStyle: TextStyle(color: hintColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: hintColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            style: TextStyle(color: textColor),
                          ),

                          SizedBox(height: 10),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ForgotPassword()),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          ),

                          SizedBox(height: 10),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF006EE9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  userLogin();
                                }
                              },
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),
                          Center(child: Text('Or Continue With', style: TextStyle(color: textColor))),
                          SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => AuthMethods().signInWithGoogle(context),
                                child: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Image.asset('assets/images/google.png'),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StudentRegistration(),
                                  ),
                                );
                              },
                              child: Text(
                                'Don\'t have an account? SIGN UP',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
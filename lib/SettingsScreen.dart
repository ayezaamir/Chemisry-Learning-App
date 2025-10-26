import 'package:chemistry_app/HomeScreen.dart';
import 'package:chemistry_app/StudentData.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'NotificationService.dart';
import 'LoginScreen.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  final String userName;

  const SettingsScreen({required this.userName, Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}


class _SettingsScreenState extends State<SettingsScreen> {
  bool _isNotificationEnabled = false;
  String _appVersion = 'Loading...';
  String _appName = 'Chemistry App';

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
    _loadAppInfo();
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNotificationEnabled = prefs.getBool('isNotificationEnabled') ?? false;
    });
  }

  Future<void> _loadAppInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = '${info.version} (Build ${info.buildNumber})';
        _appName = info.appName;
      });
    } catch (e) {
      setState(() {
        _appVersion = 'N/A';
      });
    }
  }

  Future<void> _toggleNotification(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNotificationEnabled = value;
    });
    await prefs.setBool('isNotificationEnabled', value);

    if (value) {
      NotificationService.showNotification(
        "Notifications Enabled",
        "You will now receive performance alerts.",
      );
    }
  }

  Future<void> _showChangePasswordDialog() async {
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Password 🔐'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Current Password'),
                ),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'New Password'),
                ),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text('Change'),
              onPressed: () async {
                final current = currentPasswordController.text.trim();
                final newPass = newPasswordController.text.trim();
                final confirm = confirmPasswordController.text.trim();

                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? savedPassword = prefs.getString('userPassword');

                if (current != savedPassword) {
                  _showSnack("Current password is incorrect", false);
                  return;
                }

                if (newPass != confirm) {
                  _showSnack("New passwords do not match", false);
                  return;
                }

                try {
                  User? user = FirebaseAuth.instance.currentUser;
                  AuthCredential credential = EmailAuthProvider.credential(
                    email: user!.email!,
                    password: current,
                  );
                  await user.reauthenticateWithCredential(credential);
                  await user.updatePassword(newPass);
                  await prefs.setString('userPassword', newPass);

                  Navigator.pop(context);
                  _showSnack("Password changed successfully", true);
                } catch (e) {
                  _showSnack("Failed to change password", false);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnack(String msg, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Settings ⚙️",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeScreen(userName: widget.userName ),
              ),
            );
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SettingsTile(
            icon: Icons.person,
            title: "Profile Settings",
            subtitle: "Update your personal information",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => StudentData(userName: widget.userName)));
            },
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              title: Text("Performance Notifications"),
              subtitle: Text("Get alerts about your progress"),
              secondary: Icon(Icons.notifications_active, color: Colors.blue),
              value: _isNotificationEnabled,
              onChanged: _toggleNotification,
            ),
          ),
          SettingsTile(
            icon: Icons.security,
            title: "Security & Privacy",
            subtitle: "Manage your security settings",
            onTap: _showChangePasswordDialog,
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              title: Text("Dark Theme"),
              subtitle: Text("Switch between Light & Dark mode"),
              secondary: Icon(Icons.dark_mode, color: Colors.blue),
              value: isDark,
              onChanged: (value) => themeProvider.toggleTheme(value),
            ),
          ),
          Divider(),
          SettingsTile(
            icon: Icons.info_outline,
            title: "About App",
            subtitle: "Version $_appVersion",
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: _appName,
                applicationVersion: _appVersion,
                applicationLegalese: '© 2025 Ayeza Amir. All rights reserved.',
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "📚 This app is specially made for students to explore Chemistry in a fun and interactive way!\n\n"
                        "🧪 Features:\n"
                        "• Performance tracking\n"
                        "• AR learning tools\n"
                        "• AI-powered quizzes\n"
                        "• Friendly UI/UX with Dark Mode\n\n"
                        "Made with ❤️ by Ayeza Amir & her team.",
                  ),
                ],
              );
            },
          ),
          AboutListTile(
            icon: Icon(Icons.article, color: Colors.blue),
            applicationName: _appName,
            applicationVersion: _appVersion,
            applicationLegalese: '© 2025 Ayeza Amir. All rights reserved.',
            child: Text("View Licenses"),
          ),
          SettingsTile(
            icon: Icons.logout,
            title: "Logout",
            subtitle: "Sign out of your account",
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Logout"),
                  content: Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(child: Text("Cancel"), onPressed: () => Navigator.pop(context, false)),
                    TextButton(child: Text("Logout"), onPressed: () => Navigator.pop(context, true)),
                  ],
                ),
              );

              if (confirm == true) {
                await FirebaseAuth.instance.signOut();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('userPassword');

                Navigator.of(context).pushAndRemoveUntil(

                  MaterialPageRoute(builder: (context) => LoginScreen(), // ✅ Pass it back
                  ),
                      (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}
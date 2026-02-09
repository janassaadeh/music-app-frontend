import 'package:flutter/material.dart';
import 'package:music_app/pages/auth/landing_page.dart';
import 'package:music_app/pages/auth/login_page.dart';
import 'package:music_app/services/auth_service.dart';
import 'package:music_app/main.dart'; // where BodyPage is

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final auth = AuthenticationService();
    // Optional delay so splash is visible
    await Future.delayed(const Duration(seconds: 2));

    bool isLoggedIn = await auth.isLoggedIn(); 
    // implement this in your auth service
    final authService = AuthenticationService();


    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => isLoggedIn 
            ? const BodyPage() 
            : const LandingPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.music_note, size: 80),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

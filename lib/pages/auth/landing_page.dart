import 'package:flutter/material.dart';
import 'package:music_app/pages/auth/login_page.dart';
import 'package:music_app/pages/auth/register_page.dart';
import 'package:music_app/utils/shorcuts.dart';


class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Background Image Grid
          Image.asset("assets/images/artists_landing.png"),

          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  const Spacer(),
                  const Text(
                    "Millions of\nSongs & Playlists",
                    style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Arabic & International",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const SizedBox(height: 40),
                 
                  
                  // Apple Button
                  _buildButton(
                    onTap: () => push(context, LoginPage()),
                    label: "Login with your account", 
                    color: Colors.white, 
                    textColor: Colors.black
                  ),
                  const SizedBox(height: 30),
                  
                  // Mobile Button
                  _buildButton(
                    onTap: () => push(context, RegisterPage()),
                    label: "Create a new account", 
                    color: Colors.transparent, 
                    textColor: Colors.white,
                    isBordered: true,
                  ),
                  
                 
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({required String label,required VoidCallback onTap, required Color color, required Color textColor, bool isBordered = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          border: isBordered ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            Text(label, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
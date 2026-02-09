import 'package:flutter/material.dart';
import 'package:music_app/main.dart';
import 'package:music_app/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthenticationService _authService = AuthenticationService();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() => _isLoading = true);

    try {
      await _authService.authenticate(email, password);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BodyPage()),
      );
    } catch (e) {
      _showSnackBar('Invalid email or password');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF121212),
      ),
      backgroundColor: const Color(0xFF121212),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 6),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://www.transparenttextures.com/patterns/cubes.png',
                            ),
                            opacity: 0.2,
                          ),
                        ),
                      ),
                      const Icon(Icons.person, size: 60, color: Colors.white),
                    ],
                  ),
                ),
                    
                const SizedBox(height: 50),
                    
                const Text(
                  'Login with your account',
                  style: TextStyle(color: Color(0xFFE2FF00), fontSize: 27),
                ),
                    
                const SizedBox(height: 15),
                    
                const Text(
                  'Start building your music library',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                    
                const SizedBox(height: 30),
                    
                /// Email
                TextFormField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required';
                }
            
                final emailRegex =
                    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            
                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Enter a valid email';
                }
            
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
              ),
            ),
            
                const SizedBox(height: 15),
                    
                /// Password
                TextFormField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
            
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
            
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
              ),
            ),
            
                    
                const SizedBox(height: 25),
                    
                /// Login Button (same UI)
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE2FF00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1.2,
                            ),
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
  @override
void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
  super.dispose();
}

}

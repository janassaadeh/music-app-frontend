import 'package:flutter/material.dart';
import 'package:music_app/main.dart';
import 'package:music_app/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedGender;
  final AuthenticationService _authService = AuthenticationService();
  bool _isLoading = false;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: DateTime(2000),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }
Future<void> _submit() async {
  if (!_formKey.currentState!.validate()) return;

  if (_selectedDate == null) {
    _showSnackBar("Select date of birth");
    return;
  }

  if (_selectedGender == null) {
    _showSnackBar("Select gender");
    return;
  }

  setState(() => _isLoading = true);

  try {
    /// 1️⃣ Register User
    final success = await _authService.register(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      dateOfBirth: _selectedDate!,
      gender: _selectedGender!,
    );

    if (!success) {
      _showSnackBar("Registration failed");
      return;
    }

    /// 2️⃣ Auto Login After Register
    await _authService.authenticate(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    /// 3️⃣ Navigate To Home
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const BodyPage()),
    );

  } catch (e) {
    _showSnackBar("Something went wrong");
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}


  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade600),
      filled: true,
      fillColor: Colors.grey.shade900,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
        
                const Text(
                  'Create a new account',
                  style: TextStyle(color: Color(0xFFE2FF00), fontSize: 27),
                ),
        
                const SizedBox(height: 30),
        
                /// First Name
                TextFormField(
                  controller: _firstNameController,
                  style: const TextStyle(color: Colors.white),
                  validator: (v) =>
                      v!.isEmpty ? "First name required" : null,
                  decoration: _inputDecoration("First Name"),
                ),
        
                const SizedBox(height: 15),
        
                /// Last Name
                TextFormField(
                  controller: _lastNameController,
                  style: const TextStyle(color: Colors.white),
                  validator: (v) =>
                      v!.isEmpty ? "Last name required" : null,
                  decoration: _inputDecoration("Last Name"),
                ),
        
                const SizedBox(height: 15),
        
                /// Email
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email required";
                    }
        
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        
                    if (!emailRegex.hasMatch(value)) {
                      return "Invalid email";
                    }
        
                    return null;
                  },
                  decoration: _inputDecoration("Email"),
                ),
        
                const SizedBox(height: 15),
        
                /// Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password required";
                    }
        
                    if (value.length < 8) {
                      return "Min 8 characters";
                    }
        
                    return null;
                  },
                  decoration: _inputDecoration("Password"),
                ),
        
                const SizedBox(height: 15),
        
                /// Date of Birth
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      _selectedDate == null
                          ? "Date of Birth"
                          : _selectedDate!.toLocal().toString().split(" ")[0],
                      style: TextStyle(
                        color: _selectedDate == null
                            ? Colors.grey
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
        
                const SizedBox(height: 15),
        
                /// Gender Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  dropdownColor: Colors.grey.shade900,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Gender"),
                  items: ["Male", "Female", "Other"]
                      .map((g) => DropdownMenuItem(
                            value: g,
                            child: Text(g),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedGender = value);
                  },
                  validator: (v) =>
                      v == null ? "Select gender" : null,
                ),
        
                const SizedBox(height: 25),
        
                /// Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE2FF00),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                   child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2,
                      )
                    : const Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.black,
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
    );
  }
  @override
void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
  _firstNameController.dispose();
  _lastNameController.dispose();
  super.dispose();
}

}

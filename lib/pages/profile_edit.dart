import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_app/utils/shorcuts.dart';
import 'package:music_app/widgets/custom_rounded_button.dart';
import 'package:music_app/widgets/layout/app_bar.dart';

void main() => runApp(MaterialApp(home: ProfileEditPage()));

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  
  // 1. Added state for Gender selection
  String _selectedGender = "Female"; 

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() => _image = File(pickedFile.path));
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Photo Library'),
              onTap: () { 
                _pickImage(ImageSource.gallery); 
                Navigator.pop(context); 
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () { 
                _pickImage(ImageSource.camera); 
                Navigator.pop(context); 
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    //  appBar: CustomAppBar(
    //     title: "Edit Profile",
    //     onBackTap: () => Navigator.pop(context), // Navigate back
    //   ),
    
      body: SafeArea(
        child: SingleChildScrollView(
        
          // padding: const EdgeInsets.only(left: 16, right: 16, top: 50, bottom: 0),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        
            children: [
        
             Padding(
          padding: const EdgeInsets.only(left: 8.0,right:12,top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
                          onPressed:()=> pop(context),
                        ),
                        Text(
                          "Edit Profile",
                          style: Theme.of(context).textTheme.labelLarge)]),
                
                    CustomRoundedButton(title: "Save", fontSize:13,width: 62, height: 30, color: Colors.purple, textColor: Colors.white, onTap: () {
                      // Handle save logic here
                      
                    })
                  ]),
              ),
                SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(21.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade200,
                          // 2. Added check for file existence
                          backgroundImage: _image != null 
                              ? FileImage(_image!) 
                              : null,
                          child: _image == null 
                              ? Icon(Icons.person, size: 50, color: Colors.grey) 
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _showPicker(context),
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.blue, 
                                shape: BoxShape.circle, 
                                border: Border.all(color: Colors.white, width: 3)
                              ),
                              child: Icon(Icons.camera_alt, color: Colors.white, size: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                
                Text("Full name", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildTextField("Jana")),
                    SizedBox(width: 15),
                    Expanded(child: _buildTextField("Saadeh")),
                  ],
                ),
                SizedBox(height: 20),
                        
                Text("Gender", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                Row(
                  children: [
                    // 3. Updated buttons to react to state
                    Expanded(child: _buildGenderButton("Male")),
                    SizedBox(width: 15),
                    Expanded(child: _buildGenderButton("Female")),
                  ],
                ),
                
                SizedBox(height: 20),
                Text("Date of birth", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                _buildTextField("June 20 2003"),
                        
                SizedBox(height: 20),
                Text("Bio (optional)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                _buildBioField(),
                         
                  ],
                ),
              ),
                 ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodySmall,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }

  // 4. Enhanced Gender Button with interaction
  Widget _buildGenderButton(String label) {
    bool isSelected = _selectedGender == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = label;
        });
      },
      child: Container(
        width: 70,
              height: 35,
        // padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            label, 
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade500, 
              fontWeight: FontWeight.bold,fontSize: 13
            )
          ),
        ),
      ),
    );
  }

  Widget _buildBioField() {
    return TextField(
      maxLines: 3,
      decoration: InputDecoration(
        hintStyle:Theme.of(context).textTheme.bodySmall,
        hintText: "Tell us about yourself...",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }
}
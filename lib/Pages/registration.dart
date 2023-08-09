import 'package:flutter/material.dart';

import 'login.dart';

void main() {
  runApp(MyReg());
}

class MyReg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                'Registration',
                style: TextStyle(
                  fontSize: 32, // Adjust the font size as needed
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
                  _buildTextField('Full Name', Icons.person),
                  SizedBox(height: 16.0),
                  _buildTextField('Email', Icons.email,
                      inputType: TextInputType.emailAddress),
                  SizedBox(height: 16.0),
                  _buildTextField('Phone Number', Icons.phone,
                      inputType: TextInputType.phone),
                  SizedBox(height: 16.0),
                  _buildTextField('Password', Icons.lock, isPassword: true),
                  SizedBox(height: 16.0),
                  _buildTextField('Confirm Password', Icons.lock, isPassword: true),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyLogin()
                          ),
                          );
                      // Add registration logic here
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, IconData iconData,
      {TextInputType? inputType, bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: TextField(
        obscureText: isPassword,
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.all(12.0),
          prefixIcon: Icon(iconData),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

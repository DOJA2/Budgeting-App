import 'package:flutter/material.dart';

import 'login.dart';

void main() {
  runApp(const MyReg());
}

class MyReg extends StatelessWidget {
  const MyReg({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                'Registration',
                style: TextStyle(
                  fontSize: 32, // Adjust the font size as needed
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
                  _buildTextField('Full Name', Icons.person),
                  const SizedBox(height: 16.0),
                  _buildTextField('Email', Icons.email,
                      inputType: TextInputType.emailAddress),
                  const SizedBox(height: 16.0),
                  _buildTextField('Phone Number', Icons.phone,
                      inputType: TextInputType.phone),
                  const SizedBox(height: 16.0),
                  _buildTextField('Password', Icons.lock, isPassword: true),
                  const SizedBox(height: 16.0),
                  _buildTextField('Confirm Password', Icons.lock, isPassword: true),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const MyLogin()
                          ),
                          );
                      // Add registration logic here
                    },
                    child: const Text('Register'),
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
          contentPadding: const EdgeInsets.all(12.0),
          prefixIcon: Icon(iconData),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

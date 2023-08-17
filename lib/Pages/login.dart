import 'package:flutter/material.dart';

import 'home.dart';
import 'registration.dart';

void main() {
  runApp(const MyLogin());
}

class MyLogin extends StatelessWidget {
  const MyLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 32, // Adjust the font size as needed
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              _buildTextField('Phone Number', Icons.phone, inputType: TextInputType.phone),
              const SizedBox(height: 16.0),
              _buildTextField('Password', Icons.lock, isPassword: true),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                  // Add login logic here
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyReg()),
                  );
                },
                child: const Text('Create an account'),
              ),
            ],
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


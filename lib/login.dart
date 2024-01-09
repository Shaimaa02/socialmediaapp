import 'package:flutter/material.dart';
import 'signup.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  final void Function(String) onLogin;

  LoginScreen({required this.onLogin});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<String> loginFunction(String email, String password) async {
    String baseUrl = "https://shaimaa09.000webhostapp.com/logIn.php";

    final response = await http.post(
      Uri.parse(baseUrl),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('Failed to log in. Error: ${response.reasonPhrase}');
      return '';
    }
  }

  void _handleLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    String loggedInUserId = await loginFunction(email, password);

    if (loggedInUserId.isNotEmpty) {
      print('Login successful');
      widget.onLogin(loggedInUserId);
    } else {
      print('Login failed');
    }
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleLogin,
              child: Text('Login'),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: _navigateToSignUp,
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
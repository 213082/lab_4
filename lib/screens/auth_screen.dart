import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  final bool isLogin;

  const AuthScreen({super.key, required this.isLogin});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  Future<void> _authAction() async {
    try {
      if (widget.isLogin) {
        // Log in with email and password
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        _showSuccessDialog("Login Successful", "You have successfully logged in!");
        _navigateToHome();
      } else {
        // Register with email and password
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        _showSuccessDialog("Registration Successful", "You have successfully registered!");
        _navigateToLogin();
      }
    } catch (e) {
      // Handle errors during authentication
      _showErrorDialog("Authentication Error", e.toString());
    }
  }

  void _showSuccessDialog(String title, String message) {
    _scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToHome() {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  void _navigateToLogin() {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  void _navigateToRegister() {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/register');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: widget.isLogin ? const Text("Login") : const Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email Input
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Password Input
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Action Button (Login/Register)
            ElevatedButton(
              onPressed: _authAction,
              child: Text(widget.isLogin ? "Sign In" : "Register"),
            ),
            const SizedBox(height: 16),
            // Switch to the other screen (Login/Registration)
            if (!widget.isLogin)
              ElevatedButton(
                onPressed: _navigateToLogin,
                child: const Text('Already have an account? Login'),
              ),
            if (widget.isLogin)
              ElevatedButton(
                onPressed: _navigateToRegister,
                child: const Text('Create an account'),
              ),
            const SizedBox(height: 16),
            // Back to Main Screen
            TextButton(
              onPressed: _navigateToHome,
              child: const Text('Back to Main Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

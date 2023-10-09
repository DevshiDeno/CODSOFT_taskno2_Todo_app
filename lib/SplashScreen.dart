import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    initialize().then((_) {
      setState(() {
        _initialized = true;
      });
    });
  }

  Future<void> initialize() async {
    // Perform any initialization tasks here

    // Simulate a delay to show the splash screen for a few seconds
    await Future.delayed(Duration(seconds: 3));

    // Navigate to the next screen after the splash screen
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _initialized ? CircularProgressIndicator() : Text('Initializing...'),
      ),
    );
  }
}
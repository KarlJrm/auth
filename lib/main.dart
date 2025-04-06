import 'package:flutter/material.dart';
import 'knockcode.dart';
import 'otppuzzleslider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Authentication Showcase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginShowcase(),
        '/knockcode': (context) => KnockCodeScreen(),
        '/otp': (context) => OTPPuzzleSliderScreen(),
      },
    );
  }
}
class LoginShowcase extends StatelessWidget {
  const LoginShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            //gradinet stuff
            colors: [Color(0xFF8CB0DA),Color(0xFF0078FF), Color(0xFF1A3554)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logos Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/doitlog.png'),
                    ),
                    SizedBox(width: 16),
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/psulogp.png'),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Title
                const Text(
                  'Login Authentication\nShowcase',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  'Showcasing OTP-Based Puzzle Slider & Knock Code Authentication for Secure Login.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),

                // OTP Login Button
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/otp'),
                  style: _buttonStyle(),
                  child: const Text(
                    'OTP-Based One-Time Login',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),

                // Knock Code Login Button
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/knockcode'),
                  style: _buttonStyle(),
                  child: const Text(
                    'Knock Code',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 60),

                // Members
                Text(
                  'Members:\nGarin, Karl Jerom E.\nLaguisma, Jvaln L.\nMallonao, Kristine Joy C.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Refined Button Style
  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners for a modern feel
      ),
      elevation: 5, // Add a subtle shadow to the button
    );
  }
}

  // Refined Button Style

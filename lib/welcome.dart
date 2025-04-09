import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'puzzle_description.dart';
import 'knock_description.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {
  int _secondsLeft = 60;
  late Timer _timer;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
        _redirectToMain();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _redirectToMain() {
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Welcome',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
              ),
              SizedBox(height: 16),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Successfully Logged In!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 26,
                    fontWeight: FontWeight.w100,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
              SizedBox(height: 12),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'You will be logged out in $_secondsLeft seconds.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              SizedBox(height: 40),

              _buildStyledContainer(
                title: 'Slider Captcha Puzzle',
                description: 'A security feature where users solve a puzzle by sliding pieces into the correct order.',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PuzzleDescriptionScreen()),
                  );
                },
                titleColor: Color(0xFF000000),
                descriptionColor: Color(0xFF444444),
              ),
              SizedBox(height: 20),

              _buildStyledContainer(
                title: 'Knock Code',
                description: 'An authentication method where users input a pattern of knocks to authenticate.',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => KnockDescriptionScreen()),
                  );
                },
                titleColor: Color(0xFF000000),
                descriptionColor: Color(0xFF606060),
              ),
              SizedBox(height: 20),

              // GitHub QR Code Section
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "View on GitHub",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF000000),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Scan the QR code below to visit the project's GitHub repository.",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/githubqr.png',
                        height: 160,
                        width: 160,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildStyledButton(
                      "Go to GitHub Repo",
                          () async {
                        const githubUrl = 'https://github.com/KarlJrm/auth'; // Placeholder GitHub URL
                        final Uri uri = Uri.parse(githubUrl); // Convert string to Uri
                        if (await canLaunch(uri.toString())) { // Check if URL can be launched
                          await launch(uri.toString()); // Launch the URL
                        } else {
                          throw 'Could not launch $githubUrl'; // Error handling if URL can't be launched
                        }
                      },
                      backgroundColor: Color(0xFFFFFFFF),
                      textColor: Colors.black,
                      icon: Image.asset('assets/githubicon.png', height: 20, width: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),


              _buildStyledButton(
                "EXIT",
                    () => Navigator.pop(context),
                backgroundColor: Colors.white,
                textColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledContainer({
    required String title,
    required String description,
    required VoidCallback onPressed,
    Color titleColor = const Color(0xFF2622E6),
    Color descriptionColor = const Color(0xFF444444),
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              color: descriptionColor,
            ),
          ),
          SizedBox(height: 16),
          _buildStyledButton(
            "Read More",
            onPressed,
            backgroundColor: Colors.white,
            textColor: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildStyledButton(
      String text,
      VoidCallback onPressed, {
        Color backgroundColor = Colors.white,
        Color textColor = Colors.black,
        Widget? icon, // Added icon parameter
      }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: backgroundColor,
        side: BorderSide(color: Colors.black, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: icon,
          ),
          Text(text, style: TextStyle(color: textColor)),
        ],
      ),
    );
  }
}

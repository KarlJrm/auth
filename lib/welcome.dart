import 'dart:async';
import 'package:flutter/material.dart';
import 'puzzle_description.dart';
import 'knock_description.dart';
import 'main.dart'; // Import the file where the LoginShowcase is defined

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {
  int _secondsLeft = 20; // Starting countdown value
  late Timer _timer; // Timer for countdown
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _startCountdown(); // Start the countdown when the page is built
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    _controller.forward();
  }

  // Function to start the countdown
  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
        _redirectToMain();  // Redirect to the main screen (Login Showcase)
      } else {
        setState(() {
          _secondsLeft--; // Decrease the countdown by 1 every second
        });
      }
    });
  }

  // Redirect user to the main screen
  void _redirectToMain() {
    Navigator.pushReplacementNamed(context, '/'); // This will navigate to the LoginShowcase screen.
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the page is disposed
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), // Set text color to white
        backgroundColor: Color(0xFF2622E6),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Change the color here
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Animated Icon showing successful login
              FadeTransition(
                opacity: _fadeAnimation,
                child: Icon(
                  Icons.check_circle_outline, // Check-circle icon to show success
                  color: Colors.green,
                  size: 50,
                ),
              ),
              SizedBox(height: 12),

              // Animated Welcome Text
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Successfully Logged In!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Animated Countdown Timer Text
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'You will be logged out in $_secondsLeft seconds.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              SizedBox(height: 40),

              // Container 1 (Slider Captcha Puzzle)
              _buildStyledContainer(
                title: 'Slider Captcha Puzzle',
                description:
                'A security feature where users solve a puzzle by sliding pieces into the correct order.',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PuzzleDescriptionScreen(), // Navigate to PuzzleDescriptionScreen
                    ),
                  );
                },
              ),
              SizedBox(height: 20),

              // Container 2 (Knock Code)
              _buildStyledContainer(
                title: 'Knock Code',
                description:
                'An authentication method where users input a pattern of knocks to authenticate.',
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KnockDescriptionScreen(), // Navigate to PuzzleDescriptionScreen
                    ),
                  );
                },
              ),
              SizedBox(height: 20),

              // Exit Button
              _buildStyledButton(
                  "EXIT",
                      () {
                    // Logic to exit or go back to the main screen
                    Navigator.pop(context); // This will pop the current page and go back to the previous screen
                  },
                  backgroundColor: Colors.white, // Set background color to white
                  textColor: Colors.black // Set text color to black
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
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12), // Rounded corners for a soft design
          border: Border.all(
            color: Colors.grey[300]!, // Light border to add subtle structure
            width: 1, // Thin border line
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), // Light shadow for depth
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2), // Slight shadow offset for a clean effect
            ),
          ],
        ),
        padding: EdgeInsets.all(16), // Padding inside the container
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Text
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2622E6),
              ),
            ),
            SizedBox(height: 8),
            // Description Text
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            // Read More Button
            _buildStyledButton(
                "Read More",
                onPressed,
                backgroundColor: Colors.white, // Set background color to white
                textColor: Colors.black // Set text color to black
            ),
          ],
        ),
      ),
    );
  }

  // Button styling function
  Widget _buildStyledButton(
      String text,
      VoidCallback onPressed,
      {Color backgroundColor = Colors.white, Color textColor = Colors.black}
      ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, // Button background color set to white
        side: BorderSide(color: Colors.black, width: 2), // Black border around the button
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Rounded corners
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor), // Set the text color
      ),
    );
  }
}

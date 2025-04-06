import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart';

class KnockDescriptionScreen extends StatefulWidget {
  @override
  _KnockDescriptionScreenState createState() => _KnockDescriptionScreenState();
}

class _KnockDescriptionScreenState extends State<KnockDescriptionScreen> {
  int _secondsLeft = 20;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsLeft == 1) {
        timer.cancel();
        _navigateToMain();
      }
      setState(() {
        _secondsLeft--;
      });
    });
  }

  void _navigateToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginShowcase()),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Knock Code Description",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF2622E6),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Change the color here
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/puzzlesliderimg1.jpg', // Placeholder for knock animation
                height: 150,
              ),
              SizedBox(height: 20),
              Text(
                "What is Knock Code?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2622E6),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                "Knock Code is an authentication method where users tap a custom pattern on a 2x2 grid area. "
                    "It was introduced by LG to allow fast, discreet unlocking without needing to look at the screen.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),

              // Pros and Cons Table-style layout
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pros and Cons",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("✔️ Fast & intuitive"),
                              Text("✔️ Can be discreet"),
                              Text("✔️ Doesn't require looking at screen"),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("❌ Limited pattern options"),
                              Text("❌ Can be guessed if observed"),
                              Text("❌ Not widely supported"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              Text(
                "Returning to the main screen in $_secondsLeft seconds...",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

              _buildStyledButton("Exit", _navigateToMain),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.black, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

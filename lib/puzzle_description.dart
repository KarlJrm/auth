import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart';

class PuzzleDescriptionScreen extends StatefulWidget {
  @override
  _PuzzleDescriptionScreenState createState() => _PuzzleDescriptionScreenState();
}

class _PuzzleDescriptionScreenState extends State<PuzzleDescriptionScreen> {
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
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text(
          "Puzzle Description",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Poppins'),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
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
              Icon(
                Icons.image,
                size: 150,
                color: Color(0xFF2622E6),
              ),
              SizedBox(height: 20),
              Text(
                "What is an OTP Puzzle Captcha Slider?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2622E6),
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                "An OTP Puzzle Captcha Slider is a security feature used to verify human users by solving a simple puzzle. "
                    "Slide the missing puzzle piece into its correct position to proceed.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),

              // Pros and Cons Section using Table Layout
              Text(
                "Pros and Cons",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF2622E6),
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 16),

              Table(
                border: TableBorder.symmetric(inside: BorderSide(color: Colors.grey, width: 0.5)),
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                },
                children: [
                  // Header Row
                  TableRow(
                    children: [
                      _buildTableCell("Pros", isHeader: true),
                      _buildTableCell("Cons", isHeader: true),
                    ],
                  ),
                  // First Row (Pros and Cons)
                  TableRow(
                    children: [
                      _buildTableCell("✔️ Effective against bots"),
                      _buildTableCell("❌ Can be bypassed by advanced bots"),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell("✔️ Simple user interaction"),
                      _buildTableCell("❌ Requires precise interaction"),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell("✔️ Visual and intuitive"),
                      _buildTableCell("❌ May be difficult for some users"),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Countdown Text
              Text(
                "Returning to the main screen in $_secondsLeft seconds...",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

              // Exit Button
              _buildStyledButton("Exit", _navigateToMain),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build each table cell with left alignment
  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isHeader ? 18 : 16,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: Colors.grey[700],
          fontFamily: 'Poppins',
        ),
        textAlign: TextAlign.left,
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
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
      ),
    );
  }
}

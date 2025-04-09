import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slider_captcha/slider_captcha.dart';
import 'welcome.dart';  // Import the WelcomePage

class OTPPuzzleSliderScreen extends StatefulWidget {
  @override
  _OTPPuzzleSliderScreenState createState() => _OTPPuzzleSliderScreenState();
}

class _OTPPuzzleSliderScreenState extends State<OTPPuzzleSliderScreen> {
  bool _isVerified = false;
  bool _isLoading = false;
  String _currentImage = "assets/puzzlesliderimg1.jpg";
  File? _selectedImage;
  late Key _sliderKey;
  final ImagePicker _picker = ImagePicker();
  List<String> _shuffledImages = [];
  int _imageIndex = 0;

  List<String> _imageList = [
    "assets/puzzlesliderimg1.jpg",
    "assets/puzzlesliderimg2.jpg",
    "assets/puzzlesliderimg4.jpg",
    "assets/puzzlesliderimg5.jpg",
    "assets/puzzlesliderimg6.jpg",
    "assets/puzzlesliderimg7.jpg",
    "assets/puzzlesliderimg8.jpg",
    "assets/puzzlesliderimg9.jpg",
    "assets/PUZZ.jpg",
    "assets/p1.jpg",
    "assets/p3.jpg",
    "assets/p4.jpg",
    "assets/p5.jpg",
  ];

  @override
  void initState() {
    super.initState();
    _sliderKey = UniqueKey();
    _shuffleImages();
  }

  void _shuffleImages() {
    _shuffledImages = List.from(_imageList)..shuffle();
    _imageIndex = 0;
  }

  void _refreshPuzzle() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      if (_imageIndex >= _shuffledImages.length) {
        _shuffleImages();
      }

      setState(() {
        _selectedImage = null;
        _currentImage = _shuffledImages[_imageIndex];
        _imageIndex++;
        _isLoading = false;
      });
    });
  }

  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Widget _buildStyledButton(String text, VoidCallback onPressed, {IconData? icon}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.black, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      child: icon == null
          ? Text(text, style: TextStyle(color: Colors.black, fontFamily: 'Poppins'))
          : Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 5),
          Text(text, style: TextStyle(color: Colors.black, fontFamily: 'Poppins')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text(
          "Puzzle Slider Login",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(77),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: EdgeInsets.all(12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: _isLoading ? 0.0 : 1.0,
                    duration: Duration(milliseconds: 300),
                    child: SliderCaptcha(
                      key: _sliderKey,
                      image: _selectedImage != null
                          ? Image.file(_selectedImage!, fit: BoxFit.cover)
                          : Image.asset(_currentImage, fit: BoxFit.cover),
                      titleStyle: TextStyle(
                        fontFamily: 'Poppins', // Poppins font applied here
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      onConfirm: (value) async {
                        setState(() {
                          _isVerified = value;
                        });
                        if (value) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => WelcomePage()),
                          );
                        }
                        return Future.value();
                      },
                    ),
                  ),
                  if (_isLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.white.withAlpha(50),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (!_isVerified)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStyledButton("Select Image", _pickImage),
                      SizedBox(width: 10),
                      _buildStyledButton("Capture Image", _captureImage),
                    ],
                  ),
                  SizedBox(height: 12),
                  _buildStyledButton("Refresh", _refreshPuzzle, icon: Icons.refresh),
                ],
              ),



            if (_isVerified) ...[
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                child: Text("Continue", style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

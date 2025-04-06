import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'welcome.dart';

class KnockCodeScreen extends StatefulWidget {
  @override
  _KnockCodeScreenState createState() => _KnockCodeScreenState();
}

class _KnockCodeScreenState extends State<KnockCodeScreen> {
  final List<int> _inputPattern = [];
  List<int> _userPattern = [];
  bool _isVerifying = false;
  String _message = '';
  int _attemptsLeft = 3;

  Color _numberButtonColor = Colors.white;
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playSound(String sound) async {
    await _audioPlayer.play(AssetSource('sounds/$sound.mp3'));
  }

  void _pickButtonColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick Button Color for 1, 2, 3, 4 Buttons'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _numberButtonColor,
              onColorChanged: (color) {
                setState(() {
                  _numberButtonColor = color;
                });
              },
              showLabel: false,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(child: Text('Cancel'), onPressed: () => Navigator.of(context).pop()),
            TextButton(child: Text('Select'), onPressed: () => Navigator.of(context).pop()),
          ],
        );
      },
    );
  }

  void _onKnock(int knock) {
    setState(() {
      if (_isVerifying) {
        if (_userPattern.length < _inputPattern.length) {
          _userPattern.add(knock);
        }
      } else {
        if (_inputPattern.length < 8) {
          _inputPattern.add(knock);
        }
      }
    });
  }

  void _confirmKnock() {
    setState(() {
      if (!_isVerifying && _inputPattern.length >= 2 && _inputPattern.length <= 8) {
        _message = '✅ Knock Code Recorded. Please repeat the knock code.';
        _isVerifying = true;
        _playSound('ui3');
      } else if (_isVerifying && _userPattern.length == _inputPattern.length) {
        if (_listEquals(_inputPattern, _userPattern)) {
          _playSound('ui1');
          _showConfirmationDialog();
        } else {
          _attemptsLeft--;
          if (_attemptsLeft == 0) {
            _message = '❌ You have reached the maximum number of attempts!';
            _playSound('ui2');
            Future.delayed(Duration(seconds: 1), _resetPattern);
          } else {
            _message = '❌ Incorrect Knock Code. $_attemptsLeft attempt(s) left.';
            _playSound('ui2');
          }
          _userPattern.clear();
        }
      }
    });
  }

  void _backspace() {
    setState(() {
      if (_isVerifying && _userPattern.isNotEmpty) {
        _userPattern.removeLast();
      } else if (!_isVerifying && _inputPattern.isNotEmpty) {
        _inputPattern.removeLast();
      }
    });
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Knock Code', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Your entered Knock Code is: ${_userPattern.join(', ')}. Do you want to proceed?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _userPattern.clear();
                  _message = '⚠ Knock Code verification cancelled. Please try again.';
                });
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                _message = '✅ Knock Code Correct! Logging in...';
                _resetPattern();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _resetPattern() {
    setState(() {
      _inputPattern.clear();
      _userPattern.clear();
      _isVerifying = false;
      _attemptsLeft = 3;
      _message = '';
    });
  }

  bool _listEquals(List<int> list1, List<int> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  Widget _buildStyledButton(String text, VoidCallback onPressed, {IconData? icon, Color? buttonColor}) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
        if (text.isNotEmpty && int.tryParse(text) != null) {
          _playSound('ui$text');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? _numberButtonColor,
        side: BorderSide(color: Colors.black, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      child: icon == null
          ? Text(text, style: TextStyle(color: Colors.black))
          : Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 5),
          Text(text, style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Knock Code Login", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Color(0xFF2622E6),
        centerTitle: true,
        elevation: 4.0,
        shadowColor: Colors.black.withOpacity(0.3),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Enter Your Knock Code:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 8, spreadRadius: 2)],
              ),
              padding: EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(8, (index) {
                  bool isKnocked = (_isVerifying ? _userPattern : _inputPattern).length > index;
                  return Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isKnocked ? Colors.blueAccent : Colors.grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        isKnocked
                            ? (_isVerifying ? _userPattern[index] : _inputPattern[index]).toString()
                            : '',
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: 4,
              itemBuilder: (context, index) => _buildStyledButton(
                (index + 1).toString(),
                    () => _onKnock(index + 1),
              ),
            ),
            // Visibility widget to prevent layout disruption
            Visibility(
              visible: (!_isVerifying && _inputPattern.length >= 2) ||
                  (_isVerifying && _userPattern.length == _inputPattern.length),
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: _buildStyledButton("Confirm Knock Code", _confirmKnock, buttonColor: Colors.lightBlue.shade100),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(fontSize: 16, color: Colors.redAccent, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isVerifying) _buildStyledButton("Reset", _resetPattern, icon: Icons.refresh, buttonColor: Colors.white),
                SizedBox(width: 10),
                _buildStyledButton("", _backspace, icon: Icons.backspace, buttonColor: Colors.white),
              ],
            ),
            SizedBox(height: 20),
            _buildStyledButton("Pick Button Color", _pickButtonColor, buttonColor: Colors.white),
          ],
        ),
      ),
    );
  }
}

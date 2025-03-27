import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ElevatedCard extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const ElevatedCard({super.key, required this.icon, required this.color, required this.label, required this.onTap});

  @override
  State<ElevatedCard> createState() => _ElevatedCardState();
}

class _ElevatedCardState extends State<ElevatedCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return buildElevatedButton(widget.icon);
  }

  Widget buildElevatedButton(IconData icon) {
    final screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;
    final double fontSize = width * 0.05;

    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) {
            setState(() {
              _isPressed = true;
            });
          },
          onTapUp: (_) {
            setState(() {
              _isPressed = false;
            });
            print("${widget.label} Button Pressed");
          },
          onTapCancel: () {
            setState(() {
              _isPressed = false;
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: _isPressed ? width * 0.20 : width * 0.25,
            height: _isPressed ? width * 0.20 : width * 0.25,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(50),
              boxShadow: _isPressed ? [] : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  spreadRadius: 5,
                  blurRadius: 12,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: width * 0.09,
              ),
            ),
          ),
        ),
        SizedBox(height: height * 0.01,),
        Text(
          widget.label,
          style: TextStyle(
            color: Colors.black,
            fontSize: fontSize * 0.75,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

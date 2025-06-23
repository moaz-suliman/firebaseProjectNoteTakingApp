import 'package:flutter/material.dart';

class Custombuttonauth extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  const Custombuttonauth({super.key, this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
            onPressed:onPressed,
            child: Text('$text'),
            color: Colors.orange,
            textColor: Colors.white,
            height: 40,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          );
  }
}

class CustombuttonUpload extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final bool isSelected;
  const CustombuttonUpload({super.key, this.onPressed, required this.text, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
            onPressed:onPressed,
            child: Text('$text'),
            color:isSelected? Colors.green:Colors.orange,
            textColor: Colors.white,
            height: 40,
            minWidth: 200,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          );
  }
}
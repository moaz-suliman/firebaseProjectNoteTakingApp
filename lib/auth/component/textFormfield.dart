import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hinttext;
  final TextEditingController myController;
  final String? Function(String?)? validator;

  const CustomTextForm({super.key, required this.hinttext, required this.myController, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
              validator: validator,
              controller: myController,
              decoration:InputDecoration(
                hintText:hinttext,
                hintStyle: TextStyle(fontSize: 14,color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(vertical:2,horizontal: 20),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            );
  }
} 
import 'package:flutter/material.dart';

class CustomlogoAuth extends StatelessWidget {
  const CustomlogoAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
              child: Container(
                alignment:Alignment.center ,
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(70),
                ),
                child: Icon(Icons.person,color: Colors.orange,size: 70,),
              ),
            );
  }
}
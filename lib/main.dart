import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseproject/auth/login.dart';
import 'package:firebaseproject/auth/signUp.dart';
import 'package:firebaseproject/categories/add.dart';
import 'package:firebaseproject/filter.dart';
import 'package:firebaseproject/homePage.dart';
import 'package:firebaseproject/imagePicker.dart';
import 'package:firebaseproject/note/view.dart';
import 'package:firebaseproject/stream.dart';
import 'package:firebaseproject/testmessaging.dart';
import 'package:flutter/material.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp ();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void initState(){
    FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
    super.initState();
  
    
  }
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[50],
          titleTextStyle: TextStyle(color: Colors.orange,fontSize: 17,fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: Colors.orange),
        ),
      ),
      debugShowCheckedModeBanner: false,
     
     
             
     home: ( FirebaseAuth.instance.currentUser!=null  && 
             FirebaseAuth.instance.currentUser!.emailVerified)?  homePage():Login(),
     
     //Testmessaging(),
     //ImagePickerWidget(),
     //FilterFirestore(),
     
     
     
    
     routes: {
      "SignUp":(context)=>SignUp(),
      "LogIn":(context)=>Login(),
      "homepage":(context)=>homePage(),
      "addcategory":(context)=>AddCategory(),
      "filter":(context)=>FilterFirestore(),
      "stream":(context)=>stream(),
      "imagePicker":(context)=>ImagePickerWidget(),
      "testmessaging":(context)=>Testmessaging(),
    
     },
    );
  }
}

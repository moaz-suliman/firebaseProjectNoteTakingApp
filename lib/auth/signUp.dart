import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproject/auth/component/customButtonauth.dart';
import 'package:firebaseproject/auth/component/customLogo.dart';
import 'package:firebaseproject/auth/component/textFormfield.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController userName = TextEditingController();
  GlobalKey<FormState>  formState =GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(children: [
          Form(
            key: formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 50),
                CustomlogoAuth(),
                Container(height: 20),
                Text(
                  'SignUp',
                  style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                ),
                Container(height: 10),
                Text(
                  "SignUp to continue using the app",
                  style: TextStyle(color: Colors.grey, fontSize: 17),
                ),
                Container(height: 20),
                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(height: 10),
                CustomTextForm(
                  hinttext: 'email',
                  myController: email,
                  validator: (val){
                if(val==""){
                  return "cant to be empty";
                }}
                ),
                Container(height: 10),
                Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(height: 10),
                CustomTextForm(
                  hinttext: 'password',
                  myController: password,
                  validator: (val){
                if(val==""){
                  return "cant to be empty";
                }
                  }
                ),
                Container(height: 10),
                Text(
                  'User Name',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomTextForm(
                  hinttext: 'user name',
                  myController: userName,
                  validator: (val){
                if(val==""){
                  return "cant to be empty";
                }}
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              textAlign: TextAlign.right,
              'Forgot password ?',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Custombuttonauth(
            onPressed: () async {
              if(formState.currentState!.validate()){
                try {
                
                // إنشاء حساب جديد بدلاً من تسجيل الدخول
                final credential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                  email: email.text,
                  password: password.text,
                );
                
                // تحديث اسم المستخدم (اختياري)
                await credential.user?.updateDisplayName(userName.text);

                print('User created successfully: ${credential.user?.email}');
                
                // الانتقال للصفحة الرئيسية
                Navigator.of(context).pushReplacementNamed('homepage');
                
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print('The password provided is too weak.');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('كلمة المرور ضعيفة جداً'))
                  );
                } else if (e.code == 'email-already-in-use') {
                  print('The account already exists for that email.');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('هذا البريد الإلكتروني مستخدم بالفعل'))
                  );
                } else if (e.code == 'invalid-email') {
                  print('The email address is badly formatted.');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('البريد الإلكتروني غير صحيح'))
                  );
                } else {
                  print('Error: ${e.message}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ: ${e.message}'))
                  );
                }
              } catch (e) {
                print('Unexpected error: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('حدث خطأ غير متوقع'))
                );
              }
              }
            },
            text: "SignUp",
          ),
          Container(height: 20),
          Container(height: 20),
          Container(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed('LogIn');
              },
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: 'Have an account ? ',
                  ),
                  TextSpan(
                      text: ' Log in',
                      style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ]),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
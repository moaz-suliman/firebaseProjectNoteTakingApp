import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproject/auth/component/customButtonauth.dart';
import 'package:firebaseproject/auth/component/customLogo.dart';
import 'package:firebaseproject/auth/component/textFormfield.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading=false;


  Future signInWithGoogle() async {
  // Trigger the authenticati   on flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
   await FirebaseAuth.instance.signInWithCredential(credential);
   Navigator.of(context).pushReplacementNamed('homepage');

}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  isLoading==true?  Center(child: CircularProgressIndicator()):
       Container(
        padding: EdgeInsets.all(20),
        child: ListView(children: [
          Form(
            key: formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 50,),
                CustomlogoAuth(),
                Container(height: 20,),
                Text('login', style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),),
                Container(height: 10,),
                Text("login to continue using the app", style: TextStyle(color: Colors.grey, fontSize: 17),),
                Container(height: 20,),
                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(height: 10,),
                CustomTextForm(
                  hinttext: 'email',
                  myController: email,
                  validator: (val) {
                    if (val == "") {
                      return "cant to be empty";
                    }
                    return null;
                  },
                ),
                Container(height: 10,),
                Text(
                  'password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(height: 10,),
                CustomTextForm(
                  hinttext: 'password',
                  myController: password,
                  validator: (val) {
                    if (val == "") {
                      return "cant to be empty";
                    }
                    return null;
                  }
                )
              ],
            ),
          ),
          InkWell(
            onTap: ()async{
              if(email.text==""){
                print('please rewrite email');
              }
              else{
                try{
                  await  FirebaseAuth.instance.sendPasswordResetEmail(email: email.text); 
                }
                catch(e){
                  print(e);
                }                 
              }
            
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                textAlign: TextAlign.right,
                'Forgot password ?',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Custombuttonauth(
            onPressed: () async {
              if (formState.currentState!.validate()) {
                try {
                  isLoading=true;
                  setState(() {
                    
                  });
                  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email.text,
                    password: password.text,
                  );
                  isLoading=false;
                  if (credential.user!.emailVerified) {
                    Navigator.of(context).pushReplacementNamed('homepage');
                  } else {
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();
                  }
                } on FirebaseAuthException catch (e) {
                    isLoading=false;
                    setState(() {
                    
                    });
                  if (e.code == 'user-not-found') {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Error',
                      desc: 'No user found for that email.',
                    ).show();
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided for that user.');
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Error',
                      desc: 'Wrong password provided for that user.',
                    ).show();
                  }
                }
              } else {
                print('not valid');
              }
            },
            text: "logIn",
          ),
          Container(height: 20,),
          MaterialButton(

            onPressed: () {
              isLoading=true;
              setState(() {
                
              });
              signInWithGoogle();
              isLoading=false;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('log in with google   ',),
                Image.asset('images/4.png', width: 20,)
              ],
            ),
            color: const Color.fromARGB(255, 211, 76, 67),
            textColor: Colors.white,
            height: 40,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          Container(height: 20,),
          Container(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('SignUp');
              },
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: 'dont have an account ?',
                  ),
                  TextSpan(
                    text: ' Register',
                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                ]),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

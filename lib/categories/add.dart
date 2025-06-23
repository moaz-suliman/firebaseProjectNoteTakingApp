import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproject/auth/component/customButtonauth.dart';
import 'package:firebaseproject/auth/component/customtextfieldadd.dart';
import 'package:flutter/material.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();   
  CollectionReference categories = FirebaseFirestore.instance.collection('cate');
  bool isLoading =false;

  Future<void> addCategory() async {
    isLoading=true;
    setState(() {
      
    });
    if (formState.currentState!.validate()) {
      try {
        await categories
            .add({"name": name.text ,"id": FirebaseAuth.instance.currentUser!.uid})
            .then((value) => print('category added'))
            .catchError((error) => print('failed to add category: $error'));
            isLoading=false;

        Navigator.of(context).pushNamedAndRemoveUntil('homepage',(route)=>false);
      } catch (error) {
        isLoading=false;
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add category'),
      ),
      body: isLoading==true? Center(child: CircularProgressIndicator()):
       Column(
        children: [
          Form(
            key: formState,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: CustomTextFormAdd(
                    hinttext: "enter name",
                    myController: name,
                    validator: (val) {
                      if (val == "") {
                        return "cant to be empty";
                      }
                      return null; // أضفت return null للتأكيد على صحة الإدخال
                    },
                  ),
                ),
                Custombuttonauth(
                  text: 'add',
                  onPressed: () {
                    addCategory();
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
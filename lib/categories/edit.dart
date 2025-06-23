import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproject/auth/component/customButtonauth.dart';
import 'package:firebaseproject/auth/component/customtextfieldadd.dart';
import 'package:flutter/material.dart';

class EditCategory extends StatefulWidget {
  final String docid;
  final String oldName;
  const EditCategory({super.key, required this.docid, required this.oldName});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();   
  CollectionReference categories = FirebaseFirestore.instance.collection('cate');
  bool isLoading =false;

   editCategory() async {
  
    if (formState.currentState!.validate()) {
      try {
        isLoading=true;
        setState(() {
          
        });
        await categories.doc(widget.docid).update({"name":name.text});

        Navigator.of(context).pushNamedAndRemoveUntil('homepage',(route)=>false);
      } catch (error) {
        isLoading=false;
        print(error);
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    name.text=widget.oldName;
    super.initState();
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
                  text: 'edit',
                  onPressed: () {
                    editCategory();
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
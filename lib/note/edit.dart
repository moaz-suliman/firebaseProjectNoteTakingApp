import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproject/auth/component/customButtonauth.dart';
import 'package:firebaseproject/auth/component/customtextfieldadd.dart';
import 'package:firebaseproject/note/view.dart';
import 'package:flutter/material.dart';

class EditNote extends StatefulWidget {
  final String notedocid;
  final String categorydocid;
  final String value;
  const EditNote({super.key, required this.notedocid, required this.categorydocid, required this.value});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();   
  bool isLoading =false;

  Future<void> EditNote() async {
    CollectionReference collectionNote = FirebaseFirestore.instance.collection('cate')
    .doc(widget.categorydocid).collection('note');

    isLoading=true;
    setState(() {
      
    });
    if (formState.currentState!.validate()) {
      try {
        await collectionNote.doc(widget.notedocid).update({"note":note.text});
            
            isLoading=false;

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>noteView(categoryid: widget.categorydocid))
          );
      } catch (error) {
        isLoading=false;
        print(error);
      }
    }
  }
  @override
  void initState() {
   note.text=widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('edit note'),
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
                    hinttext: "enter your note",
                    myController: note,
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
                    EditNote();
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
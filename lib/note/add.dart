import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebaseproject/auth/component/customButtonauth.dart';
import 'package:firebaseproject/auth/component/customtextfieldadd.dart';
import 'package:firebaseproject/note/view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddNote extends StatefulWidget {
  final String docid;
  const AddNote({super.key, required this.docid});
  

  @override
  State<AddNote> createState() => _AddNoteState();
}
 
class _AddNoteState extends State<AddNote> {
    File? file;
  String? url;

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();   
  bool isLoading =false;

  Future<void> addNote(context) async {
    CollectionReference collectionNote = FirebaseFirestore.instance.collection('cate')
     .doc(widget.docid).collection('note');
   
    isLoading=true;
    setState(() {
      
    });
    if (formState.currentState!.validate()) {
      try {
        isLoading=true;
        setState(() {
          
        });
        DocumentReference response=
          await collectionNote.add({"note":note.text,"url":url??"none"});

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>noteView(categoryid: widget.docid))
          );
      } catch (error) {
        isLoading=false;
        print(error);
      }
    }
  }


  getImage()async{
    final ImagePicker picker =ImagePicker();
    final XFile? imagecamera= await picker.pickImage(source: ImageSource.camera);
    if(imagecamera!=null){
      file=File(imagecamera!.path);

      var imagename=basename(imagecamera!.path);

      var refStorge =FirebaseStorage.instance.ref("images").child(imagename);

      await refStorge.putFile(file!);

      url = await refStorge.getDownloadURL();
    }
    setState(() {
      
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add note'),
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
                CustombuttonUpload(text: 'upload image', isSelected: url != null?true:false,
                onPressed: ()async{
                 await getImage();
                },),
                Custombuttonauth(
                  text: 'add',
                  onPressed: () {
                    addNote(context);
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
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebaseproject/categories/edit.dart';
import 'package:firebaseproject/note/add.dart';
import 'package:firebaseproject/note/edit.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class noteView extends StatefulWidget {
  final String categoryid;
  const noteView({super.key, required this.categoryid});

  @override
  State<noteView> createState() => _noteViewState();
}

class _noteViewState extends State<noteView> {  

  List<QueryDocumentSnapshot> data = [];  
  bool isLoading=true;


  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("cate").doc(widget.categoryid).collection('note').get();
                  
      data.addAll(querySnapshot.docs);
      
      setState(() {});
      isLoading=false;
    } catch (e) {
      // Handle error
      print('Error fetching data: $e');
    }
  }
 
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override  // إضافة @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>AddNote(docid: widget.categoryid,))
            );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
       
        title: Text('view Note'),
        actions: [
          IconButton(
            onPressed: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil('LogIn', (route) => false);
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: isLoading==true? Center(child: CircularProgressIndicator()):
        GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 160,
        ),
        itemCount: data.length,
        itemBuilder: (context, i) {
          return  InkWell(
            onLongPress: () {
               AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.rightSlide,
                title: 'warining',
                desc: 'هل انت متاكد من عملية الحذف',
                btnOkText: 'حذف', 
                btnOkOnPress: () async{
                  await FirebaseFirestore.instance.collection('cate')
                  .doc(widget.categoryid).collection('note').doc(data[i].id).delete();

                  if(data[i]['url'] != "none"){
                    FirebaseStorage.instance.refFromURL(data[i]['url']).delete();
                  }

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>noteView(categoryid: widget.categoryid))
                    );                 
                },
                
                
              ).show();
            },
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>
                EditNote(notedocid: data[i].id, categorydocid: widget.categoryid, value: data[i]['note'])));
            },
            

          
            child: Card(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [                  
                    Text("${data[i]['note']}"),
                    if(data[i]['url'] != "none"  )
                      Image.network(data[i]['url'],height: 80,),
                    
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
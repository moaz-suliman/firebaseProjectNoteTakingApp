import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproject/categories/edit.dart';
import 'package:firebaseproject/note/view.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {  

  List<QueryDocumentSnapshot> data = [];  
  bool isLoading=true;


  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("cate").where(
            'id',isEqualTo: FirebaseAuth.instance.currentUser!.uid
          )
          .get();
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
          Navigator.of(context).pushNamed('addcategory');
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('home page'),
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
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>noteView(categoryid: data[i].id))
                );
            },
            onLongPress:(){
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.rightSlide,
                title: 'error',
                desc: 'اختر ماذا تريد',
                btnCancelText: 'حذف',
                btnOkText: 'تعديل',
                btnCancelOnPress: () async{
                  await FirebaseFirestore.instance.collection('cate').doc(data[i].id).delete();
                  Navigator.of(context).pushReplacementNamed('homepage');
                  
                },
                btnOkOnPress: () async{
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditCategory(docid:data[i].id ,oldName: data[i]['name'],)));
               
                },
                
              ).show();

            },
            child: Card(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Image.asset(
                      'images/folder2.png',
                      height: 100,
                    ),
                    Text("${data[i]['name']}"),
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
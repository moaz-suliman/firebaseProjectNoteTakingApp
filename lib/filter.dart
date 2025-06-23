
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilterFirestore extends StatefulWidget {
  const FilterFirestore({super.key});

  @override
  State<FilterFirestore> createState() => _FilterFirestoreState();
}

class _FilterFirestoreState extends State<FilterFirestore> {
  @override

  List<QueryDocumentSnapshot> data=[];
  intialData()async  {
    CollectionReference users =FirebaseFirestore.instance.collection('users');
    QuerySnapshot userdata =await users.where("Languages", arrayContains:" ").get();
    userdata.docs.forEach((e){
      data.add(e);
    });
    setState(() {
      
    });
  }

void initState(){
  intialData();
  super.initState();
}



  Widget build(BuildContext context) {


    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        CollectionReference users=FirebaseFirestore.instance.collection('users');
        DocumentReference doc1=FirebaseFirestore.instance.collection('users').doc('1');
        DocumentReference doc2=FirebaseFirestore.instance.collection('users').doc('2');
        DocumentReference doc3=FirebaseFirestore.instance.collection('users').doc('3');

        WriteBatch batch =FirebaseFirestore.instance.batch();

        batch.set(doc1, {
          'age':15,
          'username':'moaz'
        });

        batch.set(doc2, {
          'age':16,
          'username':'ali'
        });

        batch.set(doc3, {
          'age':75,
          'username':'kalid'
        });

        batch.commit();

      }
      ),
      appBar: AppBar(
        title: Text('filter'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context,i){
            return InkWell(
              onTap: () {
                DocumentReference documentReference =
                FirebaseFirestore.instance.collection('users').doc(data[i].id);

                FirebaseFirestore.instance.runTransaction((transaction) async{
                  DocumentSnapshot snapshot =await transaction.get(documentReference);   

                  if(snapshot.exists){
                    var snapshotData =snapshot.data();

                    if(snapshotData is Map<String, dynamic>){
                      int money =snapshotData['money']+100;
                      transaction.update(documentReference, {'money':money });
                    }
                  } 
                }).then((value){
                  Navigator.of(context).pushNamedAndRemoveUntil('filter', (route)=>false);
                }
                );

              },
              child: Card(
                child: ListTile(
                  trailing :Text("${data[i]['money']}\$"),
                  subtitle: Text("age : ${data[i]['age']}"),
                  title: Text(
                    data[i]['username'],
                    style: TextStyle(fontSize:30,),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}




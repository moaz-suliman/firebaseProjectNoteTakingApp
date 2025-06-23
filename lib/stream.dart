import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class stream extends StatefulWidget {
  const stream({super.key});

  @override
  State<stream> createState() => _streamState();
}

class _streamState extends State<stream> {
  @override

  List<QueryDocumentSnapshot> data=[];
  final Stream <QuerySnapshot> usersStream=FirebaseFirestore.instance.collection('users').snapshots();
  

void initState(){
  super.initState();
}



  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(
        title: Text('stream'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: usersStream,
          builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
          if(snapshot.hasError){
            return Text('error');
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Text('loading');
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index){
              return InkWell(
                onTap: () {
                   DocumentReference documentReference =
                FirebaseFirestore.instance.collection('users').doc(snapshot.data!.docs[index].id);

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
                  
                }
                );
                },
                child: Card(
                  child: ListTile(
                    trailing :Text("${snapshot.data!.docs[index]['money']}\$"),
                    subtitle: Text("${snapshot.data!.docs[index]['age']}"),
                    title: Text(
                      "${snapshot.data!.docs[index]['username']}",
                      style: TextStyle(fontSize:30,),
                    ),
                  ),
                ),
              );
            }
            
            
            );
          
        },)
      ),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http; // Add this line

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Testmessaging extends StatefulWidget {
  const Testmessaging({super.key});

  @override
  State<Testmessaging> createState() => _TestmessagingState();
}

class _TestmessagingState extends State<Testmessaging> {

  getToken()async{
    String? mytoken=await FirebaseMessaging.instance.getToken();
    print('======================================');
    print(mytoken);
  }


  myRequestPermission()async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

NotificationSettings settings = await messaging.requestPermission(
  alert: true,
  announcement: false,
  badge: true,
  carPlay: false,
  criticalAlert: false,
  provisional: false,
  sound: true,
);

if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  print('User granted permission');
} else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  print('User granted provisional permission');
} else {
  print('User declined or has not accepted permission');
}
  }

  @override
  void initState() {
    getToken();
    myRequestPermission();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('notification'),
      ),
      body: Container(
        child: MaterialButton(onPressed: (){

        },child: Text("send notfication"),),
      ),
    );
  }
}


sendMessage()async{
  var headersList = {
 'Accept': '*/*',
 'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
 'Content-Type': 'application/json',
 'Authorization': 'key=<Server_key>' 
};
var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

var body = {
  "to": "eLO0i0OWSIGKQM-AeZkylu:APA91bHRt_p0O-OQwXLaAeq5L2MwfZSM28KKP2rkgU0bYbETaOMoqCFA2kcdtyWTwUnhR1JWtHzs_dYu8fYuwTnw6xjS345CiNmjZfzhn-vYHZW42YR0XsA",
  "notification": {
    "title": "hi ",
    "body": "moaz"
  }
};

var req = http.Request('POST', url);
req.headers.addAll(headersList);
req.body = json.encode(body);


var res = await req.send();
final resBody = await res.stream.bytesToString();

if (res.statusCode >= 200 && res.statusCode < 300) {
  print(resBody);
}
else {
  print(res.reasonPhrase);
}

}
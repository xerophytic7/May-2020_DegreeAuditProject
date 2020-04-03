import 'package:flutter/material.dart';
import 'package:seniordesign/popup.dart';
import 'package:nice_button/nice_button.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class CreateAdmin extends StatefulWidget {
  @override
  _CreateAdminState createState() => _CreateAdminState();
}



 Future<String> code() async {
    final response = await http.post(
      'https://127.0.0.1:4567/createAdmin',
    );
    if(response.statusCode != null)
    return response.statusCode.toString();
    else
    return "0";
  }


class _CreateAdminState extends State<CreateAdmin> {
  
  String kode = "0";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("post: CreateAdmin"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          NiceButton(
            width: 100,
            elevation: 8.0,
            radius: 52.0,
            text: "Create",
            background: Colors.green,
            onPressed: () async {
              //kode = code().toString();
              showDialog(
                context: context,
                builder: (_) => Popup(message: kode),
              );
            },
            //add a pop up saying advisor may need to overlook new changes
          ),
        ],
      ),
    );
  }
}

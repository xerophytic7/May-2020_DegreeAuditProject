import 'package:flutter/material.dart';
import 'package:seniordesign/popup.dart';
import 'package:nice_button/nice_button.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:seniordesign/globals/globals.dart';

class DelAllUsers extends StatefulWidget {
  @override
  _DelAllUsersState createState() => _DelAllUsersState();
}



 Future<String> code() async {
    final response = await http.delete(
      '${address}//allUsers',
    );

    if(response.statusCode != null){
      Map<String, dynamic> data = json.decode(response.body);
      return data["message"]; 
    }
    
    else
    return "0";
  }


class _DelAllUsersState extends State<DelAllUsers> {
  
  String kode = "0";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("post: DelAllUsers"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          NiceButton(
            width: 200,
            elevation: 8.0,
            radius: 52.0,
            text: "Delete All",
            background: Colors.red,
            onPressed: () async {
              
              kode = await code();

              showDialog(
                context: context,
                builder: (_) => Popup(message: kode),
              );
            },
          ),
        ],
      ),
    );
  }
}

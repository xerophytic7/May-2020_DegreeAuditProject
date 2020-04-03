import 'package:flutter/material.dart';
import 'package:seniordesign/popup.dart';
import 'package:nice_button/nice_button.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class CustomId extends StatefulWidget {
  @override
  _CustomIdState createState() => _CustomIdState();
}



 Future<String> code() async {
    final response = await http.post(
      'http://127.0.0.1:4567/CustomId',
    );
    if(response.statusCode != null)
    return response.statusCode.toString();
    else
    return "0";
  }


class _CustomIdState extends State<CustomId> {
  
  TextEditingController usernameTextCtrl = TextEditingController();
  TextEditingController passwordTextCtrl = TextEditingController();
  TextEditingController fnTextCtrl = TextEditingController();
  TextEditingController lnTextCtrl = TextEditingController();
  TextEditingController idTextCtrl = TextEditingController();

  String kode = "0";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("post '/customid' do"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Username'),
            controller: usernameTextCtrl,
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Password'),
            controller: passwordTextCtrl,
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'First Name'),
            controller: fnTextCtrl,
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Last Name'),
            controller: lnTextCtrl,
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'ID'),
            controller: idTextCtrl,
          ),
          NiceButton(
            width: 100,
            elevation: 8.0,
            radius: 52.0,
            text: "Submit",
            background: Colors.green,
            onPressed: () async {
              kode = code().toString();
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

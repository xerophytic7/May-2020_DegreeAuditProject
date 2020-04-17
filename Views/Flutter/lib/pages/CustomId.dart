import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:seniordesign/popup.dart';
import 'package:nice_button/nice_button.dart';
import 'dart:async';
import 'package:http/http.dart' as http;


import 'package:seniordesign/globals/globals.dart';




  TextEditingController usernameTextCtrl = TextEditingController();
  TextEditingController passwordTextCtrl = TextEditingController();
  TextEditingController fnTextCtrl = TextEditingController();
  TextEditingController lnTextCtrl = TextEditingController();
  TextEditingController idTextCtrl = TextEditingController();


class CustomId extends StatefulWidget {
  @override
  _CustomIdState createState() => _CustomIdState();
}

String token = " ";

 Future<String> code() async {


    //String username,password,fn,ln,id;
    
    final response = await http.post(
      "${address}/customid?username=${usernameTextCtrl.text}&password=${passwordTextCtrl.text}&firstName=${fnTextCtrl.text}&lastName=${lnTextCtrl.text}&id=${idTextCtrl.text}",
      //headers: {HttpHeaders.authorizationHeader: "${token}"}
    );
    
    if(response.statusCode != null){
      Map<String, dynamic> data = json.decode(response.body);
      return data["message"]; 
    }
    
    else
    return "0";
  }


class _CustomIdState extends State<CustomId> {
  


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
               //print("${address}/customid?username=${usernameTextCtrl.text}&password=${passwordTextCtrl.text}&firstname=${fnTextCtrl.text}&lastname=${lnTextCtrl.text}&id=${idTextCtrl.text}");
              kode = await code();
              //bug if in the textfield there is a space after like "22 " then it wont work must clear of spaces after text
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

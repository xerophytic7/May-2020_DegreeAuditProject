import 'package:flutter/material.dart';
import 'package:seniordesign/popup.dart';
import 'package:nice_button/nice_button.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:seniordesign/globals/globals.dart';

class CreateAdmin extends StatefulWidget {
  
  @override
  _CreateAdminState createState() => _CreateAdminState();

}



 Future<int> code() async {
   
    final response = await http.post(
      '${address}/createAdmin',
    );

    var returnme = response.statusCode;
    print(response.statusCode);
    if(response.statusCode != null)
    return returnme;
    else
    return 0;
  }


class _CreateAdminState extends State<CreateAdmin> {
  
  int kode = 0;
  String popUpMsg = "No Pop Up Message";
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
              kode = await code();
    
              if(kode == 422) popUpMsg = "Error 422: Administrator has already been created.";
              if(kode == 200) popUpMsg = "Administrator Successfuly Created";

              showDialog(
                context: context,
                builder: (_) => Popup(message: popUpMsg),
              );
            },
            //add a pop up saying advisor may need to overlook new changes
          ),
        ],
      ),
    );
  }
}

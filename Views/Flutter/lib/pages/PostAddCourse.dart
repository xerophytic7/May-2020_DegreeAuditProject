import 'package:flutter/material.dart';
import 'package:seniordesign/popup.dart';
import 'package:nice_button/nice_button.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:seniordesign/globals/globals.dart';

class PostAddCourse extends StatefulWidget {
  @override
  _PostAddCourseState createState() => _PostAddCourseState();
}



 Future<String> code() async {
    final response = await http.post(
      '${address}//add/Course',
    );
    if(response.statusCode != null)
    return response.statusCode.toString();
    else
    return "0";
  }


class _PostAddCourseState extends State<PostAddCourse> {
  
  TextEditingController courseDeptTextCtrl = TextEditingController();
  TextEditingController courseNumTextCtrl = TextEditingController();
  TextEditingController nameTextCtrl = TextEditingController();
  TextEditingController institutionTextCtrl = TextEditingController();

  String kode = "0";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("post '/add/Course' do"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'courseDept'),
            controller: courseDeptTextCtrl,
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'CourseNum'),
            controller: courseNumTextCtrl,
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Last Name'),
            controller: nameTextCtrl,
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Institution'),
            controller: institutionTextCtrl,
          ),
          NiceButton(
            width: 100,
            elevation: 8.0,
            radius: 52.0,
            text: "Add",
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

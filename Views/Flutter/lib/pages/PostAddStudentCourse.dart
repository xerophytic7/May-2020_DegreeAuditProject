import 'package:flutter/material.dart';
import 'package:seniordesign/popup.dart';
import 'package:nice_button/nice_button.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:seniordesign/globals/globals.dart';

class PostAddStudentCourses extends StatefulWidget {
  @override
  _PostAddStudentCoursesState createState() => _PostAddStudentCoursesState();
}



 Future<String> code() async {
    final response = await http.post(
      '${address}/add/Course',
    );
    if(response.statusCode != null)
    return response.statusCode.toString();
    else
    return "0";
  }


class _PostAddStudentCoursesState extends State<PostAddStudentCourses> {
  
  TextEditingController userIdTextCtrl = TextEditingController();
  TextEditingController courseIDIdTextCtrl = TextEditingController();
  TextEditingController semesterTextCtrl = TextEditingController();
  TextEditingController gradeTextCtrl = TextEditingController();


  String kode = "0";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("  post '/add/StudentCourses' do"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'UserID'),
            controller: userIdTextCtrl,
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Course ID'),
            controller: courseIDIdTextCtrl,
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Semester'),
            controller: semesterTextCtrl,
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Grade'),
            controller: gradeTextCtrl,
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

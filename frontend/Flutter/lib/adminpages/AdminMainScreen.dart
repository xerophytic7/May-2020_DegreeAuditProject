import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:seniordesign/adminpages/AddCourseAdmin.dart';
import 'package:seniordesign/adminpages/viewSpecificStudent.dart';
import 'package:seniordesign/globals/globals.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

final storage = new FlutterSecureStorage();

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }

  // Example
  // Widget build(BuildContext context) {
  //   SizeConfig().init(context);
  //   double deviceWidth = SizeConfig.blockSizeHorizontal;
  //   double deviceHeight = SizeConfig.blockSizeVertical;

}

class AdminMainScreen extends StatefulWidget {
  //AdminMainScreen({Key key, this.title}) : super(key: key);

  //final String title;

  @override
  _AdminMainScreenState createState() => new _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double deviceWidth = SizeConfig.blockSizeHorizontal;
    double deviceHeight = SizeConfig.blockSizeVertical;
    TextEditingController studentIdTextCtrl = TextEditingController();

    return Scaffold(
        backgroundColor: Color(0xff65646a),
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(deviceWidth * 1, deviceHeight * 4,
                  deviceWidth * 1, deviceHeight * 1),
              width: deviceHeight * 100,
              height: deviceHeight * 30,
              decoration: BoxDecoration(color: Color(0xffebebe8), boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    offset: Offset(0.0, 8.0),
                    blurRadius: 8.0)
              ]),
              child: ListView(children: [
                Padding(
                  padding: EdgeInsets.all(0),
                  child: new TextFormField(
                    decoration: new InputDecoration(
                      //labelText: "Enter Username",
                      hintText: "Student's Email",  
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(1),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                    controller: studentIdTextCtrl,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(deviceHeight * 5,
                          deviceHeight * 4, deviceWidth * 1, deviceHeight * 1),
                      child: NiceButton(
                        background: Color(0xffebebe8),
                        text: "Student's \nInfo",
                        textColor: Color(0xffcf4411),
                        fontSize: deviceWidth * 5,
                        width: deviceWidth * 30,
                        elevation: deviceHeight * 1,
                        //icon: Icons.call_made,
                        //iconColor: Color(0xffcf4411),
                        onPressed: () async {
                          print("ABCC");
                          
                          await storage.write(
                              key: "studentId", value: studentIdTextCtrl.text);
                          
                          print("This is the STudentID controller ${studentIdTextCtrl.text}, \n This is what is being stored on the device ${await storage.read(key: "studentId")}");
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SpecificStudent()),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(deviceHeight * 1,
                          deviceHeight * 4, deviceWidth * 4, deviceHeight * 1),
                      child: NiceButton(
                        background: Color(0xffebebe8),
                        text: "Planned\n Courses",
                        textColor: Color(0xffcf4411),
                        fontSize: deviceWidth * 5,
                        width: deviceWidth * 30,
                        elevation: deviceHeight * 1,
                        //icon: Icons.call_made,
                        //iconColor: Color(0xffcf4411),
                        onPressed: () async {
                          String studentId;
                          await storage.write(
                              key: studentId, value: studentIdTextCtrl.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SpecificStudent()),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ]),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(deviceWidth * 1, deviceHeight * 1,
                  deviceWidth * 1, deviceHeight * 1),
              width: deviceHeight * 100,
              height: deviceHeight * 90,
              decoration: BoxDecoration(color: Color(0xffebebe8), boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    offset: Offset(0.0, 8.0),
                    blurRadius: 8.0)
                    
              ]),
            child: ListView(
              children: [ Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(deviceHeight * 5,
                          deviceHeight * 4, deviceWidth * 1, deviceHeight * 1),
                      child: NiceButton(
                        background: Color(0xffebebe8),
                        text: "Add \nCourse",
                        textColor: Color(0xffcf4411),
                        fontSize: deviceWidth * 5,
                        width: deviceWidth * 30,
                        elevation: deviceHeight * 1,
                        //icon: Icons.call_made,
                        //iconColor: Color(0xffcf4411),
                        onPressed: () async {
                          print("ABCC");
                          
                          await storage.write(
                              key: "studentId", value: studentIdTextCtrl.text);
                          
                          print("This is the STudentID controller ${studentIdTextCtrl.text}, \n This is what is being stored on the device ${await storage.read(key: "studentId")}");
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddCourseAdmin()),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(deviceHeight * 1,
                          deviceHeight * 4, deviceWidth * 4, deviceHeight * 1),
                      child: NiceButton(
                        background: Color(0xffebebe8),
                        text: "Planned\n Courses",
                        textColor: Color(0xffcf4411),
                        fontSize: deviceWidth * 5,
                        width: deviceWidth * 30,
                        elevation: deviceHeight * 1,
                        //icon: Icons.call_made,
                        //iconColor: Color(0xffcf4411),
                        onPressed: () async {
                          String studentId;
                          await storage.write(
                              key: studentId, value: studentIdTextCtrl.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SpecificStudent()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(deviceHeight * 5,
                          deviceHeight * 4, deviceWidth * 1, deviceHeight * 1),
                      child: NiceButton(
                        background: Color(0xffebebe8),
                        text: "Student\n Course",
                        textColor: Color(0xffcf4411),
                        fontSize: deviceWidth * 5,
                        width: deviceWidth * 30,
                        elevation: deviceHeight * 1,
                        //icon: Icons.call_made,
                        //iconColor: Color(0xffcf4411),
                        onPressed: () async {
                          print("ABCC");
                          
                          await storage.write(
                              key: "studentId", value: studentIdTextCtrl.text);
                          
                          print("This is the STudentID controller ${studentIdTextCtrl.text}, \n This is what is being stored on the device ${await storage.read(key: "studentId")}");
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SpecificStudent()),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(deviceHeight * 1,
                          deviceHeight * 4, deviceWidth * 4, deviceHeight * 1),
                      child: NiceButton(
                        background: Color(0xffebebe8),
                        text: "Add \nCategory",
                        textColor: Color(0xffcf4411),
                        fontSize: deviceWidth * 5,
                        width: deviceWidth * 30,
                        elevation: deviceHeight * 1,
                        //icon: Icons.call_made,
                        //iconColor: Color(0xffcf4411),
                        onPressed: () async {
                          String studentId;
                          await storage.write(
                              key: studentId, value: studentIdTextCtrl.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SpecificStudent()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(deviceHeight * 5,
                          deviceHeight * 4, deviceWidth * 1, deviceHeight * 1),
                      child: NiceButton(
                        background: Color(0xffebebe8),
                        text: "Assign \n Category",
                        textColor: Color(0xffcf4411),
                        fontSize: deviceWidth * 5,
                        width: deviceWidth * 30,
                        elevation: deviceHeight * 1,
                        //icon: Icons.call_made,
                        //iconColor: Color(0xffcf4411),
                        onPressed: () async {
                          print("ABCC");
                          
                          await storage.write(
                              key: "studentId", value: studentIdTextCtrl.text);
                          
                          print("This is the STudentID controller ${studentIdTextCtrl.text}, \n This is what is being stored on the device ${await storage.read(key: "studentId")}");
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SpecificStudent()),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(deviceHeight * 1,
                          deviceHeight * 4, deviceWidth * 4, deviceHeight * 1),
                      child: NiceButton(
                        background: Color(0xffebebe8),
                        text: "Add\n Prereq",
                        textColor: Color(0xffcf4411),
                        fontSize: deviceWidth * 5,
                        width: deviceWidth * 30,
                        elevation: deviceHeight * 1,
                        //icon: Icons.call_made,
                        //iconColor: Color(0xffcf4411),
                        onPressed: () async {
                          String studentId;
                          await storage.write(
                              key: studentId, value: studentIdTextCtrl.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SpecificStudent()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(deviceHeight * 5,
                          deviceHeight * 4, deviceWidth * 1, deviceHeight * 1),
                      child: NiceButton(
                        background: Color(0xffebebe8),
                        text: "Create\n DegPlan",
                        textColor: Color(0xffcf4411),
                        fontSize: deviceWidth * 5,
                        width: deviceWidth * 30,
                        elevation: deviceHeight * 1,
                        //icon: Icons.call_made,
                        //iconColor: Color(0xffcf4411),
                        onPressed: () async {
                          print("ABCC");
                          
                          await storage.write(
                              key: "studentId", value: studentIdTextCtrl.text);
                          
                          print("This is the STudentID controller ${studentIdTextCtrl.text}, \n This is what is being stored on the device ${await storage.read(key: "studentId")}");
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SpecificStudent()),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(deviceHeight * 1,
                          deviceHeight * 4, deviceWidth * 4, deviceHeight * 1),
                      child: NiceButton(
                        background: Color(0xffebebe8),
                        text: "Planned\n Courses",
                        textColor: Color(0xffcf4411),
                        fontSize: deviceWidth * 5,
                        width: deviceWidth * 30,
                        elevation: deviceHeight * 1,
                        //icon: Icons.call_made,
                        //iconColor: Color(0xffcf4411),
                        onPressed: () async {
                          String studentId;
                          await storage.write(
                              key: studentId, value: studentIdTextCtrl.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SpecificStudent()),
                          );
                        },
                      ),
                    ),
                  ],
                ),]
            )
           )
          ],
        ));
  }
}

////////////////////////////////////////////////////////////////
class Course {
  final int courseID;
  final String courseDept;
  final int courseNum;
  final String name;
  final String institution;
  final String grade;
  final String semester;
  final bool taken;

  Course(this.courseID, this.courseDept, this.courseNum, this.name,
      this.institution, this.grade, this.semester, this.taken);
}


class Student {
  final String firstname;
  final String lastname;
  final String email;
  final String gpa;
  final String catalogyear;
  final String classification;
  final String hours;
  final String advancedhours;
  final String advancedcshours;

  Student(
      this.firstname,
      this.lastname,
      this.email,
      this.gpa,
      this.catalogyear,
      this.classification,
      this.hours,
      this.advancedcshours,
      this.advancedhours);
}

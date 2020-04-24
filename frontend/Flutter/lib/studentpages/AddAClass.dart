import 'dart:convert';
import 'dart:ffi';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:seniordesign/globals/globals.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

final storage = new FlutterSecureStorage();

final double perA = 0.32;

// Future<Void> StudentInfo() async {
//   //String username,password,fn,ln,id;
//   String value = await storage.read(key: "token");
//   print("This is the supposed Token $value");
//   final response = await http.get(
//     "$address/MyInfo",
//     headers: {HttpHeaders.authorizationHeader: "Bearer $value"},
//   );

//   Map<String, dynamic> data = json.decode(response.body);
//   print("return the JSON of info ==> $data");

//   if(data["FirstName"] != "")      firstname       = data["FirstName"];
//   if(data["LastName"] != "")       lastname        = data["LastName"];
//   if(data["Email"] != "")          email           = data["Email"];
//   if(data["GPA"] != "")            gpa             = data["GPA"];
//   if(data["CatalogYear"] != "")    catalogyear     = data["CatalogYear"];
//   if(data["Classification"] != "") classification  = data["Classification"];
//   if(data["Hours"] != "")          hours           = data["Hours"];
//   if(data["AdvancedCSHours"] != "")advancedcshours = data["AdvancedCsHours"];
//   if(data["AdvancedHours"] != "")  advancedhours   = data["AdvancedHours"];

//   return null;

// }

Future<List<dynamic>> CoursesInfo() async {
  //String username,password,fn,ln,id;
  String value = await storage.read(key: "token");
  print("This is the supposed Token $value");
  final response = await http.get(
    "$address/all/Courses",
    headers: {HttpHeaders.authorizationHeader: "Bearer $value"},
  );

  if (response.statusCode != 200) return null;

  List<dynamic> data = json.decode(response.body);
  return data;
}

class AddAClass extends StatefulWidget {
  //AddAClass({Key key, this.title}) : super(key: key);

  //final String title;

  @override
  _AddAClassState createState() => new _AddAClassState();
}

class _AddAClassState extends State<AddAClass> {

  Future<List<Course>> _getCourses() async {
    String value = await storage.read(key: "token");

    var response = await http.get(
      "$address/all/Courses",
      headers: {HttpHeaders.authorizationHeader: "Bearer $value"},
    );

    var data = json.decode(response.body);

    List<Course> courses = [];

    for (var i in data) {
      Course course = Course(i["CourseID"], i["CourseDept"], i["CourseNum"], i["Name"], i["Institution"]);
      courses.add(course);
      
    }
    print("This is the number of courses => ${courses.length}");
    return courses;

  }

  int statusCode = 0;

  @override
  Widget build(BuildContext context) {
    //StudentInfo();
    // Future<Map<String, dynamic>> data = CoursesInfo();

    // print(data);
    //need a future builder
    return new Scaffold(
      backgroundColor: Color(0xff65646a),
      body: Container(
        child:
          FutureBuilder(
            future: _getCourses(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return new Scaffold(
                  backgroundColor: Color(0xff65646a),
                  body: new Center(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset("assets/images/image0.png"),
                      ],
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int i) {
                    return ListTile(
                      title: Text(snapshot.data[i].name),                     
                    );
                  },
                );
              }
            },
          )
      ),
    );
  }
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

class Course {
  final int courseID;
  final String courseDept;
  final int courseNum;
  final String name;
  final String institution;

  Course(this.courseID, this.courseDept, this.courseNum, this.name,
      this.institution);
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

Future<List<Course>> _getCourses() async {
  String value = await storage.read(key: "token");

  //A will have the entire courses
  var responseA = await http.get(
    "$address/all/Courses",
    headers: {HttpHeaders.authorizationHeader: "Bearer $value"},
  );
  if (responseA.statusCode != 200) return null;
  //B will have the taken Courses by the student
  var responseB = await http.get(
    "$address/myCourses",
    headers: {HttpHeaders.authorizationHeader: "Bearer $value"},
  );
  if (responseB.statusCode != 200) return null;

  var dataA = json.decode(responseA.body);
  var dataB = json.decode(responseB.body);

  List<Course> allCourses = [];
  List<int> courseIDtoSkip = [];

  for (var i in dataB) {
    Course myCourse = Course(i["CourseID"], i["CourseDept"], i["CourseNum"],
        i["Name"], i["Institution"], i["Grade"], i["Semester"], true);

    allCourses.add(myCourse);
    courseIDtoSkip.add(i["CourseID"]);
  }

  //Adds the rest of the courses except the it doesnt add the ones you have taken.
  bool flag = true;
  for (var i in dataA) {
    for (var j in courseIDtoSkip) {
      if (j == i["CourseID"]) {
        flag = false;
      }
    }
    if (flag) {
      Course course = Course(i["CourseID"], i["CourseDept"], i["CourseNum"],
          i["Name"], i["Institution"], "null", "null", false);
      allCourses.add(course);
    }
    flag = true;
  }

  return allCourses;
}

class Student {
  final String firstname;
  final String lastname;
  final String email;
  final double gpa;
  final String catalogyear;
  final String classification;
  final int hours;
  final int advancedhours;
  final int advancedcshours;

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

Future<Student> _getUser() async {
  String studentId;
  studentId = await storage.read(key: "studentId");
  print("This is the _getUser link $address/UserInfo?Email=?$studentId");
  var response = await http.get("$address/userInfo?Email=$studentId", headers: {
    HttpHeaders.authorizationHeader:
        "Bearer ${await storage.read(key: "token")}"
  });

  if (response.statusCode != 200) return null;

  var data = json.decode(response.body);

  print("return the JSON of info ==> $data");

  String classification = "null";
  if (data["Hours"] < 90) classification = "Junior";
  if (data["Hours"] < 60) classification = "Sophmore";
  if (data["Hours"] < 30) classification = "Freshman";
  if (data["Hours"] > 90) classification = "Senior";

  Student student = Student(
      data["FirstName"],
      data["LastName"],
      data["Email"],
      data["GPA"],
      data["CatalogYear"],
      data["Classification"],
      data["Hours"],
      data["AdvancedCsHours"],
      data["AdvancedHours"]);

  return student;
}

class SpecificStudent extends StatefulWidget {
  //SpecificStudent({Key key, this.title}) : super(key: key);

  //final String title;

  @override
  _SpecificStudentState createState() => new _SpecificStudentState();
}

class _SpecificStudentState extends State<SpecificStudent> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double deviceWidth = SizeConfig.blockSizeHorizontal;
    double deviceHeight = SizeConfig.blockSizeVertical;
    return Column(children: [
      Container(
        //The First container for STUDENT INFORMATION!
        decoration: BoxDecoration(color: Color(0xff65646a)),
        child: FutureBuilder(
          future: _getUser(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              print("snapshot is null :O");
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
              print("snapshot is not null");
              return Container(
                width: deviceWidth * 100,
                height: deviceHeight * 40,
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(deviceWidth * 1,
                          deviceHeight * 4, deviceWidth * 1, deviceHeight * 1),
                      //color: Color(0xffebebe8),
                      width: deviceWidth * 98,
                      height: deviceHeight * 35,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xffebebe8), Color(0xffebebe8)]),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: (Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    color: Color(0xffcf4411),
                                    fontWeight: FontWeight.bold,
                                    height: deviceHeight * 0.2,
                                    fontSize: deviceHeight * 2.28),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Student Name: ',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.5)),
                                  ),
                                  TextSpan(
                                    text:
                                        '${snapshot.data.firstname} ${snapshot.data.lastname}\n',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(1.0)),
                                  ),
                                  TextSpan(
                                    text: 'GPA: ',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.5)),
                                  ),
                                  TextSpan(
                                    text: '${snapshot.data.gpa}\n',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(1.0)),
                                  ),
                                  TextSpan(
                                    text: '\nCatalog Year: ',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.5)),
                                  ),
                                  TextSpan(
                                    text: '${snapshot.data.catalogyear}\n',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(1.0)),
                                  ),
                                  TextSpan(
                                    text: 'Classification: ',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.5)),
                                  ),
                                  TextSpan(
                                    text: '${snapshot.data.classification}\n',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(1.0)),
                                  ),
                                  TextSpan(
                                    text: '\nTotal Hours:               ',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.5)),
                                  ),
                                  TextSpan(
                                    text: '${snapshot.data.hours}\n',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(1.0)),
                                  ),
                                  TextSpan(
                                    text: 'Advanced Hours:      ',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.5)),
                                  ),
                                  TextSpan(
                                    text: '${snapshot.data.advancedhours}\n',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(1.0)),
                                  ),
                                  TextSpan(
                                    text: 'Advanced cs Hours  ',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.5)),
                                  ),
                                  TextSpan(
                                    text: '${snapshot.data.advancedcshours}\n',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(1.0)),
                                  ),
                                ],
                              ),
                            ),

                            ///Here
                          ])),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    ]);
  }
}

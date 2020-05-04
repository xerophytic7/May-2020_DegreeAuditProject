import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nice_button/NiceButton.dart';
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
Future<List<int>>  _neverNull() async{
   List<int> list = [];
   list.add(0);
  return list;

}
class Course {
  final int courseID;
  final String courseDept;
  final int courseNum;
  final String name;
  final String institution;
  final String grade;
  final String semester;
  //final bool taken;

  Course(this.courseID, this.courseDept, this.courseNum, this.name,
      this.institution, this.grade, this.semester);
}

Future<List<Course>> _getStudentCourses() async {
  var response = await http.get("$address/MyAndAllCourses", headers: {
    HttpHeaders.authorizationHeader:
        "Bearer ${await storage.read(key: "token")}"
  });

  if (response.statusCode != 200) return null;

  var data = json.decode(response.body);

  List<Course> courses = [];

  for (var i in data) {
    if (i["Grade"] != "n") {
      Course course = Course(i["CourseID"], i["CourseDept"], i["CourseNum"],
          i["Name"], i["Intstitution"], i["Grade"], i["Semester"]);

      courses.add(course);
    }
  }

  return courses;
}

////////////////////////////////////////////////////***************************************************PLANNED COURSES */
class PlannedCourse {
  final int courseID;
  final String courseDept;
  final int courseNum;
  final String name;

  PlannedCourse(this.courseID, this.courseDept, this.courseNum, this.name);
}

Future<List<PlannedCourse>> _getPlannedCourses() async {
  var response = await http.get("$address/myPlannedCoursesW/oSemester",
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${await storage.read(key: "token")}"
      });

  if (response.statusCode != 200) return null;

  var data = json.decode(response.body);

  List<PlannedCourse> plannedCourses = [];

  for (var i in data) {
    PlannedCourse plannedCourse = PlannedCourse(
        i["CourseID"], i["CourseDept"], i["CourseNum"], i["Name"]);

    plannedCourses.add(plannedCourse);
  }

  return plannedCourses;
}
////////////////////////////////////////////////////***************************************************STUDENTINFORMATION COURSES */

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
  var response = await http.get("$address/MyInfo", headers: {
    HttpHeaders.authorizationHeader:
        "Bearer ${await storage.read(key: "token")}"
  });

  if (response.statusCode != 200) return null;

  var data = json.decode(response.body);

  print("return the JSON of info ==> $data");

  String classification = "null";

  if (data["Hours"] != null) {
    if (data["Hours"] < 90) classification = "Junior";
    if (data["Hours"] < 60) classification = "Sophmore";
    if (data["Hours"] < 30) classification = "Freshman";
    if (data["Hours"] > 90) classification = "Senior";
  }
  Student student = Student(
      data["FirstName"],
      data["LastName"],
      data["Email"],
      data["GPA"],
      data["CatalogYear"],
      classification,
      data["Hours"],
      data["AdvancedCsHours"],
      data["AdvancedHours"]);

  return student;
}

class DegreePageMimic extends StatefulWidget {
  //DegreePageMimic({Key key, this.title}) : super(key: key);

  //final String title;

  @override
  _DegreePageMimicState createState() => new _DegreePageMimicState();
}

class _DegreePageMimicState extends State<DegreePageMimic> {
  int statusCode = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double deviceWidth = SizeConfig.blockSizeHorizontal;
    double deviceHeight = SizeConfig.blockSizeVertical;
    return ListView(children: [
      /////////*****************************************************FRST BOX */
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
      //*************************************************************************SECOND BOX */
      Container(
        //The SECOND CONTAINER FOR PLLANED COURSES
        decoration: BoxDecoration(color: Color(0xff65646a)),
        child: FutureBuilder(
          future: _neverNull(),
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
                          deviceHeight * 1, deviceWidth * 1, deviceHeight * 1),
                      //color: Color(0xffebebe8),
                      width: deviceWidth * 98,
                      height: deviceHeight * 35,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xffebebe8), Color(0xffebebe8)]),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: ListView(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        color: Color(0xffcf4411),
                                        fontWeight: FontWeight.bold,
                                        height: deviceHeight * 0.2,
                                        fontSize: deviceHeight * 2.0),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            "C - Supported Courses 32 HOURS (12 Advanced)",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Colors.black.withOpacity(1.0)),
                                      ),
                                    ]),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        //color: Color(0xffcf4411),
                                        fontWeight: FontWeight.bold,
                                        height: deviceHeight * 0.2,
                                        fontSize: deviceHeight * 1.5),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            "1 - Oral and Written Communication - 3 hours (3 Advanced)",
                                        style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color:
                                                Colors.black.withOpacity(1.0)),
                                      ),
                                    ]),
                              )
                            ],
                          ),
                          Card(
                            color: Color(0xffebebe8),
                            child: ListTile(
                              //leading: FlutterLogo(size: 56.0),
                              title: Text('Technical Communication'),
                              subtitle: Text('ENGL 3342'),
                              //trailing: Icon(Icons.more_vert),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        //color: Color(0xffcf4411),
                                        fontWeight: FontWeight.bold,
                                        height: deviceHeight * 0.2,
                                        fontSize: deviceHeight * 1.5),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            "Matheematics and Engineering - 15 Hours 3 advanced",
                                        style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color:
                                                Colors.black.withOpacity(1.0)),
                                      ),
                                    ]),
                              )
                            ],
                          ),
                          Card(
                            color: Color(0xffebebe8),
                            child: ListTile(
                              //leading: FlutterLogo(size: 56.0),
                              title: Text('Digital Systems Engineering I Lab'),
                              subtitle: Text('ELEE 2130'),

                              //trailing: Icon(Icons.more_vert),
                            ),
                          ),
                          Card(
                            color: Color(0xffebebe8),
                            child: ListTile(
                              //leading: FlutterLogo(size: 56.0),
                              title: Text('Digital Systems Engineering I'),
                              subtitle: Text('ELEE 2330'),
                              //trailing: Icon(Icons.more_vert),
                              onTap: () async {
                                await storage.write(
                                    key: "CourseName",
                                    value: "Digital Systems Engineering I");
                                print(await storage.read(key: "CourseName"));
                                showDialog(
                                  context: context,
                                  builder: (_) => EditPopUp(),
                                );
                              },
                            ),
                          ),
                          Card(
                            color: Color(0xffebebe8),
                            child: ListTile(
                              //leading: FlutterLogo(size: 56.0),
                              title: Text('Linear Algebra'),
                              subtitle: Text('MATH 2318'),
                              //trailing: Icon(Icons.more_vert),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      //*************************************************************************THIRD BOX */
    ]);
  }
}

// (() {
//   // your code here
// }()),

// ListView.builder(
//               itemCount: snapshot.data.length,
//               itemBuilder: (BuildContext context, int i) {
//                 return ListTile(
//                   title: Text(snapshot.data[i].name,
//                       style: TextStyle(color: Color(0xffebebe8))),
//                   subtitle: Text(
//                       "${snapshot.data[i].courseDept} ${snapshot.data[i].courseNum}"),
//                   onTap: () => showDialog(
//                     context: context,
//                     builder: (_) => PopUpAdd(message: "Implement Later"),
//                   ),
//                   trailing: Text("+"),
//                   leading: Text((() {
//                     if (snapshot.data[i].taken == true) {
//                       return "✔️";
//                     }else
//                     return "❌";
//                   })()),
//                 );
//               },
//             ),

class EditPopUp extends StatefulWidget {
  @override
  String message = "hi";

  State<StatefulWidget> createState() => EditPopUpState();
}

class EditPopUpState extends State<EditPopUp>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double deviceWidth = SizeConfig.blockSizeHorizontal;
    double deviceHeight = SizeConfig.blockSizeVertical;
    String dropdownValueForGrade = 'A';
    String dropDownValueForSemester = "Fall";
    String newValueForGrade = 'null';
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            width: deviceWidth * 95,
            height: deviceHeight * 40,
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: ListView(
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
                        text: 'Letter Grade:',
                        style: TextStyle(color: Colors.black.withOpacity(0.5)),
                      )
                    ],
                  ),
                ),
                DropdownButton<String>(
                  value: dropdownValueForGrade,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  onChanged: (newValueForGrade) {
                    setState(() async {
                      dropdownValueForGrade = newValueForGrade;
                      await storage.write(
                          key: "CourseGrade", value: "$newValueForGrade");
                      print(await storage.read(key: "CourseGrade"));
                    });
                  },
                  items: <String>['A', 'B', 'C', 'D', 'F', 'W', 'DR', 'P', 'NP']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                //************************FOR SEMESTER********************** */
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: Color(0xffcf4411),
                        fontWeight: FontWeight.bold,
                        height: deviceHeight * 0.2,
                        fontSize: deviceHeight * 2.28),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Semester:',
                        style: TextStyle(color: Colors.black.withOpacity(0.5)),
                      )
                    ],
                  ),
                ),
                DropdownButton<String>(
                  value: dropDownValueForSemester,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  onChanged: (newValueForSemester) {
                    setState(() async {
                      dropDownValueForSemester = newValueForSemester;
                      await storage.write(
                          key: "CourseSemester", value: "$newValueForSemester");
                      print(await storage.read(key: "CourseSemester"));
                    });
                  },
                  items: <String>['Fall', 'Spring', 'Summer I', 'Summer II']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(deviceHeight * 1,
                          deviceHeight * 1, deviceWidth * 1, deviceWidth * 1),
                      child: NiceButton(
                        width: deviceWidth * 35,
                        elevation: 8.0,
                        radius: 52.0,
                        text: "Add\n Course",
                        fontSize: deviceHeight * 2,
                        background: Color(0xffcf4411),
                        onPressed: () async {
                          await addCourse();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(deviceHeight * 1,
                          deviceHeight * 1, deviceWidth * 1, deviceWidth * 1),
                      child: NiceButton(
                        width: deviceWidth * 35,
                        elevation: 8.0,
                        radius: 52.0,
                        text: "Remove \nCourse",
                        fontSize: deviceHeight * 2,
                        background: Color(0xffcf4411),
                        onPressed: () async {
                          await delCourse();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(deviceHeight * 1,
                          deviceHeight * 1, deviceWidth * 1, deviceWidth * 1),
                      child: NiceButton(
                        width: deviceWidth * 35,
                        elevation: 8.0,
                        radius: 52.0,
                        text: "Add\nPlanned Course",
                        fontSize: deviceHeight * 2,
                        background: Color(0xffcf4411),
                        onPressed: () async {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(deviceHeight * 1,
                          deviceHeight * 1, deviceWidth * 1, deviceWidth * 1),
                      child: NiceButton(
                        width: deviceWidth * 35,
                        elevation: 8.0,
                        radius: 52.0,
                        text: "Remove \nPlanned Course",
                        fontSize: deviceHeight * 2,
                        background: Color(0xffcf4411),
                        onPressed: () async {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<int> addCourse() async {
  var response = await http.post(
      "$address/selfadd/StudentCourses?Semester=${await storage.read(key: "CourseSemester")}&Grade=${await storage.read(key: "CourseGrade")}&CourseName=${await storage.read(key: "CourseName")}",
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${await storage.read(key: "token")}"
      });
  print(
      "$address/selfadd/StudentCourses?Semester=${await storage.read(key: "CourseSemester")}&Grade=${await storage.read(key: "CourseGrade")}&CourseName=${await storage.read(key: "CourseName")}");
  print(
      "This is the response status code for addCourse() = ${response.statusCode}");
  return response.statusCode;
}

Future<int> delCourse() async {
  var response = await http.delete(
      "$address/remove/StudentCourse?CourseName=${await storage.read(key: "CourseName")}",
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${await storage.read(key: "token")}"
      });
  print(
      "This is the response status code for delCourse() = ${response.statusCode}");
  return response.statusCode;
}

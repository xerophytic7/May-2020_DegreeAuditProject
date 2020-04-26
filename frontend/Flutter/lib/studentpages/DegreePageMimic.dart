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
    //StudentInfo();
    // Future<Map<String, dynamic>> data = CoursesInfo();

    // print(data);
    //need a future builder
    return new FutureBuilder(
      future: _getCourses(),
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
          return Scaffold(
            backgroundColor: Color(0xff65646a),
            body: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  title: Text(snapshot.data[i].name,
                      style: TextStyle(color: Color(0xffebebe8))),
                  subtitle: Text(
                      "${snapshot.data[i].courseDept} ${snapshot.data[i].courseNum}"),
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => PopUpAdd(message: "Implement Later"),
                  ),
                  trailing: Text("+"),
                  leading: Text((() {
                    if (snapshot.data[i].taken == true) {
                      return "✔️";
                    }else
                    return "❌";
                  })()),
                );
              },
            ),
          );
        }
      },
    );
  }
}

class PopUpAdd extends StatefulWidget {
  @override
  final String message;
  const PopUpAdd({Key key, this.message}) : super(key: key);

  State<StatefulWidget> createState() => PopUpAddState();
}

class PopUpAddState extends State<PopUpAdd>
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
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Text(widget.message),
            ),
          ),
        ),
      ),
    );
  }
}

// (() {
//   // your code here
// }()),

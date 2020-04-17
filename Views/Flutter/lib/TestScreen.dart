import 'package:flutter/material.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:seniordesign/pages/CreateAdmin.dart';
import 'package:seniordesign/pages/CustomId.dart';
import 'package:seniordesign/pages/PostAddCourse.dart';
import 'package:seniordesign/pages/PostAddStudentCourse.dart';
import 'package:seniordesign/pages/Testid.dart';
import 'package:seniordesign/pages/DelAllUsers.dart';
import 'package:seniordesign/globals/globals.dart';

import 'package:seniordesign/pages/Drawer.dart';

// void main() => runApp(MyApp());

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        DrawerHomePage(),
        CreateAdmin(),
        CustomId(),
        TestId(),
        DelAllUsers(),
        PostAddCourse(),
        PostAddStudentCourses(),
      ],
    );
  }
}
///////////////////////////////////////////////

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       backgroundColor: Color(0xff65646a),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [Text("Hi")],
//       ),
//     );
//   }
// }

// ////////////////////////////////////////////////////////////////////////
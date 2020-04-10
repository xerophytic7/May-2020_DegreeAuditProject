import 'package:flutter/material.dart';
import 'package:seniordesign/pages/CreateAdmin.dart';
import 'package:seniordesign/pages/CustomId.dart';
import 'package:seniordesign/pages/PostAddCourse.dart';
import 'package:seniordesign/pages/PostAddStudentCourse.dart';
import 'package:seniordesign/pages/Testid.dart';
import 'package:seniordesign/pages/DelAllUsers.dart';

import 'package:seniordesign/pages/Drawer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: MainMenu(),
        ),
      ),
    );
  }
}

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

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



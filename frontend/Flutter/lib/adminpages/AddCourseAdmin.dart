import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nice_button/NiceButton.dart';

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:seniordesign/popup.dart';
import 'package:nice_button/nice_button.dart';
import 'dart:async';

import 'package:http/http.dart' as http;

import 'package:seniordesign/globals/globals.dart';

TextEditingController courseDeptTextCtrl = TextEditingController();
TextEditingController courseNumTextCtrl = TextEditingController();
TextEditingController fnTextCtrl = TextEditingController();
TextEditingController lnTextCtrl = TextEditingController();

//TextEditingController idTextCtrl = TextEditingController();
final storage = new FlutterSecureStorage();

Future<int> code() async {
  //String courseDept,CourseNum,fn,ln,id;

  final response = await http.post(
    "${address}/add/CoursecourseDept=${courseDeptTextCtrl.text}&CourseNum=${courseNumTextCtrl.text}&Name=${fnTextCtrl.text}&Institution=${lnTextCtrl.text}",
    headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${await storage.read(key: "token")}"
      });

  
    return response.statusCode;
}

class AddCourseAdmin extends StatefulWidget {
  //AddCourseAdmin({Key key, this.title}) : super(key: key);

  //final String title;

  @override
  _AddCourseAdminState createState() => new _AddCourseAdminState();
}

class _AddCourseAdminState extends State<AddCourseAdmin> {
  String kode = "0";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xff65646a),
      body: new Center(
        child: new ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/images/image0.png"),
            Container(
              margin: const EdgeInsets.all(10.0),
              //color: Color(0xffebebe8),
              width: 48.0 * 8,
              height: 48.0 * 10,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xffebebe8), Color(0xffebebe8)]),
                  borderRadius: BorderRadius.circular(6.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        offset: Offset(0.0, 8.0),
                        blurRadius: 8.0)
                  ]),

              ///Beggining of the stuff
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: new TextFormField(
                      decoration: new InputDecoration(
                        //labelText: "Enter courseDept",
                        hintText: "courseDept",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                      controller: courseDeptTextCtrl,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: new TextFormField(
                      obscureText: true,
                      decoration: new InputDecoration(
                        //labelText: "Enter courseDept",
                        hintText: "CourseNum",

                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                      controller: courseNumTextCtrl,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: new TextFormField(
                      decoration: new InputDecoration(
                        //labelText: "Enter courseDept",
                        hintText: "Name",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                      controller: fnTextCtrl,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: new TextFormField(
                      decoration: new InputDecoration(
                        //labelText: "Enter courseDept",
                        hintText: "Institute",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                      controller: lnTextCtrl,
                    ),
                    // ),Padding(
                    //   padding: EdgeInsets.all(10),
                    //   child: new TextFormField(
                    //     decoration: new InputDecoration(
                    //       //labelText: "Enter courseDept",
                    //       hintText: "id",
                    //       fillColor: Colors.white,
                    //       border: new OutlineInputBorder(
                    //         borderRadius: new BorderRadius.circular(25.0),
                    //         borderSide: new BorderSide(),
                    //       ),
                    //       //fillColor: Colors.green
                    //     ),
                    //     style: new TextStyle(
                    //       fontFamily: "Poppins",
                    //     ),
                    //     controller: idTextCtrl,
                    //   ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(6),
                    child: NiceButton(
                      width: 200,
                      elevation: 8.0,
                      radius: 52.0,
                      text: "Submit",
                      textColor: Color(0xffebebe8),
                      background: Color(0xffcf4411),
                      onPressed: () async {
                        if (courseDeptTextCtrl.text.isEmpty ||
                            courseNumTextCtrl.text.isEmpty ||
                            fnTextCtrl.text.isEmpty ||
                            lnTextCtrl.text.isEmpty) {
                          // || idTextCtrl.text.isEmpty){
                          showDialog(
                            context: context,
                            builder: (_) =>
                                Popup(message: "Please fill out all fields"),
                          );
                        } else {
                          kode = await code().toString();
                          //bug if in the textfield there is a space after like "22 " then it wont work must clear of spaces after text
                          showDialog(
                            context: context,
                            builder: (_) => Popup(message: kode),
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(6),
                    child: NiceButton(
                      background: Color(0xffebebe8),
                      text: " ",
                      mini: true,
                      icon: Icons.arrow_back,
                      iconColor: Color(0xffcf4411),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

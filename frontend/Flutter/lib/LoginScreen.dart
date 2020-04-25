import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:seniordesign/RegisterScreen.dart';
import 'package:seniordesign/studentpages/DegreePageMimic.dart';
import 'package:seniordesign/studentpages/StudentMainScreen.dart';
import 'package:seniordesign/adminpages/AdminMainScreen.dart';
import 'package:seniordesign/TestScreen.dart';
import 'package:seniordesign/popup.dart';
import 'package:seniordesign/globals/globals.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:seniordesign/studentpages/StudentMainScreenMinor.dart';
import 'package:seniordesign/studentpages/DegreePageMimic.dart';

final storage = new FlutterSecureStorage();

TextEditingController usernameTextCtrl = TextEditingController();
TextEditingController passwordTextCtrl = TextEditingController();

int admin = 0;
bool major = true;

Future<Void> iSadmin() async {
  //String username,password,fn,ln,id;

  final response = await http.get(
    "$address/isAdmin",
    headers: {HttpHeaders.authorizationHeader: "${await storage.read(key: "token")}"}
  );
  print(await storage.read(key: "token"));
  admin = 0;
    if(response.statusCode == 200 && json.decode(response.body)["admin"] == "true")
      admin = 1;
    if(response.statusCode == 200 && json.decode(response.body)["mode"] == "minor")
      major = false;
  return null;
  
}

Future<int> code() async {
  //String username,password,fn,ln,id;

  final response = await http.get(
    "$address/api/login?username=${usernameTextCtrl.text}&password=${passwordTextCtrl.text}",
    //headers: {HttpHeaders.authorizationHeader: "${token}"}
  );


print(response.body);
  if(response.statusCode == 200){
    Map<String, dynamic> data = json.decode(response.body);
    await storage.write(key: "token", value: data["token"]);
    String value = await storage.read(key: "token");
    return response.statusCode;
    
  }
  if (response.statusCode != null) {
    return response.statusCode;
  }
    
}

class LoginScreen extends StatefulWidget {
  //LoginScreen({Key key, this.title}) : super(key: key);

  //final String title;

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int statusCode = 0;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xff65646a),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/images/image0.png"),
            Container(
              margin: const EdgeInsets.all(10.0),
              //color: Color(0xffebebe8),
              width: 48.0 * 8,
              height: 48.0 * 7,
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
                        //labelText: "Enter Username",
                        hintText: "Username",
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
                      controller: usernameTextCtrl,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: new TextFormField(
                      obscureText: true,
                      decoration: new InputDecoration(
                        //labelText: "Enter Username",
                        hintText: "Password",

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
                      controller: passwordTextCtrl,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(6),
                    child: NiceButton(
                      width: 200,
                      elevation: 8.0,
                      radius: 52.0,
                      text: "Login",
                      background: Color(0xffcf4411),
                      onPressed: () async {
                        statusCode = await code();
                        iSadmin();
                        if (statusCode != 200) {
                          showDialog(
                          context: context,
                          builder: (_) => Popup(message: "Invalid Credentials"),
                        );
                        }
                        if (statusCode == 200 && admin == 0 && major == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentMainScreen()),
                          );
                        }
                        if (statusCode == 200 && admin == 0 && major == false) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentMainScreen()),
                          );
                        }
                        if (statusCode == 200 && admin == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminMainScreen()),
                          );
                        }

                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(6),
                    child: NiceButton(
                      width: 200,
                      elevation: 8.0,
                      radius: 52.0,
                      text: "Register",
                      textColor: Color(0xffcf4411),
                      background: Color(0xffebebe8),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()),
                        );
                      },
                    ),
                  ),
                  
                ],
              ),
            ),
          Padding(
                    padding: EdgeInsets.all(6),
                    child: NiceButton(
                      width: 240,
                      elevation: 8.0,
                      radius: 52.0,
                      text: "DegreePlan Login",
                      textColor: Color(0xffcf4411),
                      background: Color(0xffebebe8),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DegreePageMimic()),
                        );
                      },
                    ),
                  ),],
        ),
      ),
    );
  }
}

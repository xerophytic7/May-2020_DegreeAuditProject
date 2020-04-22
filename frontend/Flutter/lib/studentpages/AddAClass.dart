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

String firstname = "USER";
String lastname = "USER";
String email = "USEREMAIL";
String  gpa = "0.0";
String catalogyear = "####-####";
String classification = "Undergrad";
String hours = "0";
String advancedhours = "0";
String advancedcshours = "0";
double perA = 0.32;

Future<Void> StudentInfo() async {
  //String username,password,fn,ln,id;
  String value = await storage.read(key: "token");
  print("This is the supposed Token $value");
  final response = await http.get(
    "$address/MyInfo",
    headers: {HttpHeaders.authorizationHeader: "Bearer $value"},
  );

  Map<String, dynamic> data = json.decode(response.body);
  print("return the JSON of info ==> $data");

  if(data["FirstName"] != "")      firstname       = data["FirstName"];
  if(data["LastName"] != "")       lastname        = data["LastName"];
  if(data["Email"] != "")          email           = data["Email"];
  if(data["GPA"] != "")            gpa             = data["GPA"];
  if(data["CatalogYear"] != "")    catalogyear     = data["CatalogYear"];   
  if(data["Classification"] != "") classification  = data["Classification"]; 
  if(data["Hours"] != "")          hours           = data["Hours"];
  if(data["AdvancedCSHours"] != "")advancedcshours = data["AdvancedCsHours"];
  if(data["AdvancedHours"] != "")  advancedhours   = data["AdvancedHours"];



  return null;

}

Future<List<dynamic>> CoursesInfo() async {
  //String username,password,fn,ln,id;
  String value = await storage.read(key: "token");
  print("This is the supposed Token $value");
  final response = await http.get(
    "$address/all/Courses",
    headers: {HttpHeaders.authorizationHeader: "Bearer $value"},
  );

  if(response.statusCode != 200) return null;

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
  int statusCode = 0;
  
  @override
  Widget build(BuildContext context) {
    StudentInfo();
    // Future<Map<String, dynamic>> data = CoursesInfo();

    // print(data);
  //need a future builder
    return new Scaffold(
      backgroundColor: Color(0xff65646a),
      
      body: Column(children: <Widget>[

      ],),
    );
  }
}

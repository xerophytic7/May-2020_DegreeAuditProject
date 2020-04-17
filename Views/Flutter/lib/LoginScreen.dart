import 'package:flutter/material.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:seniordesign/RegisterScreen.dart';
import 'package:seniordesign/TestScreen.dart';
import 'package:seniordesign/popup.dart';
import 'package:seniordesign/globals/globals.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

final storage = new FlutterSecureStorage();

TextEditingController usernameTextCtrl = TextEditingController();
TextEditingController passwordTextCtrl = TextEditingController();

Future<int> code() async {
  //String username,password,fn,ln,id;

  final response = await http.get(
    "${address}/api/login?username=${usernameTextCtrl.text}&password=${passwordTextCtrl.text}",
    //headers: {HttpHeaders.authorizationHeader: "${token}"}
  );

print(response.body);
  if(response.statusCode == 200){
    print(response.statusCode);
    print("One");
    Map<String, dynamic> data = json.decode(response.body);
    print("Six");
    await storage.write(key: "token", value: data["token"]);
    print("Five");
    String value = await storage.read(key: "token");
    print("Four");
    return response.statusCode;
    print(value);
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
                        print(statusCode);
                        if (statusCode != 200) {
                          showDialog(
                          context: context,
                          builder: (_) => Popup(message: "Invalid Credentials"),
                        );
                        }
                        if (statusCode == 200) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TestScreen()),
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
          ],
        ),
      ),
    );
  }
}

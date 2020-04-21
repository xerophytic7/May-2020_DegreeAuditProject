import 'package:flutter/material.dart';
import 'package:seniordesign/popup.dart';
import 'package:nice_button/nice_button.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class DrawerHomePage extends StatelessWidget {
  final String title;

  DrawerHomePage({Key key, this.title}) : super(key: key);

  double up = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Menu"),
        backgroundColor: Color.fromRGBO(255, 128, 0, 100),
      ),
      body: Center(child: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/d/dc/Texas%E2%80%93Rio_Grande_Valley_Vaqueros_logo.svg/1200px-Texas%E2%80%93Rio_Grande_Valley_Vaqueros_logo.svg.png")),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Image.network("https://utrgv.ridesystems.net/Images/clientLogo.jpg"),
              //child: Text('Degree Audit' , style: TextStyle(fontSize: 30 ,),),
              decoration: BoxDecoration(
                //image:
                color: Color.fromRGBO(255, 128, 0, 100),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(up),
              child: NiceButton(
                width: 200,
                elevation: 8.0,
                radius: 52.0,
                text: "Advising",
                background:Color.fromRGBO(255, 128, 0, 100),
                onPressed: () async {
                  //kode = code().toString();
                  showDialog(
                    context: context,
                    builder: (_) => Popup(message: "Sorry not implemnted :("),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(up),
              child: NiceButton(
                width: 200,
                elevation: 8.0,
                radius: 52.0,
                text: "Future Courses",
                background: Color.fromRGBO(255, 128, 0, 100),
                onPressed: () async {
                  //kode = code().toString();
                  showDialog(
                    context: context,
                    builder: (_) => Popup(message: "Sorry not implemnted :("),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(up),
              child: NiceButton(
                width: 200,
                elevation: 8.0,
                radius: 52.0,
                text: "Notifications",
                background: Color.fromRGBO(255, 128, 0, 100),
                onPressed: () async {
                  //kode = code().toString();
                  showDialog(
                    context: context,
                    builder: (_) => Popup(message: "Sorry not implemnted :("),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(up),
              child: NiceButton(
                width: 200,
                elevation: 8.0,
                radius: 52.0,
                text: "User Profle",
                background: Color.fromRGBO(255, 128, 0, 100),
                onPressed: () async {
                  //kode = code().toString();
                  showDialog(
                    context: context,
                    builder: (_) => Popup(message: "Sorry not implemnted :("),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

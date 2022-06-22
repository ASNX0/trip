// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

// ignore: camel_case_types
class credit extends StatelessWidget {
  const credit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 55),
            child: Text(
              "Registration is Complete !",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 130),
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 70),
            child: Container(
              margin: EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  Icon(
                    Icons.download_done_outlined,
                    size: 100,
                    color: Colors.green[300],
                  ),
                  Text(
                    "We are reviewing your credentials it can take up to 48 hours",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: RaisedButton(
              onPressed: () => null,
              child: Text(
                "Done",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 14),
              color: Colors.blue,
            ),
          )
        ],
      ),
    );
  }
}

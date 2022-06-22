// ignore_for_file: deprecated_member_use, avoid_types_as_parameter_names, use_key_in_widget_constructors, unnecessary_statements, unused_import

import 'package:flutter/material.dart';
import 'package:scannerapp/logging/bloc.dart';
import 'package:scannerapp/logging/handleAccount.dart';
import 'package:scannerapp/logging/login.dart';
import 'package:scannerapp/logging/register.dart';
import 'package:sizer/sizer.dart';

class SignUpD extends StatelessWidget {
  String Type = "";
  final _formKey2 = GlobalKey<FormState>();

  final snackKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: snackKey,
      body: TweenAnimationBuilder(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                child: Image(
                  image: AssetImage('images/diver.jpg'),
                  fit: BoxFit.fitHeight,
                  // height: 45.h,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 36.h),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Form(
                  key: _formKey2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CheackBox(
                        getType: (x) {
                          Type = x;
                        },
                      ),
                      Field(
                        onChange: Dbloc.changeName,
                        blocstream: Dbloc.name,
                        text: "Name",
                        icon: Icons.person,
                      ),
                      Field(
                        onChange: Dbloc.changeEmail,
                        blocstream: Dbloc.email,
                        text: "Email",
                        icon: Icons.email,
                      ),
                      Field(
                        onChange: Dbloc.changePassword,
                        blocstream: Dbloc.password,
                        text: "Password",
                        icon: Icons.lock,
                      ),
                      // Field(
                      //   onChange: Dbloc.changeConf,
                      //   blocstream: Dbloc.confpassword,
                      //   text: "Confirm Password",
                      //   icon: Icons.lock,
                      // ),
                      Field(
                        onChange: Dbloc.changephone,
                        blocstream: Dbloc.phone,
                        text: "Phone Number",
                        icon: Icons.lock,
                      ),
                      SizedBox(height: 0.5.h),
                      StreamBuilder(
                          stream: Dbloc.regValid,
                          builder: (context, snapshot) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(225, 209, 27, 14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                disabledColor: Colors.black54,
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.h, horizontal: 22.w),
                                onPressed: snapshot.hasData
                                    ? () => Account.register(
                                        context, "$Type", Dbloc)
                                    : null,
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      fontSize: 20.sp, color: Colors.white),
                                ),
                              ),
                            );
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already Have An Account? ",
                            style:
                                TextStyle(fontSize: 12.sp, color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SignIn(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                  fontSize: 15.sp, color: Colors.blue),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(seconds: 2),
        curve: Curves.easeInQuart,
        builder: (BuildContext context, double _val, child) {
          return Opacity(
            opacity: _val,
            child: Padding(
              padding: EdgeInsets.only(top: _val * 14),
              child: child,
            ),
          );
        },
      ),
    );
  }

  // ignore: non_constant_identifier_names

}

class CheackBox extends StatefulWidget {
  var TexiD;
  var BusD;
  Function getType;
  CheackBox({this.BusD = false, this.TexiD = true, required this.getType});

  @override
  _CheackBoxState createState() => _CheackBoxState();
}

class _CheackBoxState extends State<CheackBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            "Viechel-Type:",
            style: TextStyle(fontSize: 15.sp, color: Colors.white),
          ),
        ),
        Expanded(
          child: CheckboxListTile(
              activeColor: Colors.red,
              title: Text(
                "Taxi",
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              value: this.widget.TexiD,
              onChanged: (value) {
                setState(() {
                  this.widget.TexiD = value!;
                  if (this.widget.TexiD == true) {
                    this.widget.BusD = false;
                    widget.getType("TaxiD");
                  }
                });
              }),
        ),
        Expanded(
          child: CheckboxListTile(
              activeColor: Colors.red,
              title: Text(
                "Bus",
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              value: this.widget.BusD,
              onChanged: (value) {
                setState(() {
                  this.widget.BusD = value!;
                  if (this.widget.BusD) {
                    this.widget.TexiD = false;
                    widget.getType("BusD");
                  }
                });
              }),
        ),
      ],
    );
  }
}

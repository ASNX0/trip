// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use, invalid_use_of_visible_for_testing_member, avoid_print, unnecessary_new, prefer_const_constructors, curly_braces_in_flow_control_structures, use_key_in_widget_constructors, unnecessary_statements, unused_field, must_be_immutable

import 'package:flutter/material.dart';
import 'package:scannerapp/logging/bloc.dart';
import 'package:scannerapp/logging/handleAccount.dart';
import 'package:scannerapp/logging/register.dart';
import 'package:scannerapp/welcome.dart';
import 'package:sizer/sizer.dart';

class SignIn extends StatelessWidget {
  final snackKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: snackKey,
      body: TweenAnimationBuilder(
        child: Stack(
          children: [
            Container(
              child: Image(
                image: AssetImage('images/login.jpg'),
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 4.h),
              margin: EdgeInsets.only(top: 36.h),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      "Welcome\nLogin Here",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Field(
                      onChange: Lbloc.changeEmail,
                      blocstream: Lbloc.email,
                      text: "Email",
                      icon: Icons.email,
                    ),
                    Field(
                      onChange: Lbloc.changePassword,
                      blocstream: Lbloc.password,
                      text: "Password",
                      icon: Icons.lock,
                    ),
                    StreamBuilder(
                        stream: Lbloc.submitValid,
                        builder: (context, snapshot) {
                          return Container(
                            margin: EdgeInsets.only(top: 2.h),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(225, 209, 27, 14),
                              boxShadow: [],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              disabledColor: Colors.black54,
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.h, horizontal: 22.w),
                              onPressed: snapshot.hasData
                                  ? () => Account.login(context)
                                  : null,
                              child: Text(
                                "Log In",
                                style: TextStyle(
                                    fontSize: 20.sp, color: Colors.white),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 22.sp,
                )),
          ],
        ),
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(seconds: 2),
        curve: Curves.easeInQuart,
        builder: (BuildContext context, double _val, child) {
          return Opacity(
            opacity: _val,
            child: Padding(
              padding: EdgeInsets.only(top: _val * 18),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

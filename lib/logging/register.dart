// ignore_for_file: deprecated_member_use, avoid_types_as_parameter_names, use_key_in_widget_constructors, unnecessary_statements, must_be_immutable

import 'package:flutter/material.dart';
import 'package:scannerapp/logging/bloc.dart';
import 'package:scannerapp/logging/handleAccount.dart';
import 'package:scannerapp/logging/login.dart';
import 'package:sizer/sizer.dart';

class SignUp extends StatelessWidget {
  final _formKey1 = GlobalKey<FormState>();

  final snackKey = GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    return Scaffold(
      key: snackKey,
      body: TweenAnimationBuilder(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 1.h),
              child: Image.asset(
                "images/register.jpg",
                fit: BoxFit.cover,
                // height: 60.h,
                height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 1.h),
              margin: EdgeInsets.only(top: 40.h),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Form(
                key: _formKey1,
                child: ListView(
                  children: <Widget>[
                    Field(
                      onChange: Rbloc.changeName,
                      blocstream: Rbloc.name,
                      text: "Name",
                      icon: Icons.person,
                    ),
                    Field(
                      onChange: Rbloc.changeEmail,
                      blocstream: Rbloc.email,
                      text: "Email",
                      icon: Icons.email,
                    ),
                    Field(
                      onChange: Rbloc.changePassword,
                      blocstream: Rbloc.password,
                      text: "Password",
                      icon: Icons.lock,
                    ),
                    // Field(
                    //   onChange: Rbloc.changeConf,
                    //   blocstream: Rbloc.confpassword,
                    //   text: "Confirm Password",
                    //   icon: Icons.lock,
                    // ),
                    Field(
                      onChange: Rbloc.changephone,
                      blocstream: Rbloc.phone,
                      text: "Phone Number",
                      icon: Icons.lock,
                    ),
                    SizedBox(height: 0.5.h),
                    StreamBuilder(
                        stream: Rbloc.regValid,
                        builder: (context, snapshot) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 14.w),
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
                                  ? () =>
                                      Account.register(context, "User", Rbloc)
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
                                fontSize: 15.sp, color: Colors.blue[700]),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
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
                  )),
            ),
          ],
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

// Text Field //

class Field extends StatelessWidget {
  bool passwordvisabile = false;
  Function onChange;
  final Stream blocstream;
  final String text;
  final IconData icon;

  Field({
    required this.onChange,
    required this.blocstream,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: blocstream,
        builder: (context, snapshot) {
          return StreamBuilder(
              stream: Rbloc.hide,
              builder: (context, snapshot2) {
                return Container(
                  height: 55,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 238, 235, 235),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.black26,
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 0.2,
                          blurRadius: 2,
                          offset: Offset(-1, 4), // changes position of shadow
                        ),
                      ]),
                  child: TextFormField(
                    style: TextStyle(color: Colors.black, fontSize: 19),
                    keyboardType: TextInputType.emailAddress,
                    obscureText:
                        text == "Password" || text == "Confirm Password"
                            ? !passwordvisabile
                            : false,
                    onChanged: (value) => onChange(value),
                    decoration: InputDecoration(
                      enabled: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15, right: 15),
                      errorText: snapshot.error?.toString(),
                      errorStyle: TextStyle(
                          color: Color.fromARGB(255, 233, 38, 24),
                          fontSize: 14,
                          height: 0.001),
                      prefixIcon: Icon(icon, color: Color(0xff989cb8)),
                      hintText: text,
                      hintStyle: TextStyle(color: Colors.black54, height: 2),
                      suffixIcon:
                          text == "Password" || text == "Confirm Password"
                              ? IconButton(
                                  icon: Icon(
                                      passwordvisabile
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Color(0xff989cb8)),
                                  onPressed: () {
                                    passwordvisabile = !passwordvisabile;
                                    Rbloc.changehide.add(passwordvisabile);
                                  },
                                )
                              : null,
                    ),
                  ),
                );
              });
        });
  }
}

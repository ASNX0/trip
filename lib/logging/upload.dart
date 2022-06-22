// ignore_for_file: await_only_futures, must_be_immutable, non_constant_identifier_names, deprecated_member_use, duplicate_ignore
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scannerapp/home.dart';
import 'package:scannerapp/logging/handleAccount.dart';
import 'package:scannerapp/logging/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class Upload extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Upload();
  }
}

class _Upload extends State<Upload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: successful == false ? Colors.white : Colors.orange[200],
      appBar: AppBar(
        title: Text(
          "Credentials",
        ),
        backgroundColor: Color.fromARGB(255, 18, 65, 104),
      ),
      body: successful == false
          ? Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 3.w, top: 2.h, bottom: 1.h),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Complete your registeration:",
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                  ),
                ),
                Expansion(
                  'Step 1:',
                  'Driver License',
                  'images/license_ks.png',
                  Licenseimage,
                  true,
                ),
                SizedBox(height: 0.7.h),
                Expansion(
                  'Step 2:',
                  'Veichel Registration',
                  'images/registration.png',
                  Regimage,
                  false,
                ),
                SizedBox(height: 1.h),
                Container(
                    child: Licenseimage == null || Regimage == null
                        ? Container()
                        : Container(
                            // ignore: deprecated_member_use
                            child: RaisedButton.icon(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.sp, vertical: 2.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            onPressed: () {
                              addImage();
                            },
                            icon: Icon(Icons.cloud_upload_outlined),
                            label: Text(
                              "Upload",
                              style: TextStyle(fontSize: 18),
                            ),
                            color: Colors.black,
                            colorBrightness: Brightness.dark,
                          ))),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 150),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                  child: Container(
                    margin: EdgeInsets.only(top: 60),
                    child: Column(
                      children: [
                        Icon(
                          Icons.download_done_outlined,
                          size: 100,
                          color: Colors.green,
                        ),
                        Text(
                          "We are reviewing your credentials it can take up to 48 hours",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignIn(),
                        ),
                      );
                    },
                    child: Text(
                      "Done",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 14),
                    color: Colors.black,
                  ),
                )
              ],
            ),
    );
  }

  final imagePicker = ImagePicker();

  var Licenseimage, Regimage;

  Map<String, String> name = {};
  Map<String, String> name2 = {};
  var image, image2, path, path2;

  Future<void> chooseImage() async {
    image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null)
      setState(() {
        Licenseimage = File(image?.path);
        path = Licenseimage.path;
        name = {
          'title': Licenseimage.path.split("/").last,
        };
      });
  }

  Future<void> choosimage2() async {
    image2 = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image2 != null)
      setState(() {
        Regimage = File(image2?.path);
        path2 = Regimage.path;
        name2 = {
          'title': Regimage.path.split("/").last,
        };
      });
  }

  bool successful = false;

  Future addImage() async {
    String addimageUrl = 'http://192.168.1.103:8000/api/auth/imageadd';
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = await localStorage.getString('token');
    Map<String, String> headers = {
      'Content-Type': 'multipart/api',
      'Accept': 'application/json',
      'Authorization': 'bearer $token',
    };

    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(name)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('License', path));
    var request2 = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(name2)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('Registration', path2));
    var response = await request.send();
    var response2 = await request2.send();

    if (response.statusCode == 201 && response2.statusCode == 201) {
      setState(() {
        successful = true;
      });
      print('true');
    } else {
      snack("check your internet connection", context);
    }
  }

  Widget Expansion(String title, String subtitle, String LRimage, var upload,
      bool Expanded) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20.sp),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          initiallyExpanded: Expanded,
          title: Text(
            title,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 2.h),
                      color: Colors.white,
                      child: upload == null
                          ? Container(
                              child: Column(
                                children: [
                                  Container(
                                    height: 13.h,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 8.w),
                                    alignment: Alignment.topCenter,
                                    child: Image(
                                      image: AssetImage(LRimage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Text(
                                    "Please Pick An Image",
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Color.fromARGB(115, 51, 50, 50)),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              child: Image.file(
                                upload,
                                fit: BoxFit.cover,
                              ))),
                  SizedBox(height: 14),
                  Container(
                    // ignore: deprecated_member_use
                    child: RaisedButton.icon(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        if (subtitle == 'Driver License') {
                          chooseImage();
                        } else {
                          choosimage2();
                        }
                      },
                      icon: Icon(Icons.folder_open),
                      label: Text(
                        "CHOOSE IMAGE",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      color: Color.fromARGB(255, 196, 56, 46),
                      colorBrightness: Brightness.dark,
                    ),
                  ),
                  SizedBox(height: 0.7.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

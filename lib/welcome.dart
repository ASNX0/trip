// ignore_for_file: deprecated_member_use, invalid_use_of_visible_for_testing_member, file_names, unused_import, unnecessary_new, duplicate_ignore, sized_box_for_whitespace, empty_constructor_bodies, must_be_immutable, use_key_in_widget_constructors, camel_case_types
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:scannerapp/Screens/history_model.dart';
import 'package:scannerapp/credit.dart';
import 'package:scannerapp/histroy.dart';
import 'package:scannerapp/home.dart';
import 'package:scannerapp/logging/driver.dart';
import 'package:scannerapp/logging/register.dart';
import 'package:scannerapp/logging/upload.dart';
import 'package:scannerapp/payment.dart';
import 'live Location/Myapp.dart';
import 'logging/qr.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int currentPage = 0;

  onpagechanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PreloadPageView.builder(
              itemCount: infolist.length,
              itemBuilder: (BuildContext context, int i) => Pages(index: i),
              onPageChanged: onpagechanged,
              preloadPagesCount: 2,
              controller: PreloadPageController(initialPage: 0),
              physics: AlwaysScrollableScrollPhysics(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(bottom: 15),
              child: DotsIndicator(
                dotsCount: 3,
                position: currentPage.toDouble(),
                decorator: DotsDecorator(
                  color: Colors.black87, // Inactive color
                  activeColor: Colors.redAccent,
                  size: const Size.square(13),
                  activeSize: const Size(20.0, 10.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Pages extends StatelessWidget {
  final int index;

  Pages({required this.index});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(
          height: MediaQuery.of(context).size.height,
          image: AssetImage(infolist[index].image),
          fit: BoxFit.fitHeight,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
        Center(
          child: Container(
            height: 18.h,
            width: 90.w,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 44.h),
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(60),
                    bottomLeft: Radius.circular(60))),
            child: Text(
              infolist[index].text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Roboto-Light"),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(bottom: 50),
          child: Visibility(
            visible: index == 2 ? true : false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  padding:
                      EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
                  color: Color.fromARGB(225, 209, 27, 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    " Rider",
                    style: TextStyle(fontSize: 22.sp, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  },
                ),
                RaisedButton(
                  padding:
                      EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
                  color: Color.fromARGB(225, 209, 27, 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    " Driver",
                    style: TextStyle(fontSize: 22.sp, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpD()));
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Info {
  final String image;
  final String text;
  Info({required this.image, required this.text});
}

final infolist = [
  Info(image: 'images/Bus.jpg', text: "Easy and comfortable\nWay To Travel "),
  Info(image: 'images/qr.jpg', text: "Qr Code\nFast Payment methode"),
  Info(image: 'images/taxi.jpg', text: "Setup Your Account"),
];

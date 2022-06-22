// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:scannerapp/api/api.dart';
import 'package:scannerapp/logging/handleAccount.dart';
import 'package:scannerapp/logging/qr.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

// ignore: camel_case_types
class payment extends StatefulWidget {
  var result;
  late Function search;
  payment({Key? key, this.result, required this.search}) : super(key: key);

  @override
  _paymentState createState() => _paymentState();
}

var _chosenValue;
var tikets;
var tokens;

// ignore: camel_case_types
class _paymentState extends State<payment> {
  @override
  void initState() {
    mytokens();

    super.initState();
  }

  mytokens() async {
    var data;
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var userJson = localStorage.getString('user');
    var user = json.decode(userJson.toString());
    if (user != null) data = {'email': '${user['email']}'};
    var res = await CallApi().postData(data, 'mytokens');
    var body = json.decode(res.body);
    setState(() {
      tokens = body['tokens'];
      tikets = body['tikets'];
    });
  }

  payment(BuildContext context, var tiket) async {
    var finalval = tiket * 200;
    var data;
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var userJson = localStorage.getString('user');
    var user = json.decode(userJson.toString());

    print(user);
    if (user != null)
      data = {'email': '${user['email']}', 'tikets': '$finalval'};
    var res = await CallApi().postData(data, 'buytiket');
    var body = json.decode(res.body);
    print(body['msg']);
    setState(() {
      mytokens();
    });
  }

  tripMarkers() async {
    String? localeIdentifier = "eg. en_US";
    final query = "G6VG+M93 جادات قدسيا، Syria";
    List<Location> addresses =
        await GeocodingPlatform.instance.locationFromAddress(
      query,
    );
    var loc = addresses.first;
    print("${loc.latitude} : ${loc.longitude}");
    List<Location> locations =
        await locationFromAddress("G6VG+M93 جادات قدسيا، Syria");
    print(locations);
    var loca = locations.first;
    print("late= ${loca.latitude}");
    widget.search(loc.latitude, loc.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 18, 65, 104),
        title: Text('Buy Tikets'),
      ),
      body: Center(
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(left: 3.w, top: 1.h),
              child: Row(
                children: [
                  Icon(
                    Icons.airplane_ticket_rounded,
                    size: 30.sp,
                  ),
                  SizedBox(width: 1.2.w),
                  Text(
                    '$tikets',
                    style: TextStyle(fontSize: 13.sp),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.do_not_disturb_on_total_silence_sharp,
                    size: 30.sp,
                  ),
                  SizedBox(width: 1.2.w),
                  Text(
                    '$tokens',
                    style: TextStyle(fontSize: 13.sp),
                  )
                ],
              ),
            ),
            Container(
              child: Image(
                image: AssetImage('images/QR.png'),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Please choose tickets number",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 22.w),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black45, width: 0.4.w),
                  borderRadius: BorderRadius.circular(16)),
              padding: EdgeInsets.all(4.sp),
              child: DropdownButton<int>(
                value: _chosenValue == null ? 1 : _chosenValue,

                //elevation: 5,
                style: TextStyle(color: Colors.black),
                items: <int>[
                  1,
                  2,
                  3,
                  4,
                  5,
                  6,
                ].map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(
                      '$value Tickets',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                  );
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    _chosenValue = value;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.w),
              child: RaisedButton(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QRViewExample(),
                    ),
                  );
                  if (widget.result != '' && _chosenValue != null) {
                    Account.token(context, _chosenValue);
                    Account.Btrips(context, widget.result);
                    tripMarkers();
                  }
                },
                color: Colors.blueGrey,
                child: Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () {},
                child: Text("Add Marker"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

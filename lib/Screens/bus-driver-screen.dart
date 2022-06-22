import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:scannerapp/Screens/passenger_model.dart';
import 'package:scannerapp/taxi/presentation/widgets/Payed_User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../api/api.dart';

class BusDriver extends StatefulWidget {
  const BusDriver({Key? key}) : super(key: key);

  @override
  State<BusDriver> createState() => _BusDriverState();
}

class _BusDriverState extends State<BusDriver> {
  Future<List<passenger>>? allPassengers;
  FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // getData() {
  //   setState(() {
  //     allPassengers = getAllpassenger();
  //   });
  // }

  void initState() {
    _fcm.getToken().then((values) {});
    getMessage();

    // getData();
    super.initState();
  }

  void getMessage() {
    FirebaseMessaging.onMessage.listen((event) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: Container(
            margin: EdgeInsets.all(14),
            alignment: Alignment.topLeft,
            child: Text(
              "Welcome Back\nDriver",
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800),
            ),
          )),
          // Expanded(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(
          //         "Passengers Count:",
          //         style: TextStyle(
          //             fontSize: 22, fontWeight: FontWeight.w400),
          //       ),
          //       Container(
          //         alignment: Alignment.center,
          //         margin: EdgeInsets.only(left: 20),
          //         height: 50,
          //         width: 50,
          //         decoration: BoxDecoration(
          //             color: Colors.white,
          //             border: Border.all(
          //                 color: Colors.black26, width: 1.7),
          //             borderRadius: BorderRadius.circular(8),
          //             boxShadow: [
          //               BoxShadow(
          //                 color: Colors.black26,
          //                 spreadRadius: 1,
          //                 blurRadius: 2,
          //                 offset: Offset(
          //                     0, 2), // changes position of shadow
          //               ),
          //             ]),
          //         child: Text(
          //           "${snapshot.data!.length}",
          //           style: TextStyle(
          //               fontWeight: FontWeight.w600, fontSize: 18),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black38, width: 1.7),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(1, 3), // changes position of shadow
                    ),
                  ]),
              child: FutureBuilder<List<passenger>>(
                  future: getAllpassenger(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return PayedUser(
                              index: index + 1,
                              name: snapshot.data![index].name,
                              time: snapshot.data![index].createdAt
                                  .toString()
                                  .split(".000")
                                  .first,
                            );
                          },
                        );
                    }
                  }),
            ),
          ),
          Expanded(
              child: TextButton(
            onPressed: () {},
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.red[800],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ]),
              child: Text(
                "PAY FOR PASSENGER",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )),
        ],
      )),
    );
  }

  Future<List<passenger>> getAllpassenger() async {
    //business logic to send data to server
    var data;
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var userJson = localStorage.getString('user');
    var user = json.decode(userJson.toString());

    if (user != null)
      data = {
        'bus_id': 2,
      };

    var response = await CallApi().postData(data, 'passengers');

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<passenger>((item) => passenger.fromJson(item)).toList();
    } else {
      throw Exception("Can't load hist");
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scannerapp/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'Screens/history_model.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late Future<List<hist>> history;
  void initState() {
    super.initState();

    setState(() {
      history = getAllhists();
    });
  }

  var tripIndex;
  DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 18, 65, 104),
        title: Text('My History'),
      ),
      body: FutureBuilder<List<hist>>(
        future: getAllhists(),
        builder: (context, snapshot) {
          return Column(
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 106, 161, 206),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(2, 4), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    margin:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.8.h),
                    height: 54.h,
                    child: SfCalendar(
                      onSelectionChanged: (CalendarSelectionDetails details) {
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          setState(() {
                            date = details.date!;
                          });
                        });
                      },
                      todayTextStyle: TextStyle(color: Colors.white),
                      todayHighlightColor: Colors.black,
                      selectionDecoration: BoxDecoration(
                          border: Border.all(
                              width: 2, color: Color.fromARGB(255, 0, 95, 173)),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12))),
                      view: CalendarView.month,
                      firstDayOfWeek: 6,
                      initialDisplayDate: DateTime.now(),
                      initialSelectedDate: DateTime.now(),
                      showNavigationArrow: true,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, i) {
                      return (date.toString().split(" ").first ==
                              snapshot.data![i].createdAt
                                  .toString()
                                  .split(" ")
                                  .first)
                          ? Card(
                              color: Color.fromARGB(214, 255, 255, 255),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 3,
                              shadowColor: Colors.black,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              child: ListTile(
                                contentPadding: EdgeInsets.only(bottom: 16),
                                title: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 11),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.directions_bus_outlined,
                                          color: Colors.red[900],
                                          size: 30,
                                        ),
                                        SizedBox(width: 22),
                                        Text(
                                          'Trip: ${snapshot.data![i].qr}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Icon(
                                      Icons.timer,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                    Text(
                                      snapshot.data![i].createdAt
                                          .toString()
                                          .split(".")
                                          .first,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(width: 130),
                                  ],
                                ),
                              ),
                            )
                          : Container();
                    }),
              )
            ],
          );
        },
      ),
    );
  }

  static Future<List<hist>> getAllhists() async {
    //business logic to send data to server
    var data;
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var userJson = localStorage.getString('user');
    var user = json.decode(userJson.toString());

    if (user != null)
      data = {
        'email': '${user['email']}',
      };
    var response = await CallApi().postData(data, 'history');

    if (response.statusCode == 200) {
      print(response.body);
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return parsed.map<hist>((item) => hist.fromJson(item)).toList();
    } else {
      throw Exception("Can't load hist");
    }
  }
}

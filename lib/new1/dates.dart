// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scannerapp/Screens/tripsModel.dart';
import 'package:scannerapp/new1/classes/whereto.dart';
import 'package:scannerapp/new1/widget/company.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api.dart';

// ignore: must_be_immutable
class Dates extends StatefulWidget {
  var date;
  // Function getDateRTrips;
  var datt;
  var place1;
  var place2;
  var datt1;
  var datt2;
  late WhereTo whrerTo;
  Dates(
      {this.date,
      // required this.getDateRTrips,
      this.datt,
      this.datt1,
      this.datt2,
      this.place1,
      this.place2,
      required this.whrerTo});

  @override
  _DatesState createState() => _DatesState();
}

class _DatesState extends State<Dates> with SingleTickerProviderStateMixin {
  late String start;
  late String destination;

  List<bool> trips = [];

  late TabController _tabController;

  late int difference;
  // prints something like 2019-12-10 10:02:22.287949 print(DateFormat('EEEE').format(date)); // prints Tuesday print(DateFormat('EEEE, d MMM, yyyy').format(date)); // prints Tuesday, 10 Dec, 2019 print(DateFormat('h:mm a').format(date));

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int selectedDate = 0;
  Future<List<trip>>? allTrips;
  getData(int date) {
    setState(() {
      allTrips = getTrips(start, destination, dateForm[date]);
    });
  }

  late var items;
  @override
  void initState() {
    start = widget.whrerTo.current;
    destination = widget.whrerTo.destination;

    DateTime startDate = DateTime.utc(widget.whrerTo.departing.year,
        widget.whrerTo.departing.month, widget.whrerTo.departing.day);

    DateTime endDate = DateTime.utc(widget.whrerTo.returning.year,
        widget.whrerTo.returning.month, widget.whrerTo.returning.day);

    int getDaysInbetween() {
      difference = endDate.difference(startDate).inDays;
      print("difference:${difference.abs()}");
      return difference + 1;
    }

    items = List<DateTime>.generate(getDaysInbetween(), (i) {
      DateTime date = startDate;
      return date.add(Duration(days: i));
    });

    _tabController =
        TabController(length: getDaysInbetween().abs(), vsync: this);
    _tabController.addListener(_handleTabSelection);
    List.generate(getDaysInbetween().abs(), (index) => trips.add(false));
    print(trips);

    super.initState();
  }

  _handleTabSelection() {
    setState(() {
      selectedDate = _tabController.index;
    });
  }

  List<String> dateForm = [];
  List<Widget> future = [];

  Widget build(BuildContext context) {
    // var inputFormat = DateFormat("yyyy-MM-dd HH:mm");
    // var inputDate = inputFormat.parse(widget.date);
    // var outoutForamt = DateFormat('dd/MM/yyyy hh:mm');
    // var outtputDate = outoutForamt.format(inputDate);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 18, 65, 104),
          bottom: new TabBar(
              labelPadding: EdgeInsets.symmetric(horizontal: 5),
              controller: _tabController,
              tabs: List.generate(difference.abs() + 1, (index) {
                dateForm.insert(
                    index,
                    DateFormat('yyyy-MM-dd-EE')
                        .format(items[index])
                        .toString());
                // dateForm.insert(
                //     index, DateFormat.yMd().format(items[index]).toString());

                // var tabDate = DateTime.utc(
                // items[index].year, items[index].month, items[index].day);
                // formattedDate(tabDate);
                return Container(
                    width: 200,
                    child: new Tab(
                      iconMargin: EdgeInsets.symmetric(horizontal: 300),
                      child: Align(
                        child: Text(' ${dateForm[index]}'),
                      ),
                    ));
              })),
        ),
        body: TabBarView(
            controller: _tabController,
            children: List.generate(
              difference.abs() + 1,
              (index) =>
                  // ignore: deprecated_member_use
                  // trips[index] == false
                  //     ? Center(
                  //         child: TextButton(
                  //             onPressed: () {
                  //               setState(() {
                  //                 trips[index] = !trips[index];
                  //                 getData();
                  //                 // getTrips(start, destination, dateForm[selectedDate]);
                  //               });
                  //             },
                  //             child: Text('See Trip')))
                  //     :
                  FutureBuilder<List<trip>>(
                      future:
                          getTrips(start, destination, dateForm[selectedDate]),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print(snapshot.data);
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data![0].myTrips.length,
                            itemBuilder: (context, index) {
                              print(
                                  snapshot.data![0].myTrips[index]['feature']);
                              return listy(
                                whereTo: widget.whrerTo,
                                time: snapshot.data![0].myTrips[index]['time'],
                                companyName: snapshot.data![0].myTrips[index]
                                    ['feature']['company_name'],
                                chargeMobil: snapshot.data![0].myTrips[index]
                                    ['feature']["mobile_charger"],
                                condition: snapshot.data![0].myTrips[index]
                                    ['feature']["condition"],
                                wifi: snapshot.data![0].myTrips[index]
                                    ['feature']["wifi"],
                                price: snapshot.data![0].myTrips[index]
                                    ['feature']["price"],
                                depStation: snapshot.data![0].myTrips[index]
                                    ["locations"]["depart_station"],
                                returnStation: snapshot.data![0].myTrips[index]
                                    ["locations"]["arrival_station"],
                                reservedSeats: snapshot.data![0]
                                    .myTrips[index]["reservations"].length,
                                bus_id: snapshot.data![0].myTrips[index]
                                    ['bus_id'],
                                trip_id: snapshot.data![0].myTrips[index]['id'],
                              );
                            },
                          );
                        } else {
                          print(snapshot.error);
                          return Center(
                            // child: Text("${snapshot.error}"),
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
            )));
  }
}

Future<List<trip>> getTrips(
    String start, String destination, String date) async {
  //business logic to send data to server
  var data;
  SharedPreferences localStorage = await SharedPreferences.getInstance();

  var userJson = localStorage.getString('user');
  var user = json.decode(userJson.toString());
  print(user);
  print(start);
  print(destination);
  print(date);

  if (user != null)
    data = {
      'date': date,
      'depart': destination,
      'arrival': start,
    };
  print("data:${data}");

  var response = await CallApi().postData(data, 'index');
  print("/:${response.statusCode}");
  if (response.statusCode == 200) {
    print(response.statusCode);
    // print('res=${json.decode(response.body)}');
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

    return parsed.map<trip>((item) => trip.fromJson(item)).toList();
  } else {
    throw Exception("Can't load hist");
  }
}

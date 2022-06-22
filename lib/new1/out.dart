// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scannerapp/Screens/seats.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api.dart';

class Out extends StatefulWidget {
  var bus_id;
  var trip_id;
  var price;
  bool iconColorA = false;
  bool iconColorB = false;
  bool iconColorC = false;
  bool iconColorD = false;
  bool iconColorH = false;
  Color colorH = Color.fromARGB(255, 240, 236, 236);

  List seatNumber = [];
  Out({
    required this.bus_id,
    required this.trip_id,
    required this.price,
  });

  @override
  State<Out> createState() => _OutState();
}

class _OutState extends State<Out> {
  Future<List<seatsModel>>? allSeats;
  getData() {
    setState(() {
      allSeats = getReservedSeat();
    });
  }

  creatdialog(String x, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            content: Builder(builder: (context) {
              return Container(
                  width: MediaQuery.of(context).size.width - 350,
                  child: Text("$x"));
            }),
          );
        });
  }

  @override
  void initState() {
    getData();
    List.generate(10, (index) {
      colorsA.insert(index, Color.fromARGB(255, 240, 236, 236));
      colorsB.insert(index, Color.fromARGB(255, 240, 236, 236));
      colorsC.insert(index, Color.fromARGB(255, 240, 236, 236));
      colorsD.insert(index, Color.fromARGB(255, 240, 236, 236));
    });

    super.initState();
  }

  List seatsA = ['', '', '', '', '', '', '', '', '', ''];
  List seatsB = ['', '', '', '', '', '', '', '', '', ''];
  List seatsC = ['', '', '', '', '', '', '', '', '', ''];
  List seatsD = ['', '', '', '', '', '', '', '', '', ''];
  List seatsH = ['', '', '', '', '', '', '', '', '', ''];
  List<Color> colorsA = [];
  List<Color> colorsB = [];
  List<Color> colorsC = [];
  List<Color> colorsD = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 18, 65, 104),
        title: Text("OUTBOUND TRIP"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<seatsModel>>(
            // future: getTrips(start, destination, dateForm[index]),
            future: allSeats,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List.generate(snapshot.data!.length, (index) {
                  final containsA = snapshot.data![index].myseat.contains('A');
                  final containsB = snapshot.data![index].myseat.contains('B');
                  final containsD = snapshot.data![index].myseat.contains('D');
                  final containsC = snapshot.data![index].myseat.contains('C');
                  final containsH = snapshot.data![index].myseat.contains('H');

                  if (containsA) {
                    //
                    seatsA.insert(index, snapshot.data![index].myseat);

                    print('seatsA= $seatsA');
                  } else if (containsB) {
                    //
                    seatsB.insert(index, snapshot.data![index].myseat);
                    print('seatsB= $seatsB');
                  } else if (containsD) {
                    //
                    seatsD.insert(index, snapshot.data![index].myseat);
                    print('seatsD= $seatsD');
                  } else if (containsC) {
                    //
                    seatsC.insert(index, snapshot.data![index].myseat);
                    print('seatsC= $seatsC');
                  } else if (containsH) {
                    //
                    seatsH.insert(index, snapshot.data![index].myseat);
                    print('seatsH= $seatsH');
                  }
                });

                print(snapshot.data);
                return Center(
                  child: Column(children: [
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            border: Border.all(width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        width: 100,
                        height: 50,
                        child: Expanded(
                            child: Text(
                          "confarm",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
                      ),
                      onPressed: () => reserveSeat(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 350,
                      height: 850,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          border: Border.all(width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.personal_injury,
                              size: 90,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "A",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              final containsIndex =
                                                  seatsA.contains('$index');

                                              return Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 8),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    InkWell(
                                                        child: Icon(
                                                          Icons
                                                              .call_to_action_sharp,
                                                          size: 60,
                                                          color: seatsA.contains(
                                                                  'A${index + 1}')
                                                              ? colorsA[index] =
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          194,
                                                                          30,
                                                                          18)
                                                              : colorsA[index],
                                                        ),
                                                        // creatdialog("B$index", context),

                                                        onTap: () {
                                                          setState(() {
                                                            widget.iconColorA =
                                                                !widget
                                                                    .iconColorA;

                                                            if (widget.iconColorA ==
                                                                    false &&
                                                                widget
                                                                    .seatNumber
                                                                    .contains(
                                                                        'A${index + 1}')) {
                                                              colorsA[index] =
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          240,
                                                                          236,
                                                                          236);

                                                              widget.seatNumber
                                                                  .removeWhere(
                                                                      (element) =>
                                                                          element ==
                                                                          'A${index + 1}');
                                                              print(
                                                                  'seatNumber=${widget.seatNumber}');
                                                            } else {
                                                              colorsA[index] =
                                                                  Colors.green;
                                                              widget.seatNumber.add(
                                                                  'A${index + 1}');
                                                              print(
                                                                  'seatNumber=${widget.seatNumber}');
                                                            }
                                                          });
                                                        }),
                                                    Center(
                                                      child: Text(
                                                        'A${index + 1}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            itemCount: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "B",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) =>
                                                Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 8),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  InkWell(
                                                      child: Icon(
                                                        Icons
                                                            .call_to_action_sharp,
                                                        size: 60,
                                                        color: seatsB.contains(
                                                                'B${index + 1}')
                                                            ? colorsB[index] =
                                                                Color.fromARGB(
                                                                    255,
                                                                    194,
                                                                    30,
                                                                    18)
                                                            : colorsB[index],
                                                      ),
                                                      // creatdialog("B$index", context),

                                                      onTap: () {
                                                        setState(() {
                                                          widget.iconColorB =
                                                              !widget
                                                                  .iconColorB;

                                                          if (widget.iconColorB ==
                                                                  false &&
                                                              widget.seatNumber
                                                                  .contains(
                                                                      'B${index + 1}')) {
                                                            colorsB[index] =
                                                                Color.fromARGB(
                                                                    255,
                                                                    240,
                                                                    236,
                                                                    236);

                                                            widget.seatNumber
                                                                .removeWhere(
                                                                    (element) =>
                                                                        element ==
                                                                        'B${index + 1}');

                                                            print(
                                                                'seatNumber=${widget.seatNumber}');
                                                          } else {
                                                            colorsB[index] =
                                                                Colors.green;
                                                            widget.seatNumber.add(
                                                                'B${index + 1}');
                                                            print(
                                                                'seatNumber=${widget.seatNumber}');
                                                          }
                                                        });
                                                      }),
                                                  Center(
                                                    child: Text(
                                                      'B${index + 1}',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            itemCount: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Icon(Icons.arrow_upward_rounded),
                                        Expanded(
                                          child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) =>
                                                Center(
                                                    child: index + 1 == 10
                                                        ? Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              InkWell(
                                                                  child: Icon(
                                                                      Icons
                                                                          .call_to_action_sharp,
                                                                      size: 60,
                                                                      color: seatsH.contains(
                                                                              'H')
                                                                          ? widget.colorH = Color.fromARGB(
                                                                              255,
                                                                              194,
                                                                              30,
                                                                              18)
                                                                          : widget
                                                                              .colorH),
                                                                  // creatdialog("B$index", context),

                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      widget.iconColorH =
                                                                          !widget
                                                                              .iconColorH;

                                                                      if (widget.iconColorH ==
                                                                              false &&
                                                                          widget
                                                                              .seatNumber
                                                                              .contains('H')) {
                                                                        widget.colorH = Color.fromARGB(
                                                                            255,
                                                                            240,
                                                                            236,
                                                                            236);

                                                                        widget.seatNumber.removeWhere((element) =>
                                                                            element ==
                                                                            'H');
                                                                      } else {
                                                                        widget.colorH =
                                                                            Colors.green;
                                                                        widget
                                                                            .seatNumber
                                                                            .add('H');
                                                                      }
                                                                    });
                                                                  }),
                                                              Center(
                                                                child: Text(
                                                                  'H',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Column(
                                                            children: [
                                                              Text(
                                                                "${index + 1}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    index + 1 ==
                                                                            9
                                                                        ? 22
                                                                        : 47,
                                                              )
                                                            ],
                                                          )),
                                            itemCount: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(children: [
                                      Text(
                                        "C",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 8),
                                              child: (index == 6)
                                                  ? Icon(
                                                      Icons
                                                          .calendar_view_week_outlined,
                                                      size: 60,
                                                    )
                                                  : Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        InkWell(
                                                            child: Icon(
                                                              Icons
                                                                  .call_to_action_sharp,
                                                              size: 60,
                                                              color: seatsC
                                                                      .contains(
                                                                          'C${index + 1}')
                                                                  ? colorsC[
                                                                          index] =
                                                                      Color.fromARGB(
                                                                          255,
                                                                          194,
                                                                          30,
                                                                          18)
                                                                  : colorsC[
                                                                      index],
                                                            ),
                                                            // creatdialog("B$index", context),

                                                            onTap: () {
                                                              setState(() {
                                                                widget.iconColorC =
                                                                    !widget
                                                                        .iconColorC;

                                                                if (widget.iconColorC ==
                                                                        false &&
                                                                    widget
                                                                        .seatNumber
                                                                        .contains(
                                                                            'C${index + 1}')) {
                                                                  colorsC[index] =
                                                                      Color.fromARGB(
                                                                          255,
                                                                          240,
                                                                          236,
                                                                          236);

                                                                  widget.seatNumber.removeWhere(
                                                                      (element) =>
                                                                          element ==
                                                                          'C${index + 1}');
                                                                  print(
                                                                      'seatNumber=${widget.seatNumber}');
                                                                } else {
                                                                  colorsC[index] =
                                                                      Colors
                                                                          .green;
                                                                  widget
                                                                      .seatNumber
                                                                      .add(
                                                                          'C${index + 1}');
                                                                  print(
                                                                      'seatNumber=${widget.seatNumber}');
                                                                }
                                                              });
                                                            }),
                                                        Center(
                                                          child: Text(
                                                            'C${index + 1}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            );
                                          },
                                          itemCount: 10,
                                        ),
                                      ),
                                    ]),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "D",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) =>
                                                Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 8),
                                              child: (index == 6)
                                                  ? Container(
                                                      height: 60,
                                                      width: 400,
                                                      child: Icon(
                                                        Icons
                                                            .calendar_view_week_outlined,
                                                        size: 60,
                                                      ),
                                                    )
                                                  : Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        InkWell(
                                                            child: Icon(
                                                              Icons
                                                                  .call_to_action_sharp,
                                                              size: 60,
                                                              color: seatsD
                                                                      .contains(
                                                                          'D${index + 1}')
                                                                  ? colorsD[
                                                                          index] =
                                                                      Color.fromARGB(
                                                                          255,
                                                                          194,
                                                                          30,
                                                                          18)
                                                                  : colorsD[
                                                                      index],
                                                            ),
                                                            // creatdialog("B$index", context),

                                                            onTap: () {
                                                              setState(() {
                                                                widget.iconColorD =
                                                                    !widget
                                                                        .iconColorD;

                                                                if (widget.iconColorD ==
                                                                        false &&
                                                                    widget
                                                                        .seatNumber
                                                                        .contains(
                                                                            'D${index + 1}')) {
                                                                  colorsD[index] =
                                                                      Color.fromARGB(
                                                                          255,
                                                                          240,
                                                                          236,
                                                                          236);

                                                                  widget.seatNumber.removeWhere(
                                                                      (element) =>
                                                                          element ==
                                                                          'D${index + 1}');
                                                                  print(
                                                                      'seatNumber=${widget.seatNumber}');
                                                                } else {
                                                                  colorsD[index] =
                                                                      Colors
                                                                          .green;
                                                                  widget
                                                                      .seatNumber
                                                                      .add(
                                                                          'D${index + 1}');
                                                                  print(
                                                                      'seatNumber=${widget.seatNumber}');
                                                                }
                                                              });
                                                            }),
                                                        Center(
                                                          child: Text(
                                                            'D${index + 1}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            ),
                                            itemCount: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                );
              } else {
                print(snapshot.error);
                return Center(
                  // child: Text("${snapshot.error}"),
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  Future<List<seatsModel>> getReservedSeat() async {
    var data;
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var userJson = localStorage.getString('user');
    var user = json.decode(userJson.toString());

    if (user != null)
      data = {
        'bus_id': widget.bus_id,
        'trip_id': widget.trip_id,
      };

    var response = await CallApi().postData(data, 'show');
    print("status=${response.statusCode}");
    if (response.statusCode == 200) {
      print('res=${json.decode(response.body)}');
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return parsed
          .map<seatsModel>((item) => seatsModel.fromJson(item))
          .toList();
    } else {
      throw Exception("Can't load hist");
    }
  }

  reserveSeat() async {
    var data;
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var userJson = localStorage.getString('user');
    var user = json.decode(userJson.toString());

    if (user != null)
      data = {
        'bus_id': widget.bus_id,
        'trip_id': widget.trip_id,
        'seat_number': widget.seatNumber,
        'email': user['email']
      };
    print("ddat=$data");

    var response = await CallApi().postData(data, 'update');
    print("status=${response.statusCode}");
    if (response.statusCode == 200) {
      print("status=${response.statusCode}");
      print('res=${json.decode(response.body)}');
    } else {
      throw Exception("Can't load hist");
    }
  }
}

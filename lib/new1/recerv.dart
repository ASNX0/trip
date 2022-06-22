// ignore: todo
// TODO Implement this library.// TODO Implement this library.// TODO Implement this library.// TODO Implement this library.
// ignore: todo
// TODO Implement this library.import 'package:flutter/material.dart';

// ignore: unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scannerapp/logging/qr.dart';
import 'package:scannerapp/new1/classes/whereto.dart';
import 'package:scannerapp/new1/out.dart';

class Reserv extends StatefulWidget {
  WhereTo whereTo;
  var place1;
  var place2;
  var datt1;
  var datt2;
  int trip_id;
  int bus_id;
  int price;

  Reserv(
      {required this.whereTo,
      this.place1,
      this.place2,
      this.datt1,
      this.datt2,
      required this.bus_id,
      required this.trip_id,
      required this.price});

  @override
  _ReservState createState() => _ReservState();
}

class _ReservState extends State<Reserv> {
  var val;
  late int _newvalue;

  get newvalue => _newvalue;

  set newvalue(newvalue) {
    _newvalue = newvalue;
  }

  bool value1 = false;
  bool value2 = false;

  @override
  build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(children: [
          Row(children: [
            Container(
              width: 300,
              child: ListTile(
                title: Text('seat reservation',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                leading: Icon(Icons.airline_seat_recline_normal),
                subtitle: Text("from 2000p(one way)"),
              ),
            ),
            IconButton(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Out(
                                bus_id: widget.bus_id,
                                trip_id: widget.trip_id,
                                price: widget.price,
                              )),
                    ),
                icon: Icon(Icons.arrow_forward_ios)),

            // ignore: deprecated_member_use
          ]),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50),
            child: Divider(
              thickness: 2,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SwitchListTile(
            onChanged: (value) => setState(() {
              value1 = value;
            }),
            value: value1,
            title: Text("SMS aleart"),
            subtitle: Text(
                "used only to contact you in case of delays or itinerary changes"),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: Divider(
              thickness: 2,
            ),
          ),
          ListTile(
            title: Text('Payment by the token:',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            subtitle: Text("point your phone to the qrCode"),
          ),
          Row(
            children: [
              Expanded(
                child: Column(children: [
                  // ignore: deprecated_member_use

                  RadioListTile(
                      value: 1,
                      groupValue: val,
                      onChanged: (newvalue) {
                        setState(() {
                          val = newvalue;
                        });
                      },
                      title: Text('daliy')),
                  RadioListTile(
                    value: 2,
                    groupValue: val,
                    onChanged: (newvalue) {
                      setState(() {
                        val = newvalue;
                      });
                    },
                    title: Text('weekly'),
                  ),
                ]),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 40, top: 10),
                      child: Image.asset(
                        "images/images.png",
                        height: 200,
                        width: 200,
                      ),
                    ),
                    Container(
                      width: 80,
                      color: Color.fromARGB(255, 238, 233, 233),
                      child: IconButton(
                          onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      QRViewExample(),
                                ),
                              ),
                          icon: Icon(Icons.qr_code_2_sharp,
                              color: Color.fromARGB(255, 62, 226, 147))),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          SwitchListTile(
            onChanged: (value) => setState(() {
              value2 = value;
            }),
            value: value2,
            title: Text("Save your data for faster reach in the future"),
          ),
        ]));
  }
}

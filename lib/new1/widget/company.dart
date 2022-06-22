import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scannerapp/new1/classes/whereto.dart';

import '../recerv.dart';

class listy extends StatefulWidget {
  late WhereTo whereTo;

  //////
  String time;
  String companyName;
  int wifi;
  int chargeMobil;
  int condition;
  int price;
  String depStation;
  String returnStation;
  int reservedSeats;
  int bus_id;
  int trip_id;

  listy(
      {Key? key,
      required this.time,
      required this.bus_id,
      required this.trip_id,
      required this.companyName,
      required this.whereTo,
      required this.chargeMobil,
      required this.condition,
      required this.wifi,
      required this.price,
      required this.depStation,
      required this.returnStation,
      required this.reservedSeats})
      : super(key: key);

  @override
  _listyState createState() => _listyState();
}

class _listyState extends State<listy> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: 240,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(40)),
          border: Border.all(color: Colors.white, width: 5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text('Time: ${widget.time}'),
            Text('Comapany: ${widget.companyName}'),
            Container(
              margin: EdgeInsets.only(top: 14),
              child: Divider(
                color: Colors.green,
                thickness: 1,
              ),
            ),
            Container(
                child:
                    Text('${widget.depStation} -> ${widget.returnStation} ')),
            Container(child: Text('Bus Number: ${widget.bus_id}')),
            Container(
              margin: EdgeInsets.only(left: 220),
              child: Row(
                children: [
                  Text("${widget.price}",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 2.5)),
                  IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        size: 45,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Reserv(
                                      trip_id: widget.trip_id,
                                      bus_id: widget.bus_id,
                                      whereTo: widget.whereTo,
                                      price: widget.price,
                                    )));
                      })
                ],
              ),
            ),
            Row(
              children: [
                Text(' 10hr 50min'),
                Row(
                  children: [
                    Icon(Icons.people_rounded),
                    Text(': ${widget.reservedSeats}/41'),
                  ],
                ),
                Icon(Icons.wifi,
                    color: widget.wifi == 1 ? Colors.green : Colors.black12),
                Icon(
                  Icons.charging_station_rounded,
                  color:
                      widget.chargeMobil == 1 ? Colors.green : Colors.black12,
                ),
                Icon(
                  Icons.air,
                  color: widget.condition == 1 ? Colors.green : Colors.black12,
                ),
              ],
            )
          ],
        ));
  }
}

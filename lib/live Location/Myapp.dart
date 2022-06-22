// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../logging/handleAccount.dart';
import 'mymap.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  var userData;
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _requestPermission();
    location.changeSettings(interval: 10, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');

    var user = json.decode(userJson.toString());
    setState(() {
      userData = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 18, 65, 104),
        title: Text('live location tracker'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 142, 190, 214),
                borderRadius: BorderRadius.circular(70)),
            child: TextButton(
                onPressed: () => Account.logout(context),
                child: Text(
                  'logout',
                  style: TextStyle(color: Colors.white),
                )),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 142, 190, 214),
                borderRadius: BorderRadius.circular(70)),
            child: TextButton(
                onPressed: () {
                  _postLocation();
                },
                child: Text(
                  'add my location',
                  style: TextStyle(color: Colors.white),
                )),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 40, horizontal: 120),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                RaisedButton.icon(
                  label: Text("Go Online"),
                  icon: Icon(
                    Icons.my_location,
                    size: 32,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _listenLocation();
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(6),
            decoration:
                BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            child: IconButton(
              onPressed: () {
                _stopListening();
              },
              icon: Icon(Icons.stop_circle_outlined),
              color: Colors.white,
            ),
          ),
          Expanded(
              child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('location').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title:
                          Text(snapshot.data!.docs[index]['name'].toString()),
                      subtitle: Row(
                        children: [
                          Text(snapshot.data!.docs[index]['latitude']
                              .toString()),
                          SizedBox(
                            width: 20,
                          ),
                          Text(snapshot.data!.docs[index]['longitude']
                              .toString()),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.directions),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  MyMap(snapshot.data!.docs[index].id)));
                        },
                      ),
                    );
                  });
            },
          )),
        ],
      ),
    );
  }

  // بحط الموقع تبعي بقلب الفايربيز
  _postLocation() async {
    if (userData != null) {
      try {
        final loc.LocationData _locationResult = await location.getLocation();

        await FirebaseFirestore.instance
            .collection('location')
            .doc('${userData['email']}')
            .set({
          'latitude': _locationResult.latitude,
          'longitude': _locationResult.longitude,
          'name': '${userData['name']}',
        }, SetOptions(merge: true));
      } catch (e) {
        print(e);
      }
    }
  }

  // ignore: unused_element

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance
          .collection('location')
          .doc('${userData['email']}')
          .set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'name': '${userData['name']}',
        'angle': currentlocation.heading,
      }, SetOptions(merge: true));
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}

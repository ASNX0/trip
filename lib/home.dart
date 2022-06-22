// ignore_for_file: file_names, unnecessary_new, prefer_const_constructors, deprecated_member_use, prefer_typing_uninitialized_variables, invalid_use_of_visible_for_testing_member, avoid_print, use_key_in_widget_constructors, camel_case_types

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scannerapp/histroy.dart';
import 'package:scannerapp/logging/handleAccount.dart';
import 'package:scannerapp/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart' as loc;
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentAdress = 'My Adress';

  var userData;
  String qrCode = 'Unknown';

  @override
  void initState() {
    _getUserInfo();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(platform: TargetPlatform.android),
            "assets/bus.png")
        .then((onValue) {
      carIcon = onValue;
    });
    getMarkerData();

    current();

    super.initState();
  }

  late BitmapDescriptor carIcon;
  late loc.LocationData currentloc;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<Marker> customMarkers = [];

  initMarker(specifyla, specifylo, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      icon: carIcon,
      rotation: currentloc.heading!,
      markerId: markerId,
      position: LatLng(specifyla, specifylo),
      infoWindow: InfoWindow(title: "title"),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('location');
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        FirebaseFirestore.instance
            .collection('location')
            .get()
            .then((myMarkers) {
          if (myMarkers.docs.isNotEmpty) {
            for (int i = 0; i < myMarkers.docs.length; i++) {
              initMarker(
                myMarkers.docs[i].data()['latitude'],
                myMarkers.docs[i].data()['longitude'],
                myMarkers.docs[i].id,
              );
            }
          }
        });
      });
    });
  }

  double latit = 0;
  double longit = 0;
  final loc.Location location = loc.Location();

  late GoogleMapController _controller;
  bool _added = false;

  void _setMapStyle() async {
    String style = await DefaultAssetBundle.of(context)
        .loadString("assets/map_Style.json");
    _controller.setMapStyle(style);
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
        title: Text("Google Map"),
      ),
      drawer: Drawer(
        child: Material(
          color: Color.fromARGB(255, 18, 65, 104),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 5.h, right: 2.w),
                child: Icon(
                  Icons.person_pin,
                  size: 80.sp,
                  color: Colors.white,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 3.h, bottom: 3.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Name:  ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userData != null ? '${userData['name']}' : '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.7.h),
                    Row(
                      children: [
                        Text(
                          "Email:   ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userData != null ? '${userData['email']}' : '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.white,
                thickness: 1,
              ),
              drawrlist(
                  icon: Icons.bus_alert,
                  text: "Reserve",
                  ontap: Account.logout),
              drawrlist(
                icon: Icons.departure_board,
                text: "Trips",
                ontap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => History(),
                  ),
                ),
              ),
              drawrlist(
                icon: Icons.airplane_ticket_rounded,
                text: "Buy Tickets",
                ontap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => payment(
                      search: (lati, longi) {
                        setState(() {
                          var markerIdVal = "ids";
                          final MarkerId markerId = MarkerId(markerIdVal);

                          // creating a new MARKER
                          final Marker marker = Marker(
                            icon: BitmapDescriptor.defaultMarker,
                            markerId: markerId,
                            position: LatLng(lati, longi),
                            infoWindow:
                                InfoWindow(title: markerIdVal, snippet: '*'),
                          );
                          markers[markerId] = marker;
                        });

                        print("Lat= $lati : long=$longi");
                      },
                    ),
                  ),
                ),
              ),
              drawrlist(
                icon: Icons.departure_board,
                text: "Taxi",
                ontap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => History(),
                  ),
                ),
              ),
              drawrlist(
                icon: Icons.logout,
                text: "Log Out",
                ontap: () => Account.logout(context),
              ),
              Divider(color: Colors.white, thickness: 1),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('location')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (_added) {
                    mymap(snapshot);
                  }
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return GoogleMap(
                    myLocationEnabled: true,
                    mapType: MapType.normal,
                    zoomControlsEnabled: true,
                    markers: Set<Marker>.of(markers.values),
                    // BitmapDescriptor.defaultMarkerWithHue(
                    //     BitmapDescriptor.hueMagenta)),

                    initialCameraPosition: CameraPosition(
                        target: LatLng(currentloc.latitude!.toDouble(),
                            currentloc.longitude!.toDouble()
                            // snapshot.data!.docs.singleWhere((element) =>
                            //     element.id == widget.user_id)['latitude'],
                            // snapshot.data!.docs.singleWhere((element) =>
                            //     element.id == widget.user_id)['longitude'],
                            ),
                        zoom: 15.47),
                    onMapCreated: (GoogleMapController controller) async {
                      setState(() {
                        _controller = controller;
                        _added = true;
                      });
                    },
                  );
                },
              )),
        ],
      ),
    );
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(currentloc.latitude!.toDouble(),
                currentloc.longitude!.toDouble()
                // snapshot.data!.docs.singleWhere(
                //     (element) => element.id == widget.user_id)['latitude'],
                // snapshot.data!.docs.singleWhere(
                //     (element) => element.id == widget.user_id)['longitude'],
                ),
            zoom: 16.47)));
  }

  current() async {
    await location.onLocationChanged.listen((event) {
      setState(() {
        currentloc = event;
      });
    });
  }
}
// void p() async {
//   Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high);
//   print(position);
// }

// Future serach() async {
//   // String? localeIdentifier = "eg. en_US";
//   // final query = "syria";
//   // List<Location> addresses = await GeocodingPlatform.instance
//   //     .locationFromAddress(query, localeIdentifier: localeIdentifier);
//   // var first = addresses.first;
//   // print("${first.latitude} : ${first.longitude}");
//   List<Location> locations =
//       await locationFromAddress("Al Baramkeh, Damascus");
//   print(locations);
//   return locations;
// }

class drawrlist extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function ontap;

  const drawrlist(
      {required this.icon, required this.text, required this.ontap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
      leading: Icon(icon, color: Colors.white, size: 25.sp),
      title: Text(text, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
      onTap: () {
        ontap();
      },
    );
  }
}

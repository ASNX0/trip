// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class MyMap extends StatefulWidget {
  final String user_id;
  MyMap(this.user_id);
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late BitmapDescriptor carIcon;
  late loc.LocationData currentloc;
  // ...........................................................................
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
// .............................................................................
// رسم الماركر
  initMarker(specifyla, specifylo, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      icon: carIcon,
      rotation: currentloc.heading!,
      markerId: markerId,
      position: LatLng(specifyla, specifylo),
      infoWindow: InfoWindow(title: "driver car "),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  // حط الماركر حسب القيمة يلي بقلب اللفايربيز
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

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(platform: TargetPlatform.android),
            "assets/car_topview4.png")
        .then((onValue) {
      carIcon = onValue;
    });
    getMarkerData();

    current();
    super.initState();
  }

  final loc.Location location = loc.Location();

  late GoogleMapController _controller;
  bool _added = false;

  void _setMapStyle() async {
    String style = await DefaultAssetBundle.of(context)
        .loadString("assets/map_Style.json");
    _controller.setMapStyle(style);
  }

  @override
  Widget build(BuildContext context) {
    // _setMapStyle();
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection('location').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (_added) {
          mymap(snapshot);
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return GoogleMap(
          mapType: MapType.normal,
          zoomControlsEnabled: true,
          markers: Set<Marker>.of(markers.values),
          // BitmapDescriptor.defaultMarkerWithHue(
          //     BitmapDescriptor.hueMagenta)),

          initialCameraPosition: CameraPosition(
              target: LatLng(
                snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.user_id)['latitude'],
                snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.user_id)['longitude'],
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
    ));
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['latitude'],
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['longitude'],
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

// ignore: camel_case_types
class drawrlist extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function ontap;

  const drawrlist(
      {required this.icon, required this.text, required this.ontap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      leading: Icon(icon, color: Colors.white, size: 30),
      title: Text(text, style: TextStyle(color: Colors.white, fontSize: 20)),
      onTap: () {
        ontap();
      },
    );
  }
}

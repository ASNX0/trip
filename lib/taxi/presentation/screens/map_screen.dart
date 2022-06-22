import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:scannerapp/taxi/business_logic/cubit/maps/maps_cubit.dart';
import 'package:scannerapp/taxi/constnats/my_colors.dart';
import 'package:scannerapp/taxi/data/models/Place_suggestion.dart';
import 'package:scannerapp/taxi/data/models/place.dart';
import 'package:scannerapp/taxi/data/models/place_directions.dart';
import 'package:scannerapp/taxi/helpers/location_helper.dart';
import 'package:scannerapp/taxi/presentation/widgets/distance_and_time.dart';
import 'package:scannerapp/taxi/presentation/widgets/my_drawer.dart';
import 'package:scannerapp/taxi/presentation/widgets/place_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class MapScreen extends StatefulWidget {
  //final String user_id;
  const MapScreen();

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late BitmapDescriptor carIcon;
  late loc.LocationData currentloc;
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  var userData;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<PlaceSuggestion> places = [];
  FloatingSearchBarController controller = FloatingSearchBarController();
  static Position? position;
  Completer<GoogleMapController> _mapController = Completer();
// المكان تبعي على الخريطة
  static final CameraPosition _myCurrentLocationCameraPosition = CameraPosition(
    bearing: 0.0,
    target: LatLng(position!.latitude, position!.longitude),
    tilt: 0.0,
    zoom: 17,
  );

  // these variables for getPlaceLocation
  // Set<Marker> markers = Set();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late PlaceSuggestion placeSuggestion;
  late Place selectedPlace;
  late Marker searchedPlaceMarker;
  late Marker currentLocationMarker;
  late CameraPosition goToSearchedForPlace;
// المكان يلي نقيتو

  // these variables for getDirections
  PlaceDirections? placeDirections;
  var progressIndicator = false;
  late List<LatLng> polylinePoints;
  var isSearchedPlaceMarkerClicked = false;
  var isTimeAndDistanceVisible = false;
  late String time;
  late String distance;

  @override
  initState() {
    super.initState();
    getMyCurrentLocation();
    current();
    _getUserInfo();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
    _goToMyCurrentLocation();
    _listenLocationcurrent();
  }

  Future<void> getMyCurrentLocation() async {
    position = await LocationHelper.getCurrentLocation().whenComplete(() {
      setState(() {});
    });
  }

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(markers.values),
      initialCameraPosition: _myCurrentLocationCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
      // .......................................................................

      // .......................................................................
      polylines: placeDirections != null
          ? {
              Polyline(
                polylineId: const PolylineId('my_polyline'),
                color: Colors.black,
                width: 2,
                points: polylinePoints,
              ),
            }
          : {},
    );
  }

// on press flotingactionbutton animatecamera
// يعني لما بكبس الزر لح تتحرك الكميرا عالكوقع تبعي
  Future<void> _goToMyCurrentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_myCurrentLocationCameraPosition));
    getMarkercurrentData();
    _getLocationcurrent();
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      key: _formKey,
      controller: controller,
      elevation: 6,
      hintStyle: TextStyle(fontSize: 18),
      queryStyle: TextStyle(fontSize: 18),
      hint: 'Find a place..',
      border: BorderSide(style: BorderStyle.none),
      margins: EdgeInsets.fromLTRB(20, 70, 20, 0),
      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
      height: 52,
      iconColor: MyColors.blue,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 600),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      progress: progressIndicator,
      onQueryChanged: (query) {
        getPlacesSuggestions(query);
      },
      onFocusChanged: (_) {
        // hide distance and time row
        setState(() {
          isTimeAndDistanceVisible = false;
        });
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
              icon: Icon(Icons.place, color: Colors.yellow.withOpacity(0.6)),
              onPressed: () {
                //     _getLocation();
                _getLocationchose();
              }),
        ),
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
              icon: Icon(Icons.place, color: Colors.red.withOpacity(0.6)),
              onPressed: () {
                //     _listenLocation();
              }),
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildSuggestionsBloc(),
              buildSelectedPlaceLocationBloc(),
              buildDiretionsBloc(),
            ],
          ),
        );
      },
    );
  }

  Widget buildDiretionsBloc() {
    return BlocListener<MapsCubit, MapsState>(
      listener: (context, state) {
        if (state is DirectionsLoaded) {
          placeDirections = (state).placeDirections;

          getPolylinePoints();
        }
      },
      child: Container(),
    );
  }

  void getPolylinePoints() {
    polylinePoints = placeDirections!.polylinePoints
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList();
  }

  Widget buildSelectedPlaceLocationBloc() {
    return BlocListener<MapsCubit, MapsState>(
      listener: (context, state) {
        if (state is PlaceLocationLoaded) {
          selectedPlace = (state).place;
          goToMySearchedForLocation();
          getDirections();
        }
      },
      child: Container(),
    );
  }

  void getDirections() {
    BlocProvider.of<MapsCubit>(context).emitPlaceDirections(
      LatLng(position!.latitude, position!.longitude),
      LatLng(selectedPlace.result.geometry.location.lat,
          selectedPlace.result.geometry.location.lng),
    );
  }

// لمكان يلي نقيتو
  void buildCameraNewPosition() {
    goToSearchedForPlace = CameraPosition(
      bearing: 0.0,
      tilt: 0.0,
      target: LatLng(
        selectedPlace.result.geometry.location.lat,
        selectedPlace.result.geometry.location.lng,
      ),
      zoom: 13,
    );
  }

  // لما بختار المكان من اليست بياخدني لهنيك و بيعمل ابديت للكميرا و بيحط ماركر
  Future<void> goToMySearchedForLocation() async {
    buildCameraNewPosition();
    final GoogleMapController controller = await _mapController.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(goToSearchedForPlace));
    // buildSearchedPlaceMarker();
    getMarkerDatachoose();
    _getLocationchose();
    // _listenLocationchose();
  }

  // ......................................................................................................................
  Future<void> _goToMyCurrentLocationandaddmarker() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_myCurrentLocationCameraPosition));
    getMarkercurrentData();
    // _getLocationcurrent();
  }

  // رسم الماركر محل ما اخترت المكان
  // void buildSearchedPlaceMarker() {
  //   searchedPlaceMarker = Marker(
  //     position: goToSearchedForPlace.target,
  //     markerId: MarkerId('1'),
  //     onTap: () {
  //       buildCurrentLocationMarker();
  //       // show time and distance
  //       setState(() {
  //         isSearchedPlaceMarkerClicked = true;
  //         isTimeAndDistanceVisible = true;
  //       });
  //     },
  //     infoWindow: InfoWindow(title: "${placeSuggestion.description}"),
  //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //   );

  //   addMarkerToMarkersAndUpdateUI(searchedPlaceMarker);
  // }

  // void buildCurrentLocationMarker() {
  //   currentLocationMarker = Marker(
  //     position: LatLng(position!.latitude, position!.longitude),
  //     markerId: MarkerId('2'),
  //     onTap: () {},
  //     infoWindow: InfoWindow(title: "Your current Location"),
  //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //   );
  //   addMarkerToMarkersAndUpdateUI(currentLocationMarker);
  // }

// test marker from driver .. to current location

//....................................................
// put marker from firebace for rider .......................
  initMarkercurrent(specifyla, specifylo, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      markerId: markerId,
      position: LatLng(specifyla, specifylo),
      infoWindow: InfoWindow(title: "Your current Location "),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkercurrentData() async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('locationr');
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        FirebaseFirestore.instance
            .collection('locationr')
            .get()
            .then((myMarkers) {
          if (myMarkers.docs.isNotEmpty) {
            for (int i = 0; i < myMarkers.docs.length; i++) {
              initMarkercurrent(
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

  // ................................................
  //  test marker from driver ... to search location
  initMarkerchoose(specifyla, specifylo, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      // onTap: () {
      //   setState(() {
      //     isSearchedPlaceMarkerClicked = true;
      //     isTimeAndDistanceVisible = true;
      //   });
      // },
      markerId: markerId,
      position: LatLng(specifyla, specifylo),
      infoWindow: InfoWindow(title: "${placeSuggestion.description}"),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerDatachoose() async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('locationchoese');
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        FirebaseFirestore.instance
            .collection('locationchoese')
            .get()
            .then((myMarkers) {
          if (myMarkers.docs.isNotEmpty) {
            for (int i = 0; i < myMarkers.docs.length; i++) {
              initMarkerchoose(
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

//....................................................
  // add marker
  // void addMarkerToMarkersAndUpdateUI(Marker marker) {
  //   setState(() {
  //     markers.add(marker);
  //   });
  // }

  // remove marker when clicked from list for flotingActionBotton
  // void removeAllMarkersAndUpdateUI() {
  //   setState(() {
  //     markers.clear();
  //   });
  // }

//  auto commplete
  void getPlacesSuggestions(String query) {
    final sessionToken = Uuid().v4();
    BlocProvider.of<MapsCubit>(context)
        .emitPlaceSuggestions(query, sessionToken);
  }

  //  هون انا اخدت ال بلاس ايدي من الموديل تبع تحديد المكان
  // هون جبتون عال ui عن طريق البلوك
  void getSelectedPlaceLocation() {
    final sessionToken = Uuid().v4();
    BlocProvider.of<MapsCubit>(context)
        .emitPlaceLocation(placeSuggestion.placeId, sessionToken);
  }

  Widget buildSuggestionsBloc() {
    return BlocBuilder<MapsCubit, MapsState>(
      builder: (context, state) {
        if (state is PlacesLoaded) {
          places = (state).places;
          if (places.length != 0) {
            return buildPlacesList();
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

//  لما بكبس على شي مكلن بدي روح عليه من قلب القائمة
  Widget buildPlacesList() {
    return ListView.builder(
        itemBuilder: (_, index) {
          return InkWell(
            onTap: () async {
              placeSuggestion = places[index];
              controller.close();
              getSelectedPlaceLocation();
              polylinePoints.clear();
              //     removeAllMarkersAndUpdateUI();
            },
            child: PlaceItem(
              suggestion: places[index],
            ),
          );
        },
        itemCount: places.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics());
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      drawer: MyDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          position != null
              ? buildMap()
              : Center(
                  child: Container(
                    child: CircularProgressIndicator(
                      color: MyColors.blue,
                    ),
                  ),
                ),
          buildFloatingSearchBar(),
          isSearchedPlaceMarkerClicked
              ? DistanceAndTime(
                  isTimeAndDistanceVisible: isTimeAndDistanceVisible,
                  placeDirections: placeDirections,
                )
              : Container(),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 8, 30),
        child: FloatingActionButton(
          backgroundColor: MyColors.blue,
          onPressed: _goToMyCurrentLocation,
          child: Icon(Icons.place, color: Colors.white),
        ),
      ),
    );
  }

  // firebase ...............................................
  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');

    var user = json.decode(userJson.toString());
    setState(() {
      userData = user;
    });
  }

// .....................................................................

//.............................................................................
// current location
  Future<void> _listenLocationcurrent() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance
          .collection('locationr')
          .doc('${userData['email']}')
          .set({
        'latitude': position!.latitude,
        'longitude': position!.longitude,
        'name': '${userData['name']}'
      }, SetOptions(merge: true));
    });
  }

  // ...........................................................................
  _getLocationcurrent() async {
    if (userData != null) {
      try {
        // final loc.LocationData _locationResult = await location.getLocation();

        await FirebaseFirestore.instance
            .collection('locationr')
            .doc('${userData['email']}')
            .set({
          'latitude': position!.latitude,
          'longitude': position!.longitude,
          'name': '${userData['name']}'
        }, SetOptions(merge: true));
      } catch (e) {
        print(e);
      }
    }
  }

  //............................................................................
  //chose location fron flotingactionBar
  _getLocationchose() async {
    if (userData != null) {
      try {
        // final loc.LocationData _locationResult = await location.getLocation();

        await FirebaseFirestore.instance
            .collection('locationchoese')
            .doc('${userData['email']}')
            .set({
          'latitude': selectedPlace.result.geometry.location.lat,
          'longitude': selectedPlace.result.geometry.location.lng,
          'name': '${userData['name']}'
        }, SetOptions(merge: true));
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _listenLocationchose() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance
          .collection('locationchoese')
          .doc('${userData['email']}')
          .set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'name': '${userData['name']}'
      }, SetOptions(merge: true));
    });
  }

  // ..........................................
  // marker form firebase -_-
  // getMarkerData() async {
  //   CollectionReference reference =
  //       FirebaseFirestore.instance.collection('location');
  //   reference.snapshots().listen((querySnapshot) {
  //     querySnapshot.docChanges.forEach((change) {
  //       FirebaseFirestore.instance
  //           .collection('location')
  //           .get()
  //           .then((myMarkers) {
  //         if (myMarkers.docs.isNotEmpty) {
  //           for (int i = 0; i < myMarkers.docs.length; i++) {
  //             initMarker(
  //               myMarkers.docs[i].data()['latitude'],
  //               myMarkers.docs[i].data()['longitude'],
  //               myMarkers.docs[i].id,
  //             );
  //           }
  //         }
  //       });
  //     });
  //   });
  // }

  // initMarker(specifyla, specifylo, specifyId) async {
  //   var markerIdVal = specifyId;
  //   final MarkerId markerId = MarkerId(markerIdVal);
  //   final Marker marker = Marker(
  //     icon: carIcon,
  //     rotation: currentloc.heading!,
  //     markerId: markerId,
  //     position: LatLng(specifyla, specifylo),
  //     infoWindow: InfoWindow(title: "driver car "),
  //   );

  //   setState(() {
  //     markers[markerId] = marker;
  //   });
  // }
  current() async {
    await location.onLocationChanged.listen((event) {
      setState(() {
        currentloc = event;
      });
    });
  }
}

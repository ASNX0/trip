import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:scannerapp/taxi/constnats/my_colors.dart';
import 'package:scannerapp/taxi/data/models/Place_suggestion.dart';
import 'package:scannerapp/taxi/presentation/widgets/distance_and_time.dart';
import 'package:uuid/uuid.dart';
import 'package:location/location.dart' as loc;
import '../../business_logic/cubit/maps/maps_cubit.dart';
import '../../data/models/place.dart';
import '../../data/models/place_directions.dart';
import '../../helpers/location_helper.dart';
import '../widgets/place_item.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class GmScreen extends StatefulWidget {
  const GmScreen({Key? key}) : super(key: key);

  @override
  State<GmScreen> createState() => _GmScreenState();
}

class _GmScreenState extends State<GmScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<PlaceSuggestion> places = [];
  static Position? position;
  FloatingSearchBarController controller = FloatingSearchBarController();
  Completer<GoogleMapController> _mapController = Completer();
  static final CameraPosition _myCurrentLocationCameraPosition = CameraPosition(
    bearing: 0.0,
    target: LatLng(position!.latitude, position!.longitude),
    tilt: 0.0,
    zoom: 17,
  );

  //getPlaceLocation vars
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  late PlaceSuggestion placeSuggestion;
  late Place selectedPlace;
  late Marker searchedPlaceMarker;
  late Marker currentLocationMarker;
  late CameraPosition goToSearchedForPlace;
  //getDirections vars
  PlaceDirections? placeDirections;
  var progressIndicator = false;
  late List<LatLng> polylinePoints;
  var isSearchedPlaceMarkerClicked = false;
  var isTimeAndDistanceVisible = false;
  late String time;
  late String distance;
  //create a new default marker
  createMarker(LatLng markerLatlng, specifyId) async {
    final MarkerId markerId = MarkerId(specifyId);

    // creating a new MARKER
    final Marker marker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(specifyId == 'start'
            ? BitmapDescriptor.hueGreen
            : BitmapDescriptor.hueBlue),
        markerId: markerId,
        position: markerLatlng,
        infoWindow: InfoWindow(title: "${placeSuggestion.description}"),
        onTap: () {});
    setState(() {
      markers[markerId] = marker;
    });
  }

  //Cheack if i have gps on or network connection
  //and then get my current location and assign it to position
  Future<void> getMyCurrentLocation() async {
    position = await LocationHelper.getCurrentLocation().whenComplete(() {
      setState(() {});
    });
  }

  //animate camera by my postiotn
  Future<void> _goToMyCurrentLucation() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_myCurrentLocationCameraPosition));
  }

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      markers: Set<Marker>.of(markers.values),
      polylines: placeDirections != null
          ? {
              Polyline(
                polylineId: const PolylineId("MyPolyline"),
                color: Colors.blue,
                width: 6,
                points: polylinePoints,
              )
            }
          : {},
      initialCameraPosition: _myCurrentLocationCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
    );
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
      hint: 'Find a Place',
      border: BorderSide(style: BorderStyle.none),
      margins: EdgeInsets.fromLTRB(20, 70, 20, 0),
      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
      height: 52,
      iconColor: MyColors.blue,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(microseconds: 600),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(microseconds: 500),
      progress: progressIndicator,
      onQueryChanged: (query) {
        getPlacesSuggestions(query);
      },
      onFocusChanged: (_) {
        //hide distance and time row
        isTimeAndDistanceVisible = false;
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: Icon(
              Icons.place,
              color: Colors.black.withOpacity(0.6),
            ),
            onPressed: () {},
          ),
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(5),
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

  //only get camera new position and put it in goToSearchedForPlace
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

  //animate camera to the new selected place
  Future<void> goToMySearchedForLocation() async {
    buildCameraNewPosition();
    final GoogleMapController controller = await _mapController.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(goToSearchedForPlace));
    createMarker(goToSearchedForPlace.target, "destination");
    // createMarker(_myCurrentLocationCameraPosition.target, "start");
  }

  Widget buildSelectedPlaceLocationBloc() {
    return BlocListener<MapsCubit, MapsState>(
      listener: (context, state) {
        if (state is PlaceLocationLoaded) {
          selectedPlace = (state).place;
          goToMySearchedForLocation();
          // getMarkerData();
          filterMarkers();
          // getDirections();
          isTimeAndDistanceVisible = true;
        }
      },
      child: Container(),
    );
  }

  void getDirections() {
    print(DlatLng);
    setState(() {
      BlocProvider.of<MapsCubit>(context).emitPlaceDirections(
          // _myCurrentLocationCameraPosition.target, goToSearchedForPlace.target);
          DlatLng,
          goToSearchedForPlace.target);
    });
  }

  void getPlacesSuggestions(String query) {
    final sessionToken = Uuid().v4();
    BlocProvider.of<MapsCubit>(context)
        .emitPlaceSuggestions(query, sessionToken);
  }

  void getSelectedPlaceLocation() {
    final sessionToken = Uuid().v4();
    BlocProvider.of<MapsCubit>(context)
        .emitPlaceLocation(placeSuggestion.placeId, sessionToken);
  }

  //searched list result
  Widget buildPlacesList() {
    return ListView.builder(
        itemBuilder: (_, index) {
          return InkWell(
            onTap: () async {
              placeSuggestion = places[index];
              controller.close();
              getSelectedPlaceLocation();
              polylinePoints.clear();
              removeAllMarkersAndUpdateUi();
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

  void removeAllMarkersAndUpdateUi() {
    setState(() {
      markers.clear();
    });
  }

//process suggestion from cubit and put it in places
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

  void getPolylinePoints() {
    polylinePoints = placeDirections!.polylinePoints
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList();
  }

  Widget buildDiretionsBloc() {
    return BlocListener<MapsCubit, MapsState>(
      listener: (context, state) {
        if (state is DirectionsLoaded) {
          placeDirections = (state).placeDirections;
          setState(() {
            getPolylinePoints();
          });
        }
      },
      child: Container(),
    );
  }

  @override
  void initState() {
    getMyCurrentLocation();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(platform: TargetPlatform.android),
            "assets/bus2.png")
        .then((onValue) {
      carIcon = onValue;
    });
    // getMarkerData();
    filterMarkers();

    super.initState();
  }

  _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rate This Driver !'),
          content: Expanded(
            child: RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  color: Colors.red,
                  child: Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('location').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData && position == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return buildMap();
                }
              }),
          buildFloatingSearchBar(),
          isTimeAndDistanceVisible
              ? DistanceAndTime(
                  isTimeAndDistanceVisible: isTimeAndDistanceVisible,
                  placeDirections: placeDirections,
                )
              : Container(),
          // isTripDone ? _showMyDialog(context) : Center(),
          isTripDone ? _showMyDialog(context) : Center(),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 8, 30),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: _goToMyCurrentLucation,
          child: Icon(
            Icons.place,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  late BitmapDescriptor carIcon;

  late LatLng DlatLng;
  bool isTripDone = false;
  bool closeBus = false;

  initMarker(specifyla, specifylo, angle, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      icon: carIcon,
      rotation: angle,
      markerId: markerId,
      position: LatLng(specifyla, specifylo),
      anchor: Offset(0.5, 0.5),
      flat: true,
      draggable: false,
      infoWindow: InfoWindow(title: "title"),
    );

    setState(() {
      DlatLng = LatLng(specifyla, specifylo);
      markers[markerId] = marker;

      print(markerIdVal);
      print(specifyla);
      getDirections();
      print("////////////////////////");
      var dis = placeDirections!.totalDistance.split(' ')[0];

      if (double.parse(dis) < 3) {
        isTripDone = true;
        print('trueeeeeeeeeeeeeeeeeeeeeeee');
      } else {
        isTripDone = false;
      }
    });
  }

  filterMarkers() {
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
              var busDist = Geolocator.distanceBetween(
                position!.latitude,
                position!.longitude,
                myMarkers.docs[i].data()['latitude'],
                myMarkers.docs[i].data()['longitude'],
              );

              print("busDist= ${busDist / 1000}");
              setState(() {
                if (busDist / 1000 < 2.0) {
                  initMarker(
                    myMarkers.docs[i].data()['latitude'],
                    myMarkers.docs[i].data()['longitude'],
                    myMarkers.docs[i].data()['angle'],
                    myMarkers.docs[i].id,
                  );
                } else {
                  markers.clear();
                }
              });
            }
          }
        });
      });
    });
  }

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
  //               myMarkers.docs[i].data()['angle'],
  //               myMarkers.docs[i].id,
  //             );
  //           }
  //         }
  //       });
  //     });
  //   });
  // }
}

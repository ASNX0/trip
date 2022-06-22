import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:scannerapp/Screens/passenger_model.dart';
import 'package:scannerapp/new1/classes/whereto.dart';

import 'package:scannerapp/new1/dates.dart';
import 'package:scannerapp/new1/local.dart';
import 'package:scannerapp/new1/localArea.dart';
import 'package:scannerapp/new1/ticket.dart';
import 'package:scannerapp/taxi/business_logic/cubit/maps/maps_cubit.dart';
import 'package:scannerapp/taxi/constnats/my_colors.dart';
import 'package:scannerapp/taxi/data/models/Place_suggestion.dart';
import 'package:scannerapp/taxi/presentation/widgets/place_item.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:uuid/uuid.dart';

class providance extends StatefulWidget {
  const providance({Key? key}) : super(key: key);

  @override
  State<providance> createState() => _providanceState();
}

class _providanceState extends State<providance> {
  final String place1 = "";
  final String place2 = "";
  var datt1;
  var datt2;
  String start = '';
  String destination = '';
  DateTime? date;
  DateTime? datt;
  int passenger = 0;
  TextEditingController placecon1 = TextEditingController();
  TextEditingController placecon2 = TextEditingController();

  FloatingSearchBarController controller1 = FloatingSearchBarController();
  FloatingSearchBarController controller2 = FloatingSearchBarController();

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  List<PlaceSuggestion> places = [];
  static Position? position;

  late PlaceSuggestion placeSuggestion;
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

  Widget buildPlacesList(FloatingSearchBarController controller) {
    return ListView.builder(
        itemBuilder: (_, index) {
          return InkWell(
            onTap: () async {
              placeSuggestion = places[index];
              if (controller == controller1) {
                start = places[index].description;
              } else {
                destination = places[index].description;
              }
              print(places[index].description);
              controller.close();
              getSelectedPlaceLocation();
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

  Widget buildSuggestionsBloc(FloatingSearchBarController controller) {
    return BlocBuilder<MapsCubit, MapsState>(
      builder: (context, state) {
        if (state is PlacesLoaded) {
          places = (state).places;
          if (places.length != 0) {
            return buildPlacesList(controller);
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildFloatingSearchBar(String text, GlobalKey<FormState> key,
      FloatingSearchBarController controller, double top) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      key: key,
      controller: controller,
      // elevation: 4,
      hintStyle: TextStyle(fontSize: 18),
      queryStyle: TextStyle(fontSize: 18),
      hint: controller == controller1 && start != ''
          ? start
          : controller == controller2 && destination != ''
              ? destination
              : text,
      border: BorderSide(color: Colors.black45),

      margins: EdgeInsets.only(top: top, left: 10, right: 10),
      padding: EdgeInsets.fromLTRB(10, 0, 2, 0),
      height: 60,

      // iconColor: MyColors.blue,
      automaticallyImplyBackButton: false,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(microseconds: 600),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(microseconds: 500),
      onQueryChanged: (query) {
        getPlacesSuggestions(query);
      },
      onFocusChanged: (_) {
        //hide distance and time row
        // isTimeAndDistanceVisible = false;
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: Icon(
              Icons.place,
              color: controller == controller1
                  ? Color.fromARGB(255, 71, 245, 94).withOpacity(0.6)
                  : Color.fromARGB(255, 207, 7, 17).withOpacity(0.6),
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
              buildSuggestionsBloc(controller),
              // buildSelectedPlaceLocationBloc(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back)),
                  Text(
                    "Where To ?",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              margin: EdgeInsets.only(left: 10, right: 10, top: 154),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: () => {
                        // datt1 = DateFormat.yMd().format(date!),
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                backgroundColor: Colors.white,
                                actions: [
                                  // ignore: deprecated_member_use
                                  RaisedButton(
                                      color: Color.fromARGB(255, 18, 65, 104),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ))
                                ],
                                content: cal('Departing'),
                              );
                            }),
                        datt1 = DateFormat.yMd().format(date!),
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: date == null
                            ? 'Departing'
                            : '${DateFormat('yyyy-MM-dd-EE').format(date!).toString()}',
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                        readOnly: true,
                        onTap: () => {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      backgroundColor: Colors.white,
                                      actions: [
                                        // ignore: deprecated_member_use
                                        RaisedButton(
                                            color: Color.fromARGB(
                                                255, 18, 65, 104),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'OK',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ))
                                      ],
                                      content: cal('Return'),
                                    );
                                  }),
                              datt2 = DateFormat.yMd().format(datt!),
                            },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: datt == null
                              ? 'Return'
                              : '${DateFormat('yyyy-MM-dd-EE').format(datt!).toString()}',
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 17),
                        )),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 18, 65, 104),
                  borderRadius: BorderRadius.circular(8)),
              margin: EdgeInsets.only(top: 50),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Dates(
                                whrerTo: WhereTo(
                                    current: start,
                                    destination: destination,
                                    departing: date,
                                    returning: datt,
                                    passengers: passenger),
                              )));
                },
                child: Text(
                  "SEARCH",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            // TextButton(
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (BuildContext context) => Ticket()));
            //   },
            //   child: Text(
            //     "Ticket",
            //     style: TextStyle(fontSize: 20, color: Colors.black),
            //   ),
            // ),
            // TextButton(
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (BuildContext context) => LocalArea()));
            //   },
            //   child: Text(
            //     "local",
            //     style: TextStyle(fontSize: 20, color: Colors.black),
            //   ),
            // ),
          ],
        ),

        // Stack(children: [
        buildFloatingSearchBar(
            'Your current Location', _formKey1, controller1, 160),
        buildFloatingSearchBar(
            'Select destination', _formKey2, controller2, 90),
      ],
    ));
  }

  Widget cal(String value) {
    return Stack(children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Positioned(
            bottom: 50,
            child: Container(
              height: 500,
              width: 600,
              child: SfCalendar(
                onSelectionChanged: (CalendarSelectionDetails details) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    setState(() {
                      if (value == 'Departing') {
                        date = details.date!;

                        datt1 = DateFormat.yMd().format(date!);
                      } else if (value == 'Return') {
                        datt = details.date!;
                        print(datt);
                        datt2 = DateFormat.yMd().format(datt!);
                      }
                    });
                  });
                },
                backgroundColor: Colors.white,
                todayHighlightColor: Color.fromARGB(255, 18, 65, 104),
                selectionDecoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(255, 18, 65, 104), width: 2)),
                view: CalendarView.month,
                firstDayOfWeek: 6,
                initialDisplayDate: DateTime.now(),
                initialSelectedDate: DateTime.now(),
                showNavigationArrow: true,
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}

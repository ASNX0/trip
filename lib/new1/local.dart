// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../taxi/business_logic/cubit/maps/maps_cubit.dart';
import '../taxi/data/models/Place_suggestion.dart';
import '../taxi/presentation/widgets/place_item.dart';

class local extends StatefulWidget {
  const local({Key? key}) : super(key: key);

  @override
  _localState createState() => _localState();
}

class _localState extends State<local> with SingleTickerProviderStateMixin {
  @override
  var datt1;
  bool dat = false;
  late DateTime date;
  late DateTime datt;

  int _selectedIndex = 0;
  // prints something like 2019-12-10 10:02:22.287949 print(DateFormat('EEEE').format(date)); // prints Tuesday print(DateFormat('EEEE, d MMM, yyyy').format(date)); // prints Tuesday, 10 Dec, 2019 print(DateFormat('h:mm a').format(date));
  late TabController _tabController;
  @override
  void initState() {
    super.initState();

    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /////////////////////////////////////////////////
  String start = '';
  String destination = '';
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
  /////////////////////////////////////////////////
  // ignore: prefer_final_fields

  // static get placecon1 => null;
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: Color.fromARGB(255, 18, 65, 104),
              title: Text('local area'))
          : AppBar(
              bottom: new TabBar(
                  labelPadding: EdgeInsets.symmetric(horizontal: 5),
                  controller: _tabController,
                  tabs: [
                  new Tab(
                    child: Container(
                      width: 50,
                      child: Text(
                        " Buy Ticket",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  new Tab(
                    child: Container(
                      width: 50,
                      child: Text(
                        " Your Ticket",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ])),
      body: SingleChildScrollView(
        child: Column(children: [
          _selectedIndex == 0
              ? Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          child: Row(
                            children: [
                              Icon(Icons.timer),
                              Text(
                                'Departure now',
                                style: TextStyle(fontSize: 15),
                              ),
                              Icon(Icons.arrow_drop_down_sharp)
                            ],
                          ),
                          onTap: () => {
                            // datt1 = DateFormat.yMd().format(date!),
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.green[300],
                                    actions: [
                                      // ignore: deprecated_member_use
                                      RaisedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('ok'))
                                    ],
                                    content: cal('Departure now'),
                                  );
                                }),
                            datt1 = DateFormat.yMd().format(date),
                          },
                        ),
                        Container(
                          width: 200,
                          margin: EdgeInsets.only(left: 15, bottom: 14),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: dat == true ? datt1 : "Departure now",
                                prefixIcon: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 0.0),
                                    child: Icon(Icons.timer
                                        // myIcon is a 48px-wide widget.
                                        ))),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 350,
                      margin: EdgeInsets.only(right: 10, bottom: 14),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Passenger"),
                            prefixIcon: Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(start: 10),
                                child: Icon(
                                  Icons.emoji_people_rounded,
                                  color: Colors.blue,
                                  // myIcon is a 48px-wide widget.
                                ))),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 150,
                          margin: EdgeInsets.only(left: 12, bottom: 14),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text(
                                    " +                                                                                                                                       ADD HOME"),
                                prefixIcon: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 0.0),
                                    child: Icon(
                                      Icons.home_work,
                                      color: Colors.red,
                                      // myIcon is a 48px-wide widget.
                                    ))),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Container(
                          width: 150,
                          margin: EdgeInsets.only(right: 10, bottom: 14),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text(" +ADD WORK"),
                                prefixIcon: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 0.0),
                                    child: Icon(
                                      Icons.home_repair_service,
                                      color: Colors.red,
                                      // myIcon is a 48px-wide widget.
                                    ))),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 300,
                      margin: EdgeInsets.only(top: 12),
                      child: Divider(
                        thickness: 3,
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 200, top: 10),
                        child: Text(
                          "Rout and stop search",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: 400,
                        margin: EdgeInsets.only(
                          right: 30,
                          bottom: 14,
                        ),
                        child: Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: 10, right: 250),
                                child: Text(
                                  'MY Route:',
                                  style: TextStyle(fontSize: 20),
                                )),
                            Container(
                              margin: EdgeInsets.only(right: 250),
                              child: TextButton(
                                  onPressed: () => print("jkkl"),
                                  child: Text("+add route")),
                            ),
                            Divider(
                              height: 0,
                              thickness: 2,
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 40, right: 160),
                                child: Text(
                                  'MY Stop or station:',
                                  style: TextStyle(fontSize: 20),
                                )),
                            Container(
                              margin: EdgeInsets.only(right: 250),
                              child: TextButton(
                                  onPressed: () => print("jkkl"),
                                  child: Text("+add stops")),
                            ),
                            Divider(
                              height: 0,
                              thickness: 2,
                            ),
                          ],
                        ))
                  ],
                )
              : Center(),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_outlined),
            label: 'ROUTES',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list_outlined),
            label: 'TICKET',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        // onTap: _onItemTapped,
      ),
    );
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
                      dat = !dat;
                      date = details.date!;
                      datt1 = DateFormat.yMd().format(date);
                    });
                  });
                },
                backgroundColor: Colors.green[300],
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

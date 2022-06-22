// ignore_for_file: prefer_const_constructors, unnecessary_new, deprecated_member_use, invalid_use_of_visible_for_testing_member, prefer_typing_uninitialized_variables, avoid_print, camel_case_types

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scannerapp/Screens/bus-driver-screen.dart';

import 'package:scannerapp/Screens/vertical-card-pager.dart';
import 'package:scannerapp/histroy.dart';
import 'package:scannerapp/home.dart';
import 'package:scannerapp/logging/login.dart';
import 'package:scannerapp/logging/upload.dart';
import 'package:scannerapp/new1/start.dart';
import 'package:scannerapp/taxi/business_logic/cubit/maps/maps_cubit.dart';
import 'package:scannerapp/taxi/data/repository/maps_repo.dart';
import 'package:scannerapp/taxi/data/webservices/places_webservices.dart';
import 'package:scannerapp/taxi/presentation/screens/gm_screen.dart';
import 'package:scannerapp/taxi/presentation/screens/map_screen.dart';
import 'package:scannerapp/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'live Location/Myapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp(
      // appRouter: AppRouter(),
      ));
}

class MyApp extends StatefulWidget {
//  final AppRouter appRouter;
  const MyApp({
    Key? key,
    // required this.appRouter,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late final AppRouter appRouter;
  bool onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("images/Bus.jpg"), context);
    precacheImage(AssetImage("images/qr.jpg"), context);
    precacheImage(AssetImage("images/taxi.jpg"), context);
    precacheImage(AssetImage("images/register.jpg"), context);

    precacheImage(AssetImage("images/login.jpg"), context);
    precacheImage(AssetImage("images/diver.jpg"), context);

    return Sizer(builder: (context, orientation, deviceType) {
      return BlocProvider<MapsCubit>(
        create: (context) => MapsCubit(MapsRepository(PlacesWebservices())),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          //   onGenerateRoute: appRouter.generateRoute,
          initialRoute: '/splash-secreen',
          routes: {
            '/start': (context) => providance(),
            '/myview': (context) => MyView(),
            '/history': (context) => History(),
            '/GmScreen': (context) => GmScreen(),
            '/BusDriver': (context) => BusDriver(),
            '/map-screen': (context) => MapScreen(),
            '/home': (context) => Home(),
            '/live-location': (context) => App(),
            '/welcam': (context) => Welcome(),
            '/splash-secreen': (context) => splashScreen(),
            '/sign-in': (context) => SignIn(),
            '/upload': (context) => Upload(),
          },
        ),
      );
    });
  }
}

class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animController;
  bool _isLoggedIn = false;
  var userData;
  void initState() {
    super.initState();
    _getUserInfo();
    _checkIfLoggedIn();

    //   Animation
    animController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);

    final curvedAnimation = CurvedAnimation(
      parent: animController,
      curve: Curves.bounceIn,
    );

    animation =
        Tween<double>(begin: 0, end: 2 * math.pi).animate(curvedAnimation)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              animController.forward();
            }
          });

    animController.forward();
  }

  void dispose() {
    animController.dispose();
    super.dispose();
  }

  // check if token is there
  _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    final token = localStorage.getString('token');
    print(token);
    if (token != null) {
      setState(() {
        _isLoggedIn = true;
      });
    }
    await Future.delayed(Duration(seconds: 4), () {});
    if (_isLoggedIn) {
      print(userData['type']);
      if (userData['type'] == 'User') {
        Navigator.pushNamed(context, '/myview');
      } else if (userData['type'] == 'TaxiD') {
        Navigator.pushReplacementNamed(context, '/live-location');
      }
    } else {
      Navigator.pushNamed(context, '/welcam');
    }
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
      backgroundColor: Color.fromARGB(255, 32, 32, 32),
      body: Center(
        // child: AnimatedBuilder(
        //     animation: animation,
        //     builder: (context, child) {
        //       return Transform.rotate(
        //         angle: animation.value,
        //         child: Container(
        //           alignment: Alignment.center,
        //           padding: EdgeInsets.all(10),
        //           width: 190,
        //           height: 190,
        //           decoration: BoxDecoration(
        //             shape: BoxShape.circle,
        //             border: Border.all(
        //               color: Colors.grey,
        //               width: 3.0,
        //             ),
        //           ),
        //           child: Image(
        //             image: AssetImage('images/logo.png'),
        //           ),
        //         ),
        //       );
        //     }),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Transport Zone",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontFamily: "Smooch",
                  fontWeight: FontWeight.w400),
            ),
            LoadingAnimationWidget.dotsTriangle(
              color: Colors.white,
              size: 80,
            ),
          ],
        ),
      ),
    );
  }
}

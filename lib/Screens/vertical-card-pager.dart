import 'package:flutter/material.dart';
import 'package:scannerapp/logging/handleAccount.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

class MyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> titles = ["", "", ""];

    final List<Widget> images = [
      MyCard('images/City driver-pana.png'),
      MyCard('images/Bus driver-pana.png'),
      MyCard('images/www-cuate.png'),
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/GmScreen');
                },
                child: Text("Gmscreen")),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/start');
                },
                child: Text("start")),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/history');
                },
                child: Text("history")),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/BusDriver');
                },
                child: Text("busDriver")),
            TextButton(
                onPressed: () {
                  Account.logout(context);
                },
                child: Text("Log Out")),
            Expanded(
              child: Container(
                child: VerticalCardPager(
                  titles: titles, // required
                  images: images, // required
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold), // optional
                  onPageChanged: (page) {
                    //  Navigator.pop(context);
                  },
                  onSelectedItem: (index) {
                    if (index == 0) {
                      Navigator.pushNamed(context, '/home');
                      //   Navigator.of(context).pushNamed('/myview');
                      // route to page bus
                    } else if (index == 1) {
                      // route to page taxi
                      //   Navigator.of(context).pushNamed('/mapScreen');
                      Navigator.pushNamed(context, '/map-screen');
                    } else if (index == 2) {
                      // hannen
                      //  Navigator.of(context).pushNamed('/firas');
                      //   Navigator.pushNamed(context,'/mapScreen');
                    }
                  },
                  initialPage: 1, // optional
                  align: ALIGN.CENTER, // optional
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget MyCard(String img) => Card(
        elevation: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Image(
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            image: AssetImage(img)),
      );
}

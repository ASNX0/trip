import 'package:flutter/material.dart';

class Ticket extends StatefulWidget {
  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  bool value1 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Buy a ticket",
          style: TextStyle(fontSize: 25),
        ),
        backgroundColor: Color.fromARGB(255, 18, 65, 104),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 60),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                        side: MaterialStateBorderSide.resolveWith(
                            (states) => BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 201, 20, 7),
                                )),
                        value: value1,
                        onChanged: (value) => setState(() {
                              value1 = value!;
                            })),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Text(
                    "I understand that the ticket must be on my phone before boarding  the Bus ",
                    style: TextStyle(fontSize: 17),
                  ),
                )
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 10, top: 70, right: 90),
            width: 5,
            child: Divider(
              thickness: 2,
              color: Color.fromARGB(255, 133, 132, 128),
            ),
          ),
          SizedBox(
            height: 10,
          ),

          InkWell(
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Color.fromARGB(255, 18, 65, 104)),
                ),
                height: 75,
                width: 150,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.av_timer_rounded,
                        size: 40,
                        color: Color.fromARGB(255, 201, 20, 7),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: ListTile(
                        title: Text("Single ticket",
                            style: TextStyle(
                                color: Color.fromARGB(255, 9, 117, 206))),
                        subtitle: Text("single and zone extension tickets"),
                      ),
                    ),
                  ],
                )),
            onTap: () => null,
          ),
          InkWell(
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Color.fromARGB(255, 18, 65, 104)),
                ),
                height: 75,
                width: 150,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.calendar_today,
                        size: 40,
                        color: Color.fromARGB(255, 201, 20, 7),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: ListTile(
                        title: Text("Day Ticket",
                            style: TextStyle(
                                color: Color.fromARGB(255, 9, 117, 206))),
                        subtitle: Text("1_13 days"),
                      ),
                    ),
                  ],
                )),
            onTap: () => null,
          ),
          InkWell(
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Color.fromARGB(255, 18, 65, 104)),
                ),
                height: 75,
                width: 150,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.calendar_month,
                        size: 40,
                        color: Color.fromARGB(255, 201, 20, 7),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: ListTile(
                        title: Text("Season Ticket",
                            style: TextStyle(
                                color: Color.fromARGB(255, 9, 117, 206))),
                        subtitle: Text("Aute-renewing or one_off purchase"),
                      ),
                    ),
                  ],
                )),
            onTap: () => null,
          ),

          Container(
            margin: EdgeInsets.only(left: 10, top: 10, right: 90),
            width: 5,
            child: Divider(
              thickness: 2,
              color: Color.fromARGB(255, 179, 178, 175),
            ),
          ),

          InkWell(
            child: Row(
              children: [
                Expanded(flex: 0, child: Icon(Icons.qr_code_2_rounded)),
                Expanded(
                  flex: 10,
                  child: ListTile(
                    title: Text(
                      "Ticket with a qr_code",
                      style: TextStyle(color: Color.fromARGB(255, 9, 117, 206)),
                    ),
                    subtitle: Text("redeem a ticket with a code"),
                  ),
                ),
              ],
            ),
            onTap: () => null,
          ),

          // Checkbox(value: , onChanged: onChanged),
        ],
      ),
    );
  }
}

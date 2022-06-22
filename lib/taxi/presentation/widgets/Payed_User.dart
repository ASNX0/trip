import 'package:flutter/material.dart';

class PayedUser extends StatefulWidget {
  int index;
  String name;
  String time;
  PayedUser({required this.index, required this.name, required this.time});

  @override
  State<PayedUser> createState() => _PayedUserState();
}

class _PayedUserState extends State<PayedUser> {
  @override
  void initState() {
    // TODO: implement initState
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
      ),
      child: Row(
        children: [
          Expanded(
              child: Text(
            "${widget.index}",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          )),
          Expanded(
            flex: 2,
            child: Icon(
              Icons.double_arrow_rounded,
              size: 38,
              color: Colors.red[700],
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              "${widget.name}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              "${widget.time}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}

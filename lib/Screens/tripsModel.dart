class trip {
  List myTrips;
  // List companyName;
  // List features;
  // bool wifi;
  // bool condition;
  // bool mobile;

  trip({
    required this.myTrips,
    // required this.companyName,
    // required this.features,
    // required this.wifi,
    // required this.condition,
    // required this.mobile
  });
  factory trip.fromJson(Map<String, dynamic> json) => trip(
        myTrips: json["trips"],
        // features: json["trips"],
        // companyName: json["features"]["company_name"],
        // wifi: json["features"]["wifi"],
        // condition: json["features"]["condition"],
        // mobile: json["features"]["mobile_charger"],
      );

  Map<String, dynamic> toJson() => {
        "myTrips": myTrips,
        // "companyName": companyName,
        // "features": features,
        // "wifi": wifi,
        // "condition": condition,
        // "mobile": mobile
      };
}
//[{id: 4, bus_id: 2, location_id: 3, date: 2022-6-9-Thu, time: 07:00, created_at: 2022-06-04T09:16:01.000000Z, updated_at: 2022-06-04T09:16:01.000000Z, buses: {id: 2, bus_number: 2, bus_status: true, company_ID: 1, location_id: 1}}]
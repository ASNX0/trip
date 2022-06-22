class passenger {
  passenger({
    required this.name,
    required this.createdAt,
  });

  String name;
  DateTime createdAt;

  factory passenger.fromJson(Map<String, dynamic> json) => passenger(
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "created_at": createdAt.toIso8601String(),
      };
}

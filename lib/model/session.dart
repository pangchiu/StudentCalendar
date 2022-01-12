class Session {
  int? idMissions;
  int? idDay;
  String name;
  String code;
  String location;
  String teacher;
  String time;
  String type;
  String? node;

  Session({
    required this.name,
    required this.code,
    required this.location,
    required this.teacher,
    required this.time,
    required this.type,
    this.node,
    this.idMissions,
    this.idDay,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      idMissions: json["idMissions"],
      idDay: json["idDay"],
      name: json["name"] as String,
      code: json["code"] as String,
      location: json["location"] as String,
      teacher: json["teacher"] as String,
      time: json["time"] as String,
      type: json["type"] as String,
      node: (json["node"] ?? ""),
    );
  }

  Map<String, Object?> toJson() {
    return {
      "idMissions": idMissions,
      "idDay": idDay,
      "name": name,
      "code": code,
      "location": location,
      "teacher": teacher,
      "time": time,
      "type": type,
      "node": node
    };
  }
}

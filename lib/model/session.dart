class Session {
  int? id;
  int? idTask;
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
    this.id,
    this.idTask,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      name: json["name"] as String,
      code: json["code"] as String,
      location: json["location"] as String,
      teacher: json["teacher"] as String,
      time: json["time"] as String,
      type: json["type"] as String,
      // node: json["node"] as String,
    );
  }

  Map<String, Object?> toJson() {
    return {
      "id": id,
      "idTask": idTask,
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

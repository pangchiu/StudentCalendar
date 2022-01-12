import 'package:app/model/session.dart';

class Task {
  final int? idDay;
  final DateTime date;
  final List<Session> sessions;

  const Task({required this.date, required this.sessions, this.idDay});

  factory Task.fromJson(Map<String, dynamic> json) {
    var listSession = (json["sessions"] as List)
        .map<Session>((e) => Session.fromJson(e))
        .toList();
    return Task(idDay: json["idDay"],date: (json["date"] as DateTime), sessions: listSession);
  }
  Map<String, Object?> toJson() {
    return {
      "idDay" : idDay,
      "date" : date.toString(),
      "sessions" : sessions.map((e) => e.toJson()).toList(),
    };
  }
}



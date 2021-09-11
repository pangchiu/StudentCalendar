import 'package:app/model/session.dart';

class Task {
  final int? id;
  final DateTime date;
  final List<Session> sessions;

  const Task({required this.date, required this.sessions, this.id});

  factory Task.fromJson(Map<String, dynamic> json) {
    var listSession = (json["sessions"] as List)
        .map<Session>((e) => Session.fromJson(e))
        .toList();
    return Task(date: (json["date"] as DateTime), sessions: listSession);
  }
  Map<String, Object?> toJson() {
    return {
      "id" : id,
      "date" : date.toIso8601String(),
      "sessions" : sessions.map((e) => e.toJson()).toList(),
    };
  }
}



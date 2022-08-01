// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

List<Course> postFromJson(String str) =>
    List<Course>.from(json.decode(str).map((x) => Course.fromMap(x)));

class Course {
  Course({
    required this.id_course,
    required this.id_chauffeur,
    required this.zone_course,
    required this.type_course,
    required this.date_course,
    required this.statut_course,
  });

  String id_course;
  String id_chauffeur;
  String zone_course;
  String type_course;
  String date_course;
  String statut_course;

  factory Course.fromMap(Map<String, dynamic> json) => Course(
        id_course: json["id_course"],
        id_chauffeur: json["id_chauffeur"],
        zone_course: json["zone_course"],
        type_course: json["type_course"],
        date_course: json["date_course"],
        statut_course: json["statut_course"],
      );
}

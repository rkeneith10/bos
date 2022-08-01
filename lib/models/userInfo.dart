// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

List<Chauffeur> postFromJson(String str) =>
    List<Chauffeur>.from(json.decode(str).map((x) => Chauffeur.fromMap(x)));

class Chauffeur {
  Chauffeur({
    required this.nom_chauffeur,
    required this.prenom_chauffeur,
  });

  String nom_chauffeur;
  String prenom_chauffeur;

  factory Chauffeur.fromMap(Map<String, dynamic> json) => Chauffeur(
        nom_chauffeur: json["nom_chauffeur"],
        prenom_chauffeur: json["prenom_chauffeur"],
      );
}

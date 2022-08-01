// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

List<Eleves> postFromJson(String str) =>
    List<Eleves>.from(json.decode(str).map((x) => Eleves.fromMap(x)));

class Eleves {
  Eleves({
    required this.nom_eleve,
    required this.prenom_eleve,
    required this.sexe_eleve,
    required this.adresse_eleve,
    required this.zone_eleve,
  });

  String nom_eleve;
  String prenom_eleve;
  String sexe_eleve;
  String adresse_eleve;
  String zone_eleve;

  factory Eleves.fromMap(Map<String, dynamic> json) => Eleves(
        nom_eleve: json["nom_eleve"],
        prenom_eleve: json["prenom_eleve"],
        sexe_eleve: json["sexe_eleve"],
        adresse_eleve: json["adresse_eleve"],
        zone_eleve: json["zone_eleve"],
      );
}

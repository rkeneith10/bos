import 'dart:convert';

import "package:flutter/material.dart";
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';

import './list_eleves_screen.dart';
import '../models/userInfo.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../models//listeCourses.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String url = "https://adm.boshaiti.com/api/course_en_cours";
  String url1 = "https://adm.boshaiti.com/api/chauffeur_info";
  late Future<List<Course>> futureCourse;
  late Future<List<Chauffeur>> futureChauffeur;
  late String token;

  Future<List<Chauffeur>> fetchDataChauffeur() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('id_chauffeur')!;

    final response = await http.post(Uri.parse(url1),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{"id_chauffeur": token}));

    if (response.statusCode == 200) {
      //displayToast(response.body);
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Chauffeur>((json) => Chauffeur.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Course>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('id_chauffeur')!;

    //displayToast(token);

    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{"id_chauffeur": token}));

    if (response.statusCode == 200) {
      //displayToast(response.body);
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Course>((json) => Course.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  final LatLng _initialcameraposition = const LatLng(18.971187, -72.285215);
  late GoogleMapController _controller;
  final Location _location = Location();

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(l.latitude!.toDouble(), l.longitude!.toDouble()),
              zoom: 15),
        ),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    futureChauffeur = fetchDataChauffeur();
    futureCourse = fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.only(
                  top: 50, left: 20, right: 20, bottom: 30),
              width: MediaQuery.of(context).size.width * 1,
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'keneith Salnave Romain',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  // FutureBuilder<List<Chauffeur>>(
                  //   future: futureChauffeur,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       return ListView.builder(
                  //           itemCount: snapshot.data!.length,
                  //           itemBuilder: (_, index) => Container(
                  //                 decoration: BoxDecoration(
                  //                     border: Border.all(color: Colors.red)),
                  //                 child: const Text("lol"),
                  //               ));
                  //     } else {
                  //       return const Center(child: CircularProgressIndicator());
                  //     }
                  //   },
                  // ),
                  Container(
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/avatar1.png'),
                    ),
                  )
                ],
              )),
          // const SizedBox(
          //   height: 20,
          // ),
          Container(
            height: 300,
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: _initialcameraposition),
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                myLocationButtonEnabled: true),
          ),
          const SizedBox(
            height: 20,
          ),

          Container(
            padding: const EdgeInsets.only(
              left: 30,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  "COURSE EN COURS",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 3,
          ),

          Container(
            width: MediaQuery.of(context).size.width * 0.90,
            height: 200,
            decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.4),
                      blurRadius: 4,
                      offset: Offset(4, 8))
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: FutureBuilder<List<Course>>(
              future: futureCourse,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ListElevesScreen(
                                departure: snapshot.data![index].zone_course
                                    .toString())));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Container(
                                //   // decoration: BoxDecoration(
                                //   //   border: Border.all(color: Colors.white),
                                //   // ),
                                //   width:
                                //       MediaQuery.of(context).size.width * 0.3,
                                //   height: 140,
                                //   child: ClipRRect(
                                //     child: Image.asset(
                                //       'assets/images/bustracker.png',
                                //       fit: BoxFit.cover,
                                //     ),
                                //   ),
                                // ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    height: 140,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                // const Icon(Icons.add_location),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              0,
                                                              0,
                                                              0,
                                                              0.4),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          100))),
                                                  child: const IconButton(
                                                      icon: Icon(
                                                        Icons
                                                            .location_on_outlined,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: null),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                snapshot.data![index]
                                                            .type_course ==
                                                        1.toString()
                                                    ? const Text(
                                                        "Centre-Ville ",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))
                                                    : Text(
                                                        snapshot.data![index]
                                                            .zone_course,
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))
                                              ],
                                            ),
                                            const Text(
                                              "_______________________________________________________",
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.4),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Row(
                                              children: [
                                                // const Icon(Icons.add_location),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              0,
                                                              0,
                                                              0,
                                                              0.4),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          100))),
                                                  child: const IconButton(
                                                      icon: Icon(
                                                        Icons.stars_outlined,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: null),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),

                                                snapshot.data![index]
                                                            .type_course ==
                                                        0.toString()
                                                    ? const Text(
                                                        "Centre-Ville ",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))
                                                    : Text(
                                                        snapshot.data![index]
                                                            .zone_course,
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

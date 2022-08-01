import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models//listeCourses.dart';
import '../screens/list_eleves_screen.dart';

class ListeCourse extends StatefulWidget {
  const ListeCourse({Key? key}) : super(key: key);

  @override
  State<ListeCourse> createState() => _ListeCourseState();
}

class _ListeCourseState extends State<ListeCourse> {
  String url = "https://adm.boshaiti.com/api/course_en_cours";
  late Future<List<Course>> futureCourse;
  late String token;

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

  void displayToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.grey[500],
        textColor: Colors.white,
        fontSize: 18.0);
  }

  @override
  void initState() {
    // TODO: implement initState
    futureCourse = fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(231, 232, 236, 1),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Course en cours'),
        ),
        body: FutureBuilder<List<Course>>(
          future: futureCourse,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ListElevesScreen(
                            departure:
                                snapshot.data![index].zone_course.toString())));
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              // decoration: BoxDecoration(
                              //   border: Border.all(color: Colors.white),
                              // ),
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: 95,
                              child: ClipRRect(
                                child: Image.asset(
                                  'assets/images/bustracker.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                height: 95,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   snapshot.data![index].type_course,
                                    //   style: const TextStyle(
                                    //       color: Colors.grey,
                                    //       fontSize: 18,
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    Row(
                                      children: [
                                        snapshot.data![index].type_course ==
                                                1.toString()
                                            ? Text(
                                                "Centre-Ville -> " +
                                                    snapshot.data![index]
                                                        .zone_course,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            : Text(
                                                snapshot.data![index]
                                                        .zone_course +
                                                    " -> Centre-Ville ",
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
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
        ));
  }
}

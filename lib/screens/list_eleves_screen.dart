// ignore_for_file: unnecessary_const

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../models/listeEleves.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ListElevesScreen extends StatefulWidget {
  final String departure;
  const ListElevesScreen({Key? key, required this.departure}) : super(key: key);

  @override
  State<ListElevesScreen> createState() => _ListElevesScreenState();
}

class _ListElevesScreenState extends State<ListElevesScreen> {
  String url = "https://adm.boshaiti.com/api/eleve_course";
  late Future<List<Eleves>> futurePost;
  late Future<List<Eleves>> futurePostEleve;
  late String resultbarcode = "";

  get departure => null;

  Future<List<Eleves>> fetchData() async {
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{'zone_course': widget.departure}));

    if (response.statusCode == 200) {
      //displayToast("messag:");
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Eleves>((json) => Eleves.fromMap(json)).toList();
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

  // displayModal(String name, String adresse, String zoneEleve) {
  //   showMaterialModalBottomSheet(
  //     context: context,
  //     builder: (context) => SingleChildScrollView(
  //       controller: ModalScrollController.of(context),
  //       child: Container(
  //         child: Column(
  //           children: [
  //             Text(name),
  //             Text(adresse),
  //             Text(zoneEleve),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Future<void> scanQR() async {
    late String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      setState(() {
        resultbarcode = barcodeScanRes;
      });
      getData();

      //log(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  Future<void> getData() async {
    String url = "https://adm.boshaiti.com/api/eleve_info";
    var postJson = [];
    final res = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{"id_eleve": resultbarcode}));
    //displayToast(barcodeScanRes);

    if (res.statusCode == 200) {
      try {
        final jsonData = jsonDecode(res.body) as List;

        setState(() {
          postJson = jsonData;
        });
      } catch (err) {}

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: const Radius.circular(25.0),
              topRight: const Radius.circular(25.0),
            ),
          ),
          child: ListView.builder(
            itemCount: postJson.length,
            itemBuilder: (context, index) => Container(
              child: Column(
                children: [
                  Text(postJson[index]["nom_eleve"]),
                  Text(postJson[index]["adresse_eleve"]),
                  Text(postJson[index]["zone_eleve"]),
                ],
              ),
            ),
          ),
        ),
      );

      // showMaterialModalBottomSheet(
      //     context: context,
      //     builder: (context) => Container(
      //           decoration: const BoxDecoration(
      //               color: Colors.red,
      //               borderRadius: BorderRadius.all(Radius.circular(10))),
      //           margin: const EdgeInsets.only(left: 10, right: 10),
      //           height: MediaQuery.of(context).size.height * 0.75,
      //           child: ListView.builder(
      //             itemCount: postJson.length,
      //             itemBuilder: (context, index) => Container(
      //               child: Column(
      //                 children: [
      //                   Text(postJson[index]["nom_eleve"]),
      //                   Text(postJson[index]["adresse_eleve"]),
      //                   Text(postJson[index]["zone_eleve"]),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ));
    }
  }

  @override
  void initState() {
    futurePost = fetchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(231, 232, 236, 1),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Liste Eleves'),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.scanner,
                color: Colors.white,
              ),
              onPressed: () {
                scanQR();
              },
            )
          ],
        ),
        body: FutureBuilder<List<Eleves>>(
          future: futurePost,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => Container(
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
                                'assets/images/avatar2.jpg',
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
                                  Text(
                                    snapshot.data![index].nom_eleve +
                                        " " +
                                        snapshot.data![index].prenom_eleve,
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Color.fromRGBO(1, 128, 124, 1),
                                        size: 15,
                                      ),
                                      Text(snapshot.data![index].adresse_eleve,
                                          style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  1, 128, 124, 1),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  Text(
                                    snapshot.data![index].zone_eleve,
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
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
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

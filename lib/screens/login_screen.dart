import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isloading = false;

  Future<String> login(String email, String password) async {
    setState(() {
      isloading = true;
    });

    var res = await http.post(
        Uri.parse('https://adm.boshaiti.com/api/chauffeur_login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'email_chauffeur': email,
          'mdp_chauffeur': password
        }));
    setState(() {
      isloading = false;
    });

    if (res.statusCode == 200) {
      //displayToast("Body:" + res.body);
      var parse = jsonDecode(res.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('id_chauffeur', parse['id_chauffeur']);
      await prefs.setString('nom_chauffeur', parse['nom_chauffeur']);
      await prefs.setString('prenom_chauffeur', parse['prenom_chauffeur']);
      return parse["id_chauffeur"];
    } else {
      return res.statusCode.toString();
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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  Image.asset(
                    'assets/images/bos_icon.jpg',
                    width: 150,
                    height: 150,
                  )

                  // Image.network(
                  //   "https://adm.boshaiti.com/assets_adm/img/logoc.png",
                  //   width: 150,
                  //   height: 150,
                  // )
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Space between each component

                  //Space between each component

                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.height * 0.8,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(231, 232, 236, 1),
                        borderRadius: BorderRadius.circular(25)),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: 'Entrer votre email',
                          icon: Icon(
                            Icons.email,
                            color: Color.fromRGBO(34, 157, 77, 1),
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  //Space between each component

                  //Space between each component

                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.height * 0.8,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(231, 232, 236, 1),
                        borderRadius: BorderRadius.circular(25)),
                    child: TextField(
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      controller: passwordController,
                      decoration: const InputDecoration(
                          hintText: 'Entrer votre mot de passe',
                          icon: Icon(
                            Icons.lock,
                            color: Color.fromRGBO(34, 157, 77, 1),
                          ),
                          // suffixIcon: IconButton(
                          //   icon: Icon(Icons.visibility),
                          //   onPressed: null,
                          // ),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        primary: const Color.fromRGBO(34, 157, 77, 1),
                        onPrimary: Colors.white,
                        minimumSize: const Size.fromHeight(45)),
                    onPressed: () async {
                      var emailuser = emailController.text;
                      var passworduser = passwordController.text;
                      //final bool isvalid = EmailValidator.validate(emailuser);

                      if (emailuser.isEmpty || passworduser.isEmpty) {
                        displayToast('Tous les champs doivent etre completés');
                      }
                      // else if (!isvalid) {
                      //   displayToast('Enter a valid email');
                      // }
                      else {
                        var res = await login(emailuser, passworduser);
                        if (res == 400.toString()) {
                          displayToast('Email ou mot de passe incorrect');
                        } else {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String? token = prefs.getString('id_chauffeur');
                          if (token != null) {
                            // displayToast("The token :" + token);

                            Navigator.of(context)
                                .pushReplacementNamed('/homescreen');
                          } else {
                            displayToast("null");
                          }
                        }
                      }
                    },
                    child: isloading
                        ? const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'SE CONNECTER',
                          ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )
          ]),
        ));
  }
}

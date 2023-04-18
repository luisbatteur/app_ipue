import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_ipue/pages/forgotPassword_page.dart';
import 'package:app_ipue/pages/home2_page.dart';
import 'package:app_ipue/pages/register_page.dart';
import 'package:app_ipue/utilities/styles_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController controlEmail = TextEditingController();
  TextEditingController controlContrasena = TextEditingController();

  bool _passwordVisible = false;
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: IpueColors.cGris),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - 90.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30.0,
                    ),
                    const Image(
                      image: AssetImage("assets/images/logo.png"),
                      width: 200.0,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Text(
                      "Acceda a su cuenta",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: IpueColors.cGris,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    _formLogin(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    _btnLogin(),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "¿No tiene una cuenta?",
                        style: TextStyle(
                          color: IpueColors.cGris,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "¡Regístrate!",
                          style: TextStyle(
                            color: IpueColors.cPrimario,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /////////////////////////
  Widget _formLogin() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              bottom: 5.0,
              left: 20.0,
              right: 20.0,
            ),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                  return "El email no es correcto.";
                } else {
                  return null;
                }
              },
              style: const TextStyle(color: IpueColors.cGris),
              controller: controlEmail,
              decoration: const InputDecoration(
                filled: true,
                fillColor: IpueColors.cGris,
                focusColor: IpueColors.cBlanco,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide:
                      BorderSide(color: IpueColors.cPrimario, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: IpueColors.cFondo, width: 1.0),
                ),
                // border: OutlineInputBorder(),
                labelText: "Email",
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                prefixIcon: Icon(
                  Icons.person,
                  color: IpueColors.cGris,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              left: 20.0,
              right: 20.0,
              bottom: 10.0,
            ),
            child: TextFormField(
              /*validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'^[A-Za-z0-9]+$').hasMatch(value)) {
                  //allow upper and lower case alphabets and space
                  return "Ingrese una contraseña correcta.";
                } else {
                  return null;
                }
              },*/
              style: const TextStyle(color: IpueColors.cGris),
              controller: controlContrasena,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                filled: true,
                fillColor: IpueColors.cGris,
                focusColor: IpueColors.cBlanco,
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide:
                      BorderSide(color: IpueColors.cPrimario, width: 1.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: IpueColors.cFondo, width: 1.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: IpueColors.cGris,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
                prefixIcon: const Icon(
                  Icons.security,
                  color: IpueColors.cGris,
                ),
                border: const OutlineInputBorder(),
                labelText: "Contraseña",
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ForgatPasswordPage()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(
                top: 10.0,
                left: 20.0,
                right: 20.0,
                bottom: 10.0,
              ),
              child: Text(
                "¡Olvidé mi contraseña!",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: IpueColors.cGris,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void login() async {
    try {
      Map data = {
        "email": controlEmail.text,
        "password": controlContrasena.text
      };
      var body = json.encode(data);

      var url = Uri.parse('${IpueColors.urlHost}/login.php');
      var response = await http.post(url, body: body);
      var decodeJson = jsonDecode(response.body);

      String tituloHome = "IPUE";

      if (decodeJson["success"] == 1) {
        box.write('token', decodeJson["token"]);

        Get.snackbar(
          tituloHome,
          decodeJson["message"],
          margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
          backgroundColor: IpueColors.cSecundario,
          colorText: IpueColors.cBlanco,
          icon: const Icon(
            Icons.info,
            color: IpueColors.cBlanco,
            size: 35,
          ),
          duration: const Duration(seconds: 6),
        );

        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else if ((decodeJson["success"] == 0) &&
          (decodeJson["status"] == 422)) {
        Get.snackbar(
          tituloHome,
          decodeJson["message"],
          margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
          backgroundColor: IpueColors.cWarning,
          colorText: IpueColors.cBlanco,
          icon: const Icon(
            Icons.warning,
            color: IpueColors.cBlanco,
            size: 35,
          ),
          duration: const Duration(seconds: 6),
        );
      } else {
        Get.snackbar(
          tituloHome,
          decodeJson["message"],
          margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
          backgroundColor: IpueColors.cError,
          colorText: IpueColors.cBlanco,
          icon: const Icon(
            Icons.error,
            color: IpueColors.cBlanco,
            size: 35,
          ),
          duration: const Duration(seconds: 6),
        );
      }
    } finally {}
  }

  Widget _btnLogin() {
    return GestureDetector(
      onTap: () {
        if (formKey.currentState!.validate()) {
          login();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 30.0,
        decoration: const BoxDecoration(
          color: IpueColors.cPrimario,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.only(
            top: 14.0,
            bottom: 14.0,
          ),
          child: Text(
            "Entrar",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: IpueColors.cBlanco,
              fontSize: 20.0,
              fontFamily: "Inter",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /////////////////////////
}

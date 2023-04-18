import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:app_ipue/utilities/styles_utils.dart';

class EmailSentPage extends StatefulWidget {
  final String email, password;

  // ignore: use_key_in_widget_constructors
  const EmailSentPage({required this.email, required this.password, super.key});

  @override
  State<EmailSentPage> createState() => _EmailSentPageState();
}

class _EmailSentPageState extends State<EmailSentPage> {
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
                      image: AssetImage("assets/images/email_sent.png"),
                      width: 300.0,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      "Enviar por email",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: IpueColors.cGris,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    const Text(
                      "El correo electrónico ha sido enviado a",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: IpueColors.cGris,
                      ),
                    ),
                    Text(
                      widget.email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: IpueColors.cPrimario,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Por favor, compruebe su email y siga las instrucciones para restablecer su contraseña",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: IpueColors.cGris,
                      ),
                    ),
                    const SizedBox(
                      height: 45.0,
                    ),
                    const Text(
                      "¿Aún no has recibido el email?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: IpueColors.cGris,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    _btnResendEmail(),
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
  Widget _btnResendEmail() {
    return GestureDetector(
      onTap: () {
        recovery();
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 30.0,
        child: const Padding(
          padding: EdgeInsets.only(
            top: 13.0,
            bottom: 13.0,
          ),
          child: Text(
            "Reenviar Email",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: IpueColors.cPrimario,
              fontSize: 20.0,
              fontFamily: "Inter",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> recovery() async {
    try {
      Map data = {"email": widget.email};
      var body = json.encode(data);

      var url = Uri.parse('${IpueColors.urlHost}/recoveryPassword.php');
      var response = await http.post(url, body: body);
      var decodeJson = jsonDecode(response.body);

      String tituloHome = "IPUE";

      if (decodeJson["success"] == 1) {
        Get.snackbar(
          tituloHome,
          decodeJson["message"],
          margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
          backgroundColor: IpueColors.cPrimario,
          colorText: IpueColors.cBlanco,
          icon: const Icon(
            Icons.info,
            color: IpueColors.cBlanco,
            size: 35,
          ),
          duration: const Duration(seconds: 6),
        );
      } else if ((decodeJson["success"] == 0) &&
          (decodeJson["status"] == 422)) {
        Get.snackbar(
          tituloHome,
          decodeJson["message"],
          margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
          backgroundColor: IpueColors.cSecundario,
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
          backgroundColor: IpueColors.cSecundario,
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

  /////////////////////////
}

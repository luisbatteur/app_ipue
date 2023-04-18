import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:app_ipue/pages/EmailSentPage.dart';
import 'package:app_ipue/utilities/styles_utils.dart';

class ForgatPasswordPage extends StatefulWidget {
  const ForgatPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgatPasswordPage> createState() => _ForgatPasswordPageState();
}

class _ForgatPasswordPageState extends State<ForgatPasswordPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController controlEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: ShgUtils.cOscuro),
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
                      image: AssetImage("assets/images/forgot_password.png"),
                      width: 200.0,
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    const Text(
                      "Olvidé mi contraseña",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ShgUtils.cOscuro,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const Text(
                      "Por favor, introduzca su email registrado para restablecer su contraseña",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ShgUtils.cOscuro,
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    _formForgotPassword(),
                    _btnResetPassword(),
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
  Widget _formForgotPassword() {
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
              style: const TextStyle(color: ShgUtils.cOscuro),
              controller: controlEmail,
              decoration: const InputDecoration(
                filled: true,
                fillColor: ShgUtils.cGris,
                focusColor: ShgUtils.cBlanco,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: ShgUtils.cVerde, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide:
                      BorderSide(color: ShgUtils.cGrisFuerte, width: 1.0),
                ),
                // border: OutlineInputBorder(),
                labelText: "Email",
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                prefixIcon: Icon(
                  Icons.email,
                  color: ShgUtils.cOscuro,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 10.0,
              left: 20.0,
              right: 20.0,
              bottom: 10.0,
            ),
            child: Text(
              "Restablecer contraseña",
              textAlign: TextAlign.right,
              style: TextStyle(
                color: ShgUtils.cBlanco,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _btnResetPassword() {
    return GestureDetector(
      onTap: () {
        if (formKey.currentState!.validate()) {
          EasyLoading.show(status: 'cargando...');
          recovery();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 30.0,
        decoration: const BoxDecoration(
          color: ShgUtils.cVerde,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.only(
            top: 13.0,
            bottom: 13.0,
          ),
          child: Text(
            "Restablecer contraseña",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ShgUtils.cBlanco,
              fontSize: 20.0,
              fontFamily: "Inter",
            ),
          ),
        ),
      ),
    );
  }

  Future<void> recovery() async {
    try {
      Map data = {"email": controlEmail.text};
      var body = json.encode(data);

      var url = Uri.parse('${ShgUtils.urlHost}/recoveryPassword.php');
      var response = await http.post(url, body: body);
      var decodeJson = jsonDecode(response.body);

      String tituloHome = "IPUE";

      if (decodeJson["success"] == 1) {
        Get.snackbar(
          tituloHome,
          decodeJson["message"],
          margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
          backgroundColor: ShgUtils.cMsgSuccess,
          colorText: ShgUtils.cBlanco,
          icon: const Icon(
            Icons.info,
            color: ShgUtils.cBlanco,
            size: 35,
          ),
          duration: const Duration(seconds: 6),
        );

        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailSentPage(
                email: controlEmail.text, password: decodeJson["password"]),
          ),
        );
      } else if ((decodeJson["success"] == 0) &&
          (decodeJson["status"] == 422)) {
        Get.snackbar(
          tituloHome,
          decodeJson["message"],
          margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
          backgroundColor: ShgUtils.cMsgWarning,
          colorText: ShgUtils.cBlanco,
          icon: const Icon(
            Icons.warning,
            color: ShgUtils.cBlanco,
            size: 35,
          ),
          duration: const Duration(seconds: 6),
        );
      } else {
        Get.snackbar(
          tituloHome,
          decodeJson["message"],
          margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
          backgroundColor: ShgUtils.cMsgError,
          colorText: ShgUtils.cBlanco,
          icon: const Icon(
            Icons.error,
            color: ShgUtils.cBlanco,
            size: 35,
          ),
          duration: const Duration(seconds: 6),
        );
      }
      EasyLoading.dismiss();
    } finally {
      EasyLoading.dismiss();
    }
  }

  /////////////////////////
}

import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:app_ipue/pages/login_page.dart';
import 'package:app_ipue/utilities/styles_utils.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController controlNombre = TextEditingController();
  TextEditingController controlEmail = TextEditingController();
  TextEditingController controlTelefono = TextEditingController();
  TextEditingController controlContrasena = TextEditingController();

  bool _passwordVisible = false;

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
                      "Crear una cuenta",
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
                    _formRegister(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    _btnRegister(),
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
                        "¿Ya tienes una cuenta?",
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
                              builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "¡Acceder!",
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

  Widget _formRegister() {
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
                    !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                  //allow upper and lower case alphabets and space
                  return "Ingrese un nombre correcto.";
                } else {
                  return null;
                }
              },
              style: const TextStyle(color: IpueColors.cGris),
              controller: controlNombre,
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
                labelText: "Nombre",
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
                  Icons.mail,
                  color: IpueColors.cGris,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 5.0,
              left: 20.0,
              right: 20.0,
            ),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
                        .hasMatch(value)) {
                  //  r'^[0-9]{10}$' pattern plain match number with length 10
                  return "Su telefono no es correcto.";
                } else {
                  return null;
                }
              },
              style: const TextStyle(color: IpueColors.cGris),
              controller: controlTelefono,
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
                labelText: "Telefono",
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                prefixIcon: Icon(
                  Icons.mail,
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
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                        .hasMatch(value)) {
                  //allow upper and lower case alphabets and space
                  return "Ingrese una contraseña correcta.";
                } else {
                  return null;
                }
              },
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
        ],
      ),
    );
  }

  void register() async {
    try {
      Map data = {
        "name": controlNombre.text,
        "email": controlEmail.text,
        "phone": controlTelefono.text,
        "password": controlContrasena.text
      };
      var body = json.encode(data);

      var url = Uri.parse('${IpueColors.urlHost}/register.php');
      var response = await http.post(url, body: body);
      var decodeJson = jsonDecode(response.body);

      String tituloHome = "SoloHayGolf";

      if ((decodeJson["success"] == 1) && (decodeJson["status"] == 201)) {
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

        Get.to(const LoginPage());
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
      EasyLoading.dismiss();
    } finally {
      EasyLoading.dismiss();
    }
  }

  Widget _btnRegister() {
    return GestureDetector(
      onTap: () {
        if (formKey.currentState!.validate()) {
          EasyLoading.show(status: 'cargando...');
          register();
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
            top: 13.0,
            bottom: 13.0,
          ),
          child: Text(
            "Regístrate",
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

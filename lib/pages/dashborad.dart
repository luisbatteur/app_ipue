import 'dart:convert';

import 'package:app_ipue/pages/map_iglesias.dart';
import 'package:app_ipue/utilities/styles_utils.dart';
import 'package:app_ipue/utilities/widgets_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isPressed = false;
  int _value = 0;
  final box = GetStorage();
  late List eventos = [];
  // Eventos eventos = Eventos.fromJson({"error": true, "data": []});

  // VARIABLES DE LOS EVENTOS
  String horaIni = "10:00";
  String horaFin = "14:00";
  String tituloEvento = "Reunión diseño con Daniel";
  List tagsEvento = [
    {
      "tag": "Tabajo",
      "estado": "1",
    },
    {
      "tag": "Yo",
      "estado": "0",
    },
    {
      "tag": "Diario",
      "estado": "0",
    },
    {
      "tag": "Corporativo",
      "estado": "0",
    }
  ];

  @override
  void initState() {
    super.initState();

    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        WidgetUtils.ipueFondo(),
        _panelNombre(),
        _panelBuscar(),
        _panelMainCalendar(),
        _panelItemEvento(),
        _panelBottomMenu(),
      ],
    ));
  }

  ///////////////////////////////////////////
  /// FUNCIONES DE LLAMADAS A LA API

  void seleccionarEvento(int id) {
    final item = eventos.firstWhere((e) => e['id'] == id);
    setState(() {
      horaIni = item['horaInicio'];
      horaFin = item['horaFinal'];
      tituloEvento = item['titulo'];
      tagsEvento = item["tags"];
    });
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/datos/eventos.json');
    final data = await json.decode(response);
    setState(() {
      eventos = data["data"];
    });
  }

  void login() async {
    try {
      Map data = {"email": "fericor@gmail.com", "password": "vekg80sy"};
      var body = json.encode(data);

      var url = Uri.parse('${IpueColors.urlHost}/login.php');
      var response = await http.post(url, body: body);
      var decodeJson = jsonDecode(response.body);

      if (decodeJson["success"] == 1) {
        box.write('token', decodeJson["token"]);
      }
      EasyLoading.dismiss();
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// WIDGET MAIN PAGE
  Widget _panelNombre() {
    return Positioned(
      top: 40,
      left: 10,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "HOLA, FELIX!",
              maxLines: 2,
              style: TextStyle(
                color: IpueColors.cBlanco,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Revise sus planes para hoy",
              style: TextStyle(
                color: IpueColors.cBlanco,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _panelBuscar() {
    return Positioned(
      top: 40,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: IpueColors.cBlanco,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        child: const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.search,
              color: IpueColors.cSecundario,
              size: 40,
            )),
      ),
    );
  }

  Widget _panelMainCalendar() {
    return Positioned(
      top: 230,
      left: 0,
      bottom: 110,
      right: MediaQuery.of(context).size.width - 115,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          children: [
            for (int x = 0; x <= (eventos.length - 1); x++) ...[
              MyRadioListTile<int>(
                  value: x,
                  groupValue: _value,
                  dia: eventos[x]["dia"].toString(),
                  mes: eventos[x]["mes"].toString(),
                  onChanged: (value) {
                    setState(() => _value = value!);
                    seleccionarEvento(eventos[x]["id"]);
                  } // => setState(() => _value = value!),
                  ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _panelItemEvento() {
    return Positioned(
        top: 230,
        left: MediaQuery.of(context).size.width - 280,
        right: 5,
        child: Container(
          decoration: BoxDecoration(
              color: IpueColors.cSecundario,
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$horaIni - $horaFin",
                      style: const TextStyle(
                        color: IpueColors.cBlanco,
                      ),
                    ),
                    const IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.edit,
                        color: IpueColors.cBlanco,
                      ),
                    ),
                  ],
                ),
                Text(
                  tituloEvento,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: IpueColors.cBlanco,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Wrap(
                  children: [
                    for (int x = 0; x <= (tagsEvento.length - 1); x++) ...[
                      WidgetUtils.itemCategoria(tagsEvento[x]["tag"],
                          int.parse(tagsEvento[x]["estado"])),
                    ]
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget _panelBottomMenu() {
    return Positioned(
        bottom: 30,
        left: 10,
        right: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                login();
                EasyLoading.dismiss();
                Get.to(const MapIglesias());
              },
              icon: const Icon(
                Icons.church,
                size: 30,
                color: IpueColors.cBlanco,
              ),
              color: IpueColors.cPrimario,
            ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: IpueColors.cPrimario,
                  borderRadius: BorderRadius.circular(60)),
              child: const IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.add,
                  size: 40,
                  color: IpueColors.cBlanco,
                ),
                color: IpueColors.cPrimario,
              ),
            ),
            const IconButton(
              onPressed: null,
              icon: Icon(
                Icons.calendar_month,
                size: 30,
                color: IpueColors.cBlanco,
              ),
              color: IpueColors.cGris,
            ),
          ],
        ));
  }

  ///////////////////////////////////////////
}

class MyRadioListTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String dia;
  final String mes;
  final ValueChanged<T?> onChanged;

  const MyRadioListTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.dia,
    required this.mes,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () => onChanged(value),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? IpueColors.cBlanco : null,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                        left: 15,
                        right: 25,
                      ),
                      child: Column(
                        children: [
                          Text(
                            dia,
                            style: TextStyle(
                              color: isSelected
                                  ? IpueColors.cFondo
                                  : IpueColors.cBlanco,
                              fontWeight: FontWeight.bold,
                              fontSize: 45,
                            ),
                          ),
                          Text(
                            mes,
                            style: TextStyle(
                              color: isSelected
                                  ? IpueColors.cFondo
                                  : IpueColors.cBlanco,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
        isSelected
            ? Positioned(
                top: 0,
                right: 10,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      color: IpueColors.cPrimario,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: IpueColors.cFondo,
                        width: 4,
                      )),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

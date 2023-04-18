import 'dart:convert';

import 'package:app_ipue/models/agenda_model.dart';
import 'package:app_ipue/pages/detalleAgenda.dart';
import 'package:app_ipue/pages/map_iglesias.dart';
import 'package:app_ipue/utilities/styles_utils.dart';
import 'package:app_ipue/utilities/widgets_utils.dart';
import 'package:app_ipue/widgets/ipueModels.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:speed_dial_fab/speed_dial_fab.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isLoading = true;
  bool isPressed = false;
  int _value = 0;
  final box = GetStorage();
  AgendaModel listAgenda = AgendaModel.fromJson({
    "success": 1,
    "agenda": [
      {
        "id": "1",
        "idUsuario": "6",
        "dia": "15",
        "mes": "Apr",
        "horaInicio": "10:00",
        "horaFinal": "18:00",
        "fechaInicio": "2023-04-15",
        "fechaFinal": "2023-04-15",
        "titulo": "Reunión de diseño con Daniel",
        "descripcion":
            "Preguntar por los diseños para app de la ipue si los puede mejorar.",
        "tags": []
      }
    ]
  });

  // VARIABLES DE LOS EVENTOS
  late DataAgenda itemAgenda;
  String idRegistro = "0";
  String horaIni = "00:00";
  String horaFin = "04:00";
  String tituloEvento = "Evento agendado en el servidor";
  List<Tags> tagsEvento = [];

  bool _switchValue = true;

  late TextEditingController _controllerFechaHoraInicio;

  String _valueChangedFechaHoraInicio = '';
  String _valueToValidateFechaHoraInicio = '';
  String _valueSavedFechaHoraInicio = '';

  late final FirebaseMessaging _messaging;

  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // TODO: handle the received notifications
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print("HOLA2: ");
      print(initialMessage);
      setState(() {});
    }
  }

  @override
  void initState() {
    ////////////
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("HOLA: ");
      print(message);

      setState(() {});
    });
    checkForInitialMessage();
    ////////////
    super.initState();

    _controllerFechaHoraInicio =
        TextEditingController(text: DateTime.now().toString());

    login();
    listarAgendaUsuario();
  }

  /*Future getQue() async {
    if (token1 != null) {
      var url = Uri.parse('${IpueColors.urlHost}/send.php');
      var response = await http.post(url, body: {"date": token1});
      return json.decode(response.body);
    } else {
      print("Token is null");
    }
  }*/

  Future<void> sendNotification() async {
    var datos = {
      'to': '', // value.toString(),
      'notification': {
        'title': 'Asif',
        'body': 'Subscribe to my channel',
      },
      'android': {
        'notification': {
          'notification_count': 23,
        },
      },
      'data': {
        'foo': 'bar',
      }
    };

    var cabeceras = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'key=AAAAcf_slAo:APA91bGkKNt-oKuXRl5pNZnT0RUZqnBMKlVjcN6RE1d2Lf7B8eOBEvz3fv7450FgpeuF0_anix9Wq-GhK7gDZao1NcLTtlY_USYDhOx3gJcDUeocc3MrRAU9R597l2eojhjZ_zLC8Vxe'
    };

    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    await http
        .post(url, headers: cabeceras, body: jsonEncode(datos))
        .then((value) {
      Get.snackbar('IPUE', 'Notificacion enviada con exito!',
          duration: const Duration(seconds: 10));
      if (kDebugMode) {
        var decodeJson = jsonDecode(value.body);
        print(decodeJson);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: isLoading
              ? const Text("")
              : SpeedDialFabWidget(
                  primaryIconCollapse: Icons.close,
                  primaryIconExpand: Icons.add,
                  secondaryIconsList: const [
                    Icons.schedule,
                    Icons.add_task_outlined,
                    Icons.event,
                  ],
                  secondaryIconsText: const [
                    "Recordatorio",
                    "Tarea",
                    "Evento",
                  ],
                  secondaryIconsOnPress: [
                    () => {ipueAgendaRecordatorioModel()},
                    () => {},
                    () => {IpueModel.ipueAgendaModel(context)},
                  ],
                  secondaryBackgroundColor: IpueColors.cPrimario,
                  secondaryForegroundColor: IpueColors.cBlanco,
                  primaryBackgroundColor: IpueColors.cPrimario,
                  primaryForegroundColor: IpueColors.cBlanco,
                ),
          body: isLoading
              ? WidgetUtils.ipuePanelLoading()
              : Stack(
                  children: [
                    WidgetUtils.ipueFondo(),
                    _panelNombre(),
                    _panelBuscar(),
                    _panelMainCalendar(),
                    _panelItemEvento(),
                    _panelBottomMenu(),
                  ],
                )),
    );
  }

  ///////////////////////////////////////////
  /// FUNCIONES DE LLAMADAS A LA API

  void seleccionarEvento(String id) {
    itemAgenda = listAgenda.agenda!.firstWhere((e) => e.id == id);

    setState(() {
      idRegistro = id;
      horaIni = itemAgenda.horaInicio!;
      horaFin = itemAgenda.horaFinal!;
      tituloEvento = itemAgenda.titulo!;
      tagsEvento = itemAgenda.tags!; // .split(" * ");
    });
  }

  void ultimaAgedaOne() {
    setState(() {
      horaIni = listAgenda.agenda![0].horaInicio == null
          ? "00:00"
          : listAgenda.agenda![0].horaInicio!;
      horaFin = listAgenda.agenda![0].horaFinal == null
          ? "00:00"
          : listAgenda.agenda![0].horaFinal!;
      tituloEvento = listAgenda.agenda![0].titulo == null
          ? "Titulo"
          : listAgenda.agenda![0].titulo!;
      tagsEvento =
          listAgenda.agenda![0].tags == null ? [] : listAgenda.agenda![0].tags!;

      isLoading = false;
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
        box.write('idUser', decodeJson["idUser"]);
        box.write('nombre', decodeJson["nombre"]);
        box.write('email', decodeJson["email"]);
      }
    } finally {}
  }

  void listarAgendaUsuario() async {
    try {
      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-Authorization": "ipue ${box.read('token')}",
      };

      Map data = {"idUser": box.read('idUser')};
      var body = json.encode(data);

      var url = Uri.parse('${IpueColors.urlHost}/getAgendaUser.php');
      var response = await http.post(url, headers: headers, body: body);
      var decodeJson = jsonDecode(response.body);

      // setState(() {
      listAgenda = AgendaModel.fromJson(decodeJson);
      // });
    } finally {
      ultimaAgedaOne();
    }
  }

  void guardarAgendaUsuario(String hInicio, hFinal, fInicio, fFinal, titulo,
      descripcion, estado, tipo) async {
    try {
      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-Authorization": "ipue ${box.read('token')}",
      };

      Map data = {
        "idUser": box.read('idUser'),
        "hInicio": hInicio,
        "hFinal": hFinal,
        "fInicio": fInicio,
        "fFinal": fFinal,
        "titulo": titulo,
        "descripcion": descripcion,
        "estado": estado,
        "tipo": tipo,
      };
      var body = json.encode(data);

      var url = Uri.parse('${IpueColors.urlHost}/saveAgenda.php');
      var response = await http.post(url, headers: headers, body: body);
      var decodeJson = jsonDecode(response.body);

      Get.snackbar('IPUE', 'Recordatorio creado con exito!',
          duration: const Duration(seconds: 10));
    } finally {
      listarAgendaUsuario();
    }
  }

  void eliminarAgendaUsuario() async {
    try {
      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-Authorization": "ipue ${box.read('token')}",
      };

      Map data = {"idReg": idRegistro};
      var body = json.encode(data);

      var url = Uri.parse('${IpueColors.urlHost}/deleteAgenda.php');
      var response = await http.post(url, headers: headers, body: body);
      var decodeJson = jsonDecode(response.body);

      Get.snackbar('IPUE', 'Su registro ha sido eliminado con exito!',
          duration: const Duration(seconds: 10));
    } finally {
      listarAgendaUsuario();
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
          children: [
            Text(
              "HOLA, \n${box.read('nombre')}!",
              maxLines: 2,
              style: const TextStyle(
                color: IpueColors.cBlanco,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
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
      right: MediaQuery.of(context).size.width - 95,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          children: [
            for (int x = 0; x <= (listAgenda.agenda!.length - 1); x++) ...[
              MyRadioListTile<int>(
                  value: x,
                  groupValue: _value,
                  dia: listAgenda.agenda![x].dia!,
                  mes: listAgenda.agenda![x].mes!,
                  onChanged: (value) {
                    setState(() => _value = value!);
                    seleccionarEvento(listAgenda.agenda![x].id!);
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
        left: MediaQuery.of(context).size.width - 300,
        right: 5,
        child: Container(
          decoration: BoxDecoration(
              color: IpueColors.cFondo,
              borderRadius: BorderRadius.circular(20)),
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
                    IconButton(
                      onPressed: () {
                        Get.dialog(
                          AlertDialog(
                            title: const Text('IPUE'),
                            content: const Text(
                                '¿Esta seguro que desea eliminar este registro?'),
                            actions: [
                              TextButton(
                                child: const Text("Cancelar"),
                                onPressed: () => Get.back(),
                              ),
                              TextButton(
                                child: const Text("Aceptar"),
                                onPressed: () {
                                  Get.back();
                                  eliminarAgendaUsuario();
                                },
                              ),
                            ],
                          ),
                        );
                        /*Get.defaultDialog(
                          title: "IPUE",
                          middleText: "esto esuj",
                          textConfirm:
                              "Esta seguro que desea eliminar este registro?",
                          onCancel: () {
                            Get.back();
                          },
                          onConfirm: () {
                            eliminarAgendaUsuario();
                          },
                          cancel: const Text(
                            "Cancelar",
                            style: TextStyle(color: IpueColors.cFondo),
                          ),
                          confirm: const Text(
                            "Aceptar",
                            style: TextStyle(color: IpueColors.cPrimario),
                          ),
                        );*/
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: IpueColors.cBlanco,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(DetalleAgenda(
                      agenda: itemAgenda,
                    ));
                  },
                  child: Text(
                    tituloEvento,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: IpueColors.cBlanco,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Wrap(
                  children: [
                    for (int x = 0; x <= (tagsEvento.length - 1); x++) ...[
                      WidgetUtils.itemCategoria(
                          tagsEvento[x].tag!, int.parse(tagsEvento[x].activo!)),
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Get.to(const MapIglesias());
              },
              icon: const Icon(
                Icons.church,
                size: 30,
                color: IpueColors.cBlanco,
              ),
              color: IpueColors.cPrimario,
            ),
            IconButton(
              onPressed: () {
                sendNotification();
              },
              icon: const Icon(
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
  Future<void> ipueAgendaRecordatorioModel() {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // height: 200,
          color: IpueColors.cPrimario,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //////////////////
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: IpueColors.cBlanco,
                      ),
                    ),
                    ElevatedButton(
                        child: const Text('Guardar'),
                        onPressed: () {
                          Get.back();
                          guardarAgendaUsuario(
                              "09:30",
                              "12:00",
                              "2023-05-01",
                              "2023-05-01",
                              "Recordatorio de ir a la iglesia de Burgos",
                              "Hay que instalar las camaras de seguridad para vigilancia de la iglesia",
                              "INICIO",
                              "RECORDATORIO");
                        }),
                  ],
                ),
              ),
              //////////////////
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  style: const TextStyle(
                    color: IpueColors.cBlanco,
                    fontSize: 22,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.amberAccent,
                    hintStyle: TextStyle(
                      color: IpueColors.cBlanco,
                    ),
                    hintText: 'Recuérdame...',
                  ),
                ),
              ),
              //////////////////
              const Divider(
                color: IpueColors.cBlanco,
              ),
              ////////////////////
              Column(
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.schedule,
                          color: IpueColors.cBlanco,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Expanded(
                        child: Text(
                          "Todo el día",
                          style: TextStyle(
                            color: IpueColors.cBlanco,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      StatefulBuilder(
                        builder:
                            (BuildContext context, StateSetter stateSetter) {
                          return Switch(
                            activeColor: IpueColors.cFondo,
                            value: _switchValue,
                            onChanged: (val) {
                              stateSetter(() {
                                _switchValue = val;
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  //////////////////////////////
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                    ),
                    child: DateTimePicker(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: IpueColors.cBlanco),
                      type: _switchValue
                          ? DateTimePickerType.dateTimeSeparate
                          : DateTimePickerType.dateTime,
                      dateMask: 'd MMM, yyyy',
                      controller: _controllerFechaHoraInicio,
                      // initialValue: DateTime.now().toString(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      onChanged: (val) =>
                          setState(() => _valueChangedFechaHoraInicio = val),
                      validator: (val) {
                        setState(
                            () => _valueToValidateFechaHoraInicio = val ?? '');
                        return null;
                      },
                      onSaved: (val) => setState(
                          () => _valueSavedFechaHoraInicio = val ?? ''),
                    ),
                  ),
                ],
              ),
              ////////////////////
              const Divider(
                color: IpueColors.cBlanco,
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        );
      },
    );
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
                        left: 10,
                        right: 20,
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
                              fontSize: 40,
                            ),
                          ),
                          Text(
                            mes,
                            style: TextStyle(
                              color: isSelected
                                  ? IpueColors.cFondo
                                  : IpueColors.cBlanco,
                              fontSize: 14,
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
              height: 10,
            ),
          ],
        ),
        isSelected
            ? Positioned(
                top: -2,
                right: 10,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      color: IpueColors.cPrimario,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: IpueColors.cFondo,
                        width: 3,
                      )),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

import 'dart:convert';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:app_ipue/models/iglesias_model.dart';
import 'package:app_ipue/utilities/styles_utils.dart';
import 'package:app_ipue/utilities/utils.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final pageController = PageController();
  int selectedIndex = 0;

  late final MapController mapController;

  TextEditingController controlBuscar = TextEditingController();
  IglesiasModel listaIglesias =
      IglesiasModel.fromJson({"error": true, "iglesias": []});

  final box = GetStorage();

  late double latitud = double.parse(box.read('myLatitud').toString());
  late double longitud = double.parse(box.read('myLongitud').toString());
  double radio = 2000.0;
  String address = "Mi dirección";
  String numEncontrados = "0";

  var circleMarkers = <CircleMarker>[];

  List<ItemModel> menuItems = [
    ItemModel('复制', Icons.content_copy),
    ItemModel('转发', Icons.send),
    ItemModel('收藏', Icons.collections),
    ItemModel('删除', Icons.delete),
    ItemModel('多选', Icons.playlist_add_check),
    ItemModel('引用', Icons.format_quote),
    ItemModel('提醒', Icons.add_alert),
    ItemModel('搜一搜', Icons.search),
  ];

  @override
  void initState() {
    myInit();
    super.initState();
    mapController = MapController();
  }

  void myInit() async {
    try {
      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-Authorization": "ipue ${box.read('token')}",
      };

      var url = Uri.parse('${ShgUtils.urlHost}/getIglesias.php');
      var response = await http.get(url, headers: headers);
      var decodeJson = jsonDecode(response.body);

      circleMarkers = [
        CircleMarker(
            point: LatLng(latitud, longitud),
            color: Colors.blue.withOpacity(0.7),
            borderStrokeWidth: 2,
            borderColor: Colors.yellow,
            useRadiusInMeter: true,
            radius: radio // 2000 meters | 2 km
            ),
      ];

      setState(() {
        listaIglesias = IglesiasModel.fromJson(decodeJson);
        numEncontrados = listaIglesias.iglesias!.length.toString();
      });
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _panelMap(),
          _panelSearch(),
          _btnMyLocation(),
          _panelIglesias(),
        ],
      ),
    );
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void _myLocation() {
    setState(() {
      latitud = double.parse(box.read('myLatitud').toString());
      longitud = double.parse(box.read('myLongitud').toString());
      mapController.move(LatLng(latitud, longitud), 4);
    });
  }

  void _modificarRadio(double radio) {
    /*mapController
    setState(() {
      radio = radio;
    });*/
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  /* ++++++++++++++++++++++++++++++++++++++++ */

  Widget _panelMap() {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: LatLng(51.509364, -0.128928),
        zoom: 9.2,
      ),
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(
          source: 'OpenStreetMap contributors',
          onSourceTapped: null,
        ),
      ],
      children: <Widget>[
        TileLayer(
          urlTemplate:
              "https://api.mapbox.com/styles/v1/fericor/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
          additionalOptions: const {
            'mapStyleId': AppConstants.mapBoxStyleId,
            'accessToken': AppConstants.mapBoxAccessToken,
          },
        ),
        CircleLayer(
          circles: circleMarkers,
        ),
        MarkerLayer(
          markers: [
            Marker(
              height: 80,
              width: 80,
              point: LatLng(latitud, longitud),
              builder: (_) {
                return const Icon(
                  Icons.location_on,
                  color: ShgUtils.cVerde,
                  size: 25.0,
                );
              },
            ),
            for (int i = 0; i < listaIglesias.iglesias!.length; i++)
              Marker(
                height: 80,
                width: 80,
                point: LatLng(double.parse(listaIglesias.iglesias![i].latitud!),
                    double.parse(listaIglesias.iglesias![i].longitud!)),
                builder: (_) {
                  return GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: SizedBox(
                          height: 200,
                          child: Column(
                            children: [
                              Text(
                                  listaIglesias.iglesias![i].titulo.toString()),
                              Text(listaIglesias.iglesias![i].descripcion
                                  .toString()),
                            ],
                          ),
                        ),
                      ));
                      pageController.animateToPage(
                        i,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                      selectedIndex = i;
                      _animatedMapMove(
                          LatLng(
                              double.parse(listaIglesias.iglesias![i].latitud!),
                              double.parse(
                                  listaIglesias.iglesias![i].longitud!)),
                          11.5);
                      setState(() {});
                    },
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 500),
                      scale: selectedIndex == i ? 1 : 0.7,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: selectedIndex == i ? 1 : 0.5,
                        child: Image.network(
                          "${ShgUtils.urlHost}/images/logos/logo_${listaIglesias.iglesias![i].id}.png?v=1",
                          width: 10,
                          height: 10,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ],
    );
  }

  Widget _panelSearch() {
    return Positioned(
      top: 40,
      left: 20,
      right: 20,
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(10.0, 15.0),
              blurRadius: 35.0,
            ),
          ],
          color: ShgUtils.cBlanco,
          borderRadius: BorderRadius.all(
            Radius.circular(
              10.0,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            top: 0,
            bottom: 0,
            right: 8.0,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: ShgUtils.cVerde,
                ),
              ),
              Expanded(
                child: TextField(
                  style: const TextStyle(color: ShgUtils.cOscuro),
                  controller: controlBuscar,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding:
                        EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 15),
                    hintText: "Buscar iglesias cercanas",
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _modificarRadio(8000);
                },
                child: const Icon(
                  Icons.menu,
                  color: ShgUtils.cVerde,
                ),
              ),
              CustomPopupMenu(
                // ignore: sort_child_properties_last
                child: Container(
                  padding: const EdgeInsets.all(10),
                  constraints:
                      const BoxConstraints(maxWidth: 240, minHeight: 40),
                  decoration: BoxDecoration(
                    color: const Color(0xff98e165),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: const Text("HOLAAAAA"),
                ),
                menuBuilder: _buildLongPressMenu,
                barrierColor: Colors.transparent,
                pressType: PressType.longPress,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLongPressMenu() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 220,
        color: const Color(0xFF4C4C4C),
        child: GridView.count(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          crossAxisCount: 5,
          crossAxisSpacing: 0,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: menuItems
              .map((item) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        item.icon,
                        size: 20,
                        color: Colors.white,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 2),
                        child: Text(
                          item.title,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _btnMyLocation() {
    return Positioned(
      top: 110,
      right: 20,
      child: GestureDetector(
        onTap: () {
          _myLocation();
        },
        child: Container(
          decoration: BoxDecoration(
            color: ShgUtils.cBlanco,
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(10.0, 15.0),
                blurRadius: 35.0,
              ),
            ],
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Padding(
            padding: EdgeInsets.all(6.0),
            child: Icon(
              Icons.my_location_outlined,
              size: 30.0,
              color: ShgUtils.cVerde,
            ),
          ),
        ),
      ),
    );
  }

  Widget _panelIglesias() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 2,
      height: MediaQuery.of(context).size.height * 0.2567,
      child: PageView.builder(
        controller: pageController,
        onPageChanged: (value) {
          selectedIndex = value;
          _animatedMapMove(
              LatLng(double.parse(listaIglesias.iglesias![value].latitud!),
                  double.parse(listaIglesias.iglesias![value].longitud!)),
              11.5);
          setState(() {});
        },
        itemCount: listaIglesias.iglesias!.length,
        itemBuilder: (_, index) {
          final item = listaIglesias.iglesias![index];
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: ShgUtils.cBlanco,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                item.titulo!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                item.direccion!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: 70,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "${ShgUtils.urlHost}/images/iglesias/iglesia_${item.id}.png"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: ShgUtils.cVerde,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            _launchInBrowser(Uri.parse(item.web!));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.web_rounded,
                                  size: 30.0,
                                  color: ShgUtils.cOscuro,
                                ),
                                Text(
                                  "Web",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ShgUtils.cOscuro,
                                  ),
                                ),
                                // Text("139 m"),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _launchInBrowser(Uri.parse(
                                "http://maps.google.com/maps?saddr=$latitud,$longitud&daddr=${item.latitud},${item.longitud}"));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.my_location_rounded,
                                  size: 30.0,
                                  color: ShgUtils.cOscuro,
                                ),
                                Text(
                                  "Como llegar",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ShgUtils.cOscuro,
                                  ),
                                ),
                                // Text("139 m"),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _makePhoneCall(item.telefono!);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.phone,
                                  size: 30.0,
                                  color: ShgUtils.cOscuro,
                                ),
                                Text(
                                  "Llamar",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ShgUtils.cOscuro,
                                  ),
                                ),
                                // Text("+34 633535178"),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  /* ++++++++++++++++++++++++++++++++++++++++ */
}

class ItemModel {
  String title;
  IconData icon;

  ItemModel(this.title, this.icon);
}

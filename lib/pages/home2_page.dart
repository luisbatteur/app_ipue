import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:app_ipue/pages/map_page.dart';
import 'package:app_ipue/pages/splash_page.dart';
import 'package:app_ipue/utilities/styles_utils.dart';

final List<String> imgList = [
  '${ShgUtils.urlHost}/images/publicidades/publi_1.jpg',
  '${ShgUtils.urlHost}images/publicidades/publi_2.jpg',
  '${ShgUtils.urlHost}/images/publicidades/publi_3.jpg'
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final box = GetStorage();
  String location = 'Null, Press Button';
  String address = 'search';

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  Future<void> getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];
    address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    box.write('myAddress', address);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();

    box.write('myLatitud', position.latitude.toString());
    box.write('myLongitud', position.longitude.toString());

    getAddressFromLatLong(position);

    return position;
  }

  void salir() {
    box.remove('token');
    Get.to(const SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(
            left: 25.0,
            right: 35.0,
            top: 30.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _panelTopMenu(),
              _panelWelcome(),
              _panelMainMenu(),
              _panelSlide(),
              _bottomNav(),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////
  Widget _panelTopMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            salir();
          },
          child: Container(
            decoration: const BoxDecoration(
              color: ShgUtils.cGris,
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.menu,
                size: 40.0,
              ),
            ),
          ),
        ),
        const CircleAvatar(
          radius: 25.0,
          backgroundImage: AssetImage("assets/images/avatar.jpg"),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }

  Widget _panelWelcome() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(
          height: 10.0,
        ),
        Text(
          "Hola,",
          style: TextStyle(
            color: ShgUtils.cGrisFuerte,
            fontSize: 25.0,
            fontFamily: "Inter",
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Felix Cortez",
          style: TextStyle(
            color: ShgUtils.cOscuro,
            fontSize: 30.0,
            fontFamily: "Inter",
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _panelMainMenu() {
    return Expanded(
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        children: [
          _itemsMainMenu("Iglesias", Icons.church, ShgUtils.cCeleste),
          _itemsMainMenu("Recursos", Icons.play_circle, ShgUtils.cVerde),
          _itemsMainMenu("Eventos", Icons.calendar_month, ShgUtils.cGris),
          _itemsMainMenu("Unicidad", Icons.one_k, ShgUtils.cCeleste),
        ],
      ),
    );
  }

  Widget _itemsMainMenu(String titulo, IconData icono, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MapPage()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: ShgUtils.cBlanco,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      90.0,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Icon(
                    icono,
                    size: 45.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                titulo,
                style: const TextStyle(
                  color: ShgUtils.cOscuro,
                  fontFamily: "Inter",
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return Container(
      height: 40.0,
      width: MediaQuery.of(context).size.width - 30.0,
      decoration: const BoxDecoration(
        color: ShgUtils.cOscuro,
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: const Icon(
        Icons.home,
        color: ShgUtils.cBlanco,
        size: 25.0,
      ),
    );
  }

  Widget _panelSlide() {
    return CarouselSlider(
      options: CarouselOptions(
        // height: 400,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        // onPageChanged: callbackFunction,
        scrollDirection: Axis.horizontal,
      ),
      items: imgList
          .map((item) => Center(
              child: Image.network(item, fit: BoxFit.cover, width: 1000)))
          .toList(),
    );
  }
  ////////////////////////////////////////////////
}

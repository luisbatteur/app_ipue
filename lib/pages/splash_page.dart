import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:app_ipue/pages/home2_page.dart';
import 'package:app_ipue/pages/login_page.dart';
import 'package:app_ipue/pages/map_page.dart';
import 'package:app_ipue/pages/register_page.dart';
import 'package:app_ipue/utilities/styles_utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final box = GetStorage();
  String location = 'Null, Press Button';
  String address = 'search';

  @override
  void initState() {
    // isLogin();
    // _determinePosition();
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

  // ignore: unused_element
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

    Future.delayed(const Duration(milliseconds: 3000), () {
      EasyLoading.dismiss();
      Get.to(const MapPage());
    });

    return position;
  }

  void isLogin() {
    EasyLoading.show(status: 'cargando...');
    if (box.hasData('token')) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        EasyLoading.dismiss();
        Get.to(const HomePage());
      });
    } else {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage("assets/images/logo.png"),
                          width: 300,
                        ),
                        const Text(
                          "IPUE\nEncuentra una iglesia en cualquier lugar",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: IpueColors.cGris,
                            fontFamily: "Inter",
                            fontSize: 20.0,
                          ),
                        ),
                        const SizedBox(
                          height: 35.0,
                        ),
                        _btnCreateAccount(),
                        const SizedBox(
                          height: 15.0,
                        ),
                        _btnLoginFacebook(),
                      ],
                    ),
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
      ),
    );
  }

  /////////////////////////
  Widget _btnCreateAccount() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterPage()),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 100.0,
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
            "Crea una cuenta",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: IpueColors.cBlanco,
              fontSize: 18.0,
              fontFamily: "Inter",
            ),
          ),
        ),
      ),
    );
  }

  Widget _btnLoginFacebook() {
    return Container(
      width: MediaQuery.of(context).size.width - 100.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: IpueColors.cPrimario,
          width: 2.0,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.facebook,
              size: 30.0,
              color: IpueColors.cPrimario,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              "Continuar con Facebook",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: IpueColors.cPrimario,
                fontSize: 18.0,
                fontFamily: "Inter",
              ),
            ),
          ],
        ),
      ),
    );
  }
  /////////////////////////
}

import 'package:flutter/material.dart';

class Mio extends StatefulWidget {
  const Mio({super.key});

  @override
  State<Mio> createState() => _MioState();
}

class _MioState extends State<Mio> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Hola mundo"));
  }
}
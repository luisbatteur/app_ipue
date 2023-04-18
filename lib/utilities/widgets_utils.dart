import 'package:app_ipue/utilities/styles_utils.dart';
import 'package:flutter/material.dart';

class WidgetUtils {
  static Widget ipueFondo() {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.bottomLeft,
            radius: 3.0,
            // begin: Alignment.topCenter,
            // end: Alignment(0.0, 1.0), // 10% of the width, so there are ten blinds.
            colors: <Color>[
              IpueColors.cFondo,
              IpueColors.cPrimario,
            ], // red to yellow
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
      ),
    );
  }

  static Widget itemCategoria(String item, int activo) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: activo == 1 ? IpueColors.cPrimario : IpueColors.cSecundario,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            item.toUpperCase(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: IpueColors.cBlanco),
          ),
        ),
      ),
    );
  }

  static Widget ipuePanelLoading() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.bottomLeft,
                radius: 3.0,
                colors: <Color>[
                  IpueColors.cFondo,
                  IpueColors.cPrimario,
                ],
                tileMode: TileMode.repeated,
              ),
            ),
          ),
        ),
        const Center(
          child: CircularProgressIndicator(
            backgroundColor: IpueColors.cBlanco,
            color: IpueColors.cPrimario,
            strokeWidth: 5,
          ),
        ),
      ],
    );
  }
}

import 'package:app_ipue/models/agenda_model.dart';
import 'package:app_ipue/utilities/styles_utils.dart';
import 'package:app_ipue/utilities/widgets_utils.dart';
import 'package:flutter/material.dart';

class DetalleAgenda extends StatefulWidget {
  DataAgenda agenda;
  DetalleAgenda({required this.agenda, super.key});

  @override
  State<DetalleAgenda> createState() => _DetalleAgendaState();
}

class _DetalleAgendaState extends State<DetalleAgenda> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.agenda.tipo!),
        backgroundColor: IpueColors.cPrimario,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: isLoading
          ? WidgetUtils.ipuePanelLoading()
          : Stack(
              children: [
                WidgetUtils.ipueFondo(),
                Column(
                  children: [
                    panelTituloDetalle(),
                    panelInformacion(),
                    const Divider(
                      color: IpueColors.cBlanco,
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.task_alt,
                            color: IpueColors.cBlanco,
                            size: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Etiquetas",
                            style: TextStyle(
                              color: IpueColors.cBlanco,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    panelEtiquetas(),
                  ],
                ),
              ],
            ),
    );
  }

  ///////////////////////////////////////////
  /// FUNCIONES DE LLAMADAS A LA API
  Widget panelTituloDetalle() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            widget.agenda.titulo!,
            style: const TextStyle(
                color: IpueColors.cBlanco,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.agenda.descripcion!,
            style: const TextStyle(
              color: IpueColors.cBlanco,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget panelInformacion() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: IpueColors.cFondo,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.date_range,
                    color: IpueColors.cBlanco,
                    size: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.agenda.fechaInicio!,
                    style: const TextStyle(
                      color: IpueColors.cBlanco,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const Divider(
                color: IpueColors.cBlanco,
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_clock,
                    color: IpueColors.cBlanco,
                    size: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${widget.agenda.horaInicio!} - ${widget.agenda.horaFinal!}",
                    style: const TextStyle(
                      color: IpueColors.cBlanco,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget panelEtiquetas() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          color: IpueColors.cBlanco,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Wrap(
          children: [
            WidgetUtils.itemCategoria("Trabajo", 0),
            WidgetUtils.itemCategoria("Negocios", 1),
            WidgetUtils.itemCategoria("Mio", 0),
            WidgetUtils.itemCategoria("Doctrina", 0),
          ],
        ),
      ),
    );
  }

  //////////////////////////////////////////////
}

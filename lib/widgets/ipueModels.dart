import 'package:app_ipue/utilities/styles_utils.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

class IpueModel {
  //////////////////////
  ///
  static Future<void> ipueAgendaModel(myContext) {
    return showModalBottomSheet<void>(
      context: myContext,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.amber,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Modal BottomSheet'),
                ElevatedButton(
                  child: const Text('Close BottomSheet'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> ipueAgendaRecordatorioModel(myContext) {
    return showModalBottomSheet<void>(
      context: myContext,
      builder: (BuildContext context) {
        return Container(
          // height: 200,
          color: IpueColors.cPrimario,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    child: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  ElevatedButton(
                    child: const Text('Guardar'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    fillColor: Colors.amberAccent,
                    hintStyle: TextStyle(
                      color: Color(0xFF6200EE),
                    ),
                    hintText: 'Recuérdame...',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF6200EE)),
                    ),
                  ),
                ),
              ),
              const Divider(
                color: IpueColors.cBlanco,
              ),
              ////////////////////
              Column(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.schedule,
                          color: IpueColors.cBlanco,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          "Todo el día",
                          style: TextStyle(
                            color: IpueColors.cBlanco,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Switch(
                        value: false,
                        activeColor: IpueColors.cFondo,
                        onChanged: null,
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: DateTimePicker(
                      type: DateTimePickerType.dateTimeSeparate,
                      dateMask: 'd MMM, yyyy',
                      initialValue: DateTime.now().toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      selectableDayPredicate: (date) {
                        if (date.weekday == 6 || date.weekday == 7) {
                          return false;
                        }

                        return true;
                      },
                      onChanged: (val) => print(val),
                      validator: (val) {
                        print(val);
                        return null;
                      },
                      onSaved: (val) => print(val),
                    ),
                  )
                ],
              ),
              ////////////////////
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        );
      },
    );
  }

  /////////////////////////
}

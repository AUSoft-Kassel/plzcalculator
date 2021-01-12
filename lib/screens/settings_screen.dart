import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plzcalculator/models/settings.dart';
import 'package:plzcalculator/screens/calculator_screen.dart';

class SettingsScreen extends StatefulWidget {
  static String routeName = '/settings';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Settings _settings = Settings();
  bool _initializedOnStart;
  bool _showEingabefeld = false;
  TextEditingController _inputBoxTextFieldController = TextEditingController();
  // Der nachfolgende Wert wird eh beim Festlegen, dass eine InputBox dargestellt wird,
  // überschrieben. Wir schreiben nur einen Wert in das Feld, weil ansonsten in dem
  // Fall, dass wir manuell hier im Code _showEingabefeld auf true setzen, eine
  // Fehlermeldung wegen Wert null erscheint.
  String _inputBoxTopic = 'Wird eh überschrieben';
  Function _inputBoxInputHandler;

  @override
  void initState() {
    // Das läuft nur einmal und es sagt uns im Prinzip, ob wir am Anfang auf diese
    // Seite (statt dem Calculator) gezwungen wurden oder nicht
    _initializedOnStart = _settings.initialized;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Einstellungen',
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              buildCard(
                title: 'Ausgangsort',
                currentValue: _settings.ausgangsort ?? '',
                currentValueFormattedString: _settings.ausgangsort ?? '',
                times100: false,
                newValueHandler: _settings.setAusgangsort,
              ),
              buildCard(
                title: 'Fahrtkosten / km',
                currentValue: _settings.fahrtkostenKm,
                currentValueFormattedString: _getEuro(_settings.fahrtkostenKm),
                times100: true,
                newValueHandler: _settings.setFahrtkostenKm,
              ),
              buildCard(
                title: 'Fahrtkosten / Stunde',
                currentValue: _settings.fahrtkostenH,
                currentValueFormattedString: _getEuro(_settings.fahrtkostenH),
                times100: true,
                newValueHandler: _settings.setFahrtkostenH,
              ),
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          'Hotelübernachtung?',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Switch(
                        value: _settings.hotel,
                        onChanged: (value) {
                          setState(() {
                            _settings.hotel = value;
                          });
                        },
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
              buildCard(
                title: 'Hotelkosten',
                currentValue: _settings.hotelKosten,
                currentValueFormattedString: _getEuro(_settings.hotelKosten),
                times100: true,
                newValueHandler: _settings.setHotelKosten,
              ),
              buildCard(
                title: 'Hotel ab km',
                currentValue: _settings.hotelAbKm,
                currentValueFormattedString: '${_settings.hotelAbKm} km',
                times100: false,
                newValueHandler: _settings.setHotelAbKm,
              ),
              buildCard(
                title: 'Hotel ab h',
                currentValue: _settings.hotelAbH,
                currentValueFormattedString: '${_settings.hotelAbH} h',
                times100: false,
                newValueHandler: _settings.setHotelAbH,
              ),
              buildCard(
                title: 'Mehrwertsteuersatz',
                currentValue: _settings.mwstSatz,
                currentValueFormattedString: '${_settings.mwstSatz} %',
                times100: false,
                newValueHandler: _settings.setMwstSatz,
              ),
              InkWell(
                onTap: () {
                  if (_initializedOnStart) {
                    _settings.initialized = true;
                    Get.back();
                  } else {
                    _settings.initialized = true;
                    Get.offAllNamed(CalculatorScreen.routeName);
                  }
                },
                child: Card(
                  color: Colors.green[200],
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Änderungen übernehmen. Weiter.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 10,
              ),
            ],
          ),
          if (_showEingabefeld)
            Container(
              color: Colors.grey.withOpacity(0.5),
            ),
          if (_showEingabefeld)
            Center(
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Flex(
                    direction: Axis.vertical,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          _inputBoxTopic,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: Text(
                          'Geben Sie den neuen Wert ein:',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: 300,
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              child: Ink(
                                decoration: ShapeDecoration(
                                  color: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        10,
                                      ),
                                    ),
                                  ),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.cancel_outlined,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showEingabefeld = false;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width: 25,
                            ),
                            Container(
                              width: 150,
                              child: TextField(
                                autocorrect: false,
                                onSubmitted: (String result) {
                                  // Selbe Logik wie unten, nur dass für das
                                  // onSubmitted-Feld wir von Flutter den
                                  //  result-String direkt geliefert bekommen
                                  setState(() {
                                    _inputBoxInputHandler(result);
                                    _showEingabefeld = false;
                                  });
                                },
                                controller: _inputBoxTextFieldController,
                                decoration: InputDecoration(
                                  labelText: 'Ihre Eingabe',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Container(
                              width: 25,
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              child: Ink(
                                decoration: ShapeDecoration(
                                  color: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        10,
                                      ),
                                    ),
                                  ),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.done,
                                  ),
                                  onPressed: () {
                                    // Wir nutzen den gepeicherten Input-Handler und aktualisieren
                                    // damit jeweils den richtigen Wert, auch wenn wir an dieser
                                    // Stelle eigentlich gar nicht wissen, welcher der Setting-Werte
                                    // gerade editiert wird. Das ganze wird verpackt in setState,
                                    // damit sich die GUI updated.
                                    setState(() {
                                      _inputBoxInputHandler(
                                          _inputBoxTextFieldController.text);
                                      _showEingabefeld = false;
                                    });
                                  },
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
        ],
      ),
    );
  }

  InkWell buildCard({
    @required String title,
    @required dynamic currentValue,
    @required String currentValueFormattedString,
    @required Function newValueHandler,
    @required bool times100,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _showInputBox(
            title: title,
            currentValue: currentValue,
            newValueHandler: newValueHandler,
            times100: times100,
          );
        });
      },
      child: Card(
        color: Colors.blue[50],
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Expanded(
                child: Text(currentValueFormattedString,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getEuro(int zahl) {
    int euro = zahl ~/ 100;
    int zcent = (zahl - euro * 100) ~/ 10;
    int cent = zahl - euro * 100 - zcent * 10;
    return '$euro,$zcent$cent Euro';
  }

  void _showInputBox({
    String title,
    dynamic currentValue,
    Function newValueHandler,
    bool times100,
  }) {
    // den Handler, mit dem wir später den Wert wieder in die Settings schreiben,
    // speichern wir zwischen in einer Variablen dieser Klasse
    _inputBoxInputHandler = newValueHandler;
    // Ebenso schreiben wir den Titel in eine lokale Variable, deren Inhalt dann
    // in dem Textfeld angezeigt wird
    _inputBoxTopic = title;
    // Zuerst legen wir fest, wie der bereits vorhandene Wert dargestellt werden soll
    String current = currentValue.toString();
    // Bei Werten wie Euro-Angaben speichern wir ja in echt die Cents als int-Wert.
    // Bei der Eingabe soll aber ein Kommawert eingegeben werden können und daher
    // wird auch der alte Wert als Kommazahl angegeben.
    // Dazu werden zuerst link 0en davor geschrieben, bis der String wenigstens 3
    // Zeichen lang ist, damit auch 1 Cent zu 001 wird.
    if (currentValue is int && times100) {
      while (current.length < 3) {
        current = '0$current';
      }
      // Danach: Alles, bis auf die letzten zwei Zeichen plus Komma plus die letzten zwei Zeichen
      current = current.substring(0, current.length - 2) +
          ',' +
          current.substring(current.length - 2);
    }
    // Dieser Wert wird nun in den TextEditingController geschrieben
    _inputBoxTextFieldController =
        TextEditingController.fromValue(TextEditingValue(text: current));
    // Das Textfeld wird eingeblendet
    setState(() {
      _showEingabefeld = true;
    });
  }
}

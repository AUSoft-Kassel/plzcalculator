import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plzcalculator/models/resultat.dart';

class ResultatScreen extends StatelessWidget {
  static String routeName = '/resultat';
  final Resultat _resultat;

  ResultatScreen(this._resultat);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultat'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Get.offNamed('/settings');
            },
          ),
        ],
      ),
      body: MediaQuery.of(context).orientation == Orientation.landscape
          ? buildBodyLandscape()
          : buildBodyPortrait(),
    );
  }

  SingleChildScrollView buildBodyPortrait() {
    return SingleChildScrollView(
      child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader('Angaben zur Strecke'),
            buildCard(
              'km',
              _resultat.fahrtstrecke.toString(),
            ),
            buildCard('Zeit',
                '${_resultat.fahrtzeit ~/ 60} Stunden, ${_resultat.fahrtzeit % 60} Minuten'
                //_resultat.fahrtkostenZeit.toString(),
                ),
            buildHeader('Angaben zu den Kosten'),
            buildCard(
              'Fahrtkosten (Strecke)',
              '${_resultat.fahrtkostenStrecke ~/ 100},${(_resultat.fahrtkostenStrecke % 100) ~/ 10}${_resultat.fahrtkostenStrecke % 10} €',
              '+',
            ),
            buildCard(
              'Fahrtkosten (Zeit)',
              '${_resultat.fahrtkostenZeit ~/ 100},${(_resultat.fahrtkostenZeit % 100) ~/ 10}${_resultat.fahrtkostenZeit % 10} €',
              '+',
            ),
            buildCard(
              'Hotelkosten',
              '${_resultat.hotelkosten ~/ 100},${(_resultat.hotelkosten % 100) ~/ 10}${_resultat.hotelkosten % 10} €',
              '+',
            ),
            buildDivider(1),
            buildCard(
              'Summe',
              '${_resultat.summe ~/ 100},${(_resultat.summe % 100) ~/ 10}${_resultat.summe % 10} €',
              '=',
            ),
            buildCard(
              'Mehrwertsteuer',
              '${_resultat.mwst ~/ 100},${(_resultat.mwst % 100) ~/ 10}${_resultat.mwst % 10} €',
              '+',
            ),
            buildDivider(2),
            buildCard(
              'Bruttosumme',
              '${_resultat.bruttosumme ~/ 100},${(_resultat.bruttosumme % 100) ~/ 10}${_resultat.bruttosumme % 10} €',
              '=',
            ),
          ]),
    );
  }

  SingleChildScrollView buildBodyLandscape() {
    return SingleChildScrollView(
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader('Angaben zur Strecke'),
                buildCard(
                  'km',
                  _resultat.fahrtstrecke.toString(),
                ),
                buildCard('Zeit',
                    '${_resultat.fahrtzeit ~/ 60} Stunden, ${_resultat.fahrtzeit % 60} Minuten'
                    //_resultat.fahrtkostenZeit.toString(),
                    ),
              ],
            ),
          ),
          Container(
            width: 20,
          ),
          Expanded(
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader('Angaben zu den Kosten'),
                buildCard(
                  'Fahrtkosten (Strecke)',
                  '${_resultat.fahrtkostenStrecke ~/ 100},${(_resultat.fahrtkostenStrecke % 100) ~/ 10}${_resultat.fahrtkostenStrecke % 10} €',
                  '+',
                ),
                buildCard(
                  'Fahrtkosten (Zeit)',
                  '${_resultat.fahrtkostenZeit ~/ 100},${(_resultat.fahrtkostenZeit % 100) ~/ 10}${_resultat.fahrtkostenZeit % 10} €',
                  '+',
                ),
                buildCard(
                  'Hotelkosten',
                  '${_resultat.hotelkosten ~/ 100},${(_resultat.hotelkosten % 100) ~/ 10}${_resultat.hotelkosten % 10} €',
                  '+',
                ),
                buildDivider(1),
                buildCard(
                  'Summe',
                  '${_resultat.summe ~/ 100},${(_resultat.summe % 100) ~/ 10}${_resultat.summe % 10} €',
                  '=',
                ),
                buildCard(
                  'Mehrwertsteuer',
                  '${_resultat.mwst ~/ 100},${(_resultat.mwst % 100) ~/ 10}${_resultat.mwst % 10} €',
                  '+',
                ),
                buildDivider(2),
                buildCard(
                  'Bruttosumme',
                  '${_resultat.bruttosumme ~/ 100},${(_resultat.bruttosumme % 100) ~/ 10}${_resultat.bruttosumme % 10} €',
                  '=',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding buildHeader(String header) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Text(
        header,
        style: TextStyle(
          fontSize: 24,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Padding buildCard(String title, String value, [String operator]) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (operator != null) Text('$operator '),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: operator == null || operator != '='
                    ? FontWeight.normal
                    : FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: operator == null || operator != '='
                      ? FontWeight.normal
                      : FontWeight.bold,
                )),
          ),
        ],
      ),
    );
  }

  Card buildDivider(double height) {
    return Card(
      child: Container(
        width: double.infinity,
        height: height,
        color: Colors.black,
      ),
    );
  }
}

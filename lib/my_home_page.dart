import 'dart:async';
import 'dart:ffi';

import 'package:Monitor/widgets/circularIndicator.dart';
import 'package:Monitor/widgets/clima.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:geolocator/geolocator.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DatabaseReference db_ref;

  late StreamSubscription<DatabaseEvent> sensoresRealTimeSubscription;
  @override
  void initState() {
    init();

    super.initState();
  }

  String temperaturaDescricao = "";
  String condicaoClimatica = "";
  double umidadeSolo = 0.0;
  bool ativaAlerta = false;
  double temperatura = 0.0;
  String status = "";

  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        appBar: AppBar(
          toolbarHeight: 80,
          elevation: 0,
          backgroundColor: Colors.black38,
          title: const Padding(
            padding: EdgeInsets.all(0),
            child: Text(
              'Painel de Monitoramento',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.location_on, color: Colors.red),
              onPressed: () {
                _showMyDialog();
              },
            ),
          ],
        ),
        body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.blue,
        strokeWidth: 4.0,
        onRefresh: () => init(),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CardClima(
                            condicaoClimatica: condicaoClimatica,
                          ),
                          Text(temperaturaDescricao.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 15.0,
                                  overflow: TextOverflow.ellipsis,
                                  color: Color.fromARGB(255, 255, 255, 255)))
                        ],
                      ),
                      Text(
                        "${temperatura.toStringAsFixed(2)} ºC",
                        style: const TextStyle(color: Colors.white, fontSize: 30),
                      )
                    ],
                  ),
                  statusMensagemEstacao(),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 42, 41, 41),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Switch(
                          onChanged: (value) {
                            setState(() {
                              ativaAlerta = !ativaAlerta;
                              setAtivaAlerta(ativaAlerta);
                            });
                          },
                          activeTrackColor: const Color.fromARGB(255, 242, 255, 0),
                          activeColor: const Color.fromARGB(255, 208, 207, 208),
                          value: ativaAlerta,
                        ),
                        !ativaAlerta
                            ? const Text(
                                'Ativar Alerta',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              )
                            : const Text(
                                'Alerta Ativado',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 42, 41, 41),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircularIndicator(valor: double.parse(umidadeSolo.toStringAsFixed(2))),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text("Umidade do Solo",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Color.fromARGB(255, 255, 255, 255))),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Envio da Localização'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Ao confirmar, você enviará a localização da estação de medição.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Sim'),
              onPressed: () {
                salvaLocalizacao();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSquare(Color color, String title, String text) {
    return Container(
      width: 150.0,
      height: 200.0,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8.0), // Espaçamento entre o título e o texto
          Text(
            text,
            style: const TextStyle(
              fontSize: 24.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> init() async {
    db_ref = FirebaseDatabase.instance.ref('SensoresRealTime');

    sensoresRealTimeSubscription = db_ref.onValue.listen(
      (DatabaseEvent event) {
        DataSnapshot climaList = event.snapshot.children
            .firstWhere((element) => element.key == "Clima");

        for (DataSnapshot element in event.snapshot.children) {
          if (element.key == "UmidadeSolo") {
            umidadeSolo = double.parse(element.value.toString());
            if (umidadeSolo > 100 || umidadeSolo < 0) umidadeSolo = 0.0;
          }
          if (element.key == "AtivaAlerta") {
            ativaAlerta = element.value as bool;
          }
          if (element.key == "situacao") {
            status = element.value.toString();
          }
        }
        for (DataSnapshot elementClima in climaList.children) {
          if (elementClima.key == "Descricao") {
            temperaturaDescricao = elementClima.value.toString();
          }
          if (elementClima.key == "Clima") {
            condicaoClimatica = elementClima.value.toString();
          }
          if (elementClima.key == "Temperatura") {
            temperatura = double.parse(elementClima.value.toString());
          }
        }
        setState(() {});
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        setState(() {});
      },
    );
  }

  void setAtivaAlerta(bool alerta) {
    DatabaseReference db_ref =
        FirebaseDatabase.instance.ref('SensoresRealTime/AtivaAlerta');
    db_ref.set(alerta);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Os serviços de localização estão desativados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('As permissões de localização são negadas.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'As permissões de localização são permanentemente negadas, não podemos solicitar permissões.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> salvaLocalizacao() async {
    Position position = await _determinePosition();
    DatabaseReference db_lat =
        FirebaseDatabase.instance.ref('SensoresRealTime/lat');
    DatabaseReference db_long =
        FirebaseDatabase.instance.ref('SensoresRealTime/long');

    db_lat.set(position.latitude.toString());
    db_long.set(position.longitude.toString());
  }

  Color statusEstacao() {
    switch (status) {
      case "Urgente":
        {
          return Colors.red;
        }
      case "Seguro":
        {
          return Colors.green;
        }
      case "Atenção":
        {
          return Color.fromARGB(255, 251, 226, 6);
        }
    }
    return Color.fromARGB(141, 255, 255, 255);
  }

  Widget statusMensagemEstacao() {
    switch (status) {
      case "Urgente":
        {
          return Container(
            height: 100,
          width: double.infinity,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.red,//statusEstacao(),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 30,
                ),
                Text(
                  "Se direcione para um lugar seguro",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          );
        }
      case "Seguro":
        return Container(
          height: 100,
          width: double.infinity,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: Colors.green,//statusEstacao(),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.safety_check, color: Colors.white, size: 30),
              Text(
                "Fique tranquilo, está seguro.",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        );
      case "Atenção":
        return Container(
          height: 100,
          width: double.infinity,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: Colors.yellow,//statusEstacao(),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_outlined,
                color: Color.fromARGB(255, 255, 255, 255),
                size: 30,
              ),
              Text(
                "Redobre a atenção.",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        );
    }
    return SizedBox();
  }
}

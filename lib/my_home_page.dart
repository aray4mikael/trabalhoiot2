import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo de Página',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
          actions: [
            IconButton(
              icon: Icon(Icons.location_on),
              onPressed: () {
                // Implemente a ação desejada para o ícone de localização
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 300,
                  child: Card(
                    elevation: 2.0, // Adicione uma pequena elevação
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                      Switch(
                      onChanged: (value) {
                        setState(() {
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green, value: true,
                    ),
                  
                

                        Text('Ativar o alerta automático'),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  child: Card(
                    elevation: 2.0, // Adicione uma pequena elevação
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Centralize a coluna
                      children: [
                        Text('Umidade do Solo'),
                        SizedBox(height: 8.0),
                        Text(
                          Random().nextInt(101).toString(),
                          // Adicione um número aleatório
                          style: TextStyle(fontSize: 24.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  child: Card(
                    elevation: 2.0, // Adicione uma pequena elevação
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Centralize a coluna
                      children: [
                        Text('Temperatura Média'),
                        SizedBox(height: 8.0),
                        Text(
                          Random().nextInt(101).toString(),
                          // Adicione um número aleatório
                          style: TextStyle(fontSize: 24.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  child: Card(
                    elevation: 2.0, // Adicione uma pequena elevação
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Centralize a coluna
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(height: 32, width: 32, child: Container(color: Colors.green,),),
                            Text('Situação OK'),
                            SizedBox(height: 32, width: 32, child: Container(color: Colors.green,),),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 8.0), // Espaçamento entre o título e o texto
          Text(
            text,
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

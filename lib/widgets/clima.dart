import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'climaItem.dart';

class CardClima extends StatefulWidget {
  String condicaoClimatica = "";
  CardClima({super.key, required this.condicaoClimatica});

  @override
  State<CardClima> createState() => _CardClimaState();
}

class _CardClimaState extends State<CardClima> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: condicaoClimaticaAtual(),
    );
  }

  Widget condicaoClimaticaAtual() {
    switch (widget.condicaoClimatica) {
      case "Rain":
        {
          return ClimaItem(img: "rain.png");
        }
      case "Clouds":
        {
          return ClimaItem(img: "clouds.png");
        }
      case "Clear":
        {
          return ClimaItem(img: "clear.png");
        }
      case "Drizzle":
        {
          return ClimaItem(img: "Drizzle.png");
        }
      case "Thunderstorm":
        {
          return ClimaItem(img: "thundestorm.png");
        }
    }
    return ClimaItem(img: "");
  }
}

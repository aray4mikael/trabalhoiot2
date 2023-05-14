import 'package:flutter/material.dart';

class ClimaItem extends StatefulWidget {
  String img = "";
  ClimaItem({super.key, required this.img});

  @override
  State<ClimaItem> createState() => _ClimaItemState();
}

class _ClimaItemState extends State<ClimaItem> {
  @override
  Widget build(BuildContext context) {
    return widget.img != ""
        ? Image.asset("lib/assets/images/${widget.img}")
        : SizedBox();
  }
}

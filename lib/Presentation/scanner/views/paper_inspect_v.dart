import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PaperInspectView extends StatefulWidget {
  const PaperInspectView({super.key, required this.paper});
  final Uint8List paper;
  @override
  State<PaperInspectView> createState() => _PaperInspectViewState();
}

class _PaperInspectViewState extends State<PaperInspectView> {
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

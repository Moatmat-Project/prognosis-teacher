import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../Core/resources/colors_r.dart';

class CreateEquationView extends StatefulWidget {
  const CreateEquationView({
    super.key,
    required this.result,
    this.equation,
  });
  final String? equation;
  final Function(String result) result;
  @override
  State<CreateEquationView> createState() => _CreateEquationViewState();
}

class _CreateEquationViewState extends State<CreateEquationView> {
  late WebViewControllerPlus _controller;
  late String equation;
  @override
  void initState() {
    //
    equation = widget.equation ?? '';
    //
    _controller = WebViewControllerPlus();
    //
    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    //
    _controller.setBackgroundColor(const Color(0x00000000));
    //
    _controller.enableZoom(false);
    //
    _controller.setOnConsoleMessage((message) {
      setState(() {
        equation = message.message;
      });
    });
    //
    initUri();
    //
    super.initState();
  }

  initUri() async {
    //
    String html = await rootBundle.loadString("assets/math/index.html");
    //
    if (widget.equation?.isNotEmpty ?? false) {
      html = html.replaceAll("f(x)=", widget.equation!);
    }
    //
    final uri = Uri.dataFromString(
      html,
      mimeType: "text/html",
      encoding: Encoding.getByName("utf-8"),
    );
    //
    _controller.loadRequest(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.background,
      appBar: AppBar(
        backgroundColor: ColorsResources.background,
        title: const Text("اضافة معادلة"),
        actions: [
          TextButton(
            onPressed: equation.isEmpty
                ? null
                : () {
                    widget.result(equation);
                    Navigator.of(context).pop();
                  },
            child: const Text("أضافة"),
          ),
        ],
      ),
      body: Container(
        color: ColorsResources.keyboard,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: WebViewWidget(
            controller: _controller,
          ),
        ),
      ),
    );
  }
}

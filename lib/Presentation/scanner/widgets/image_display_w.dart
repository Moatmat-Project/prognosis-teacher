import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:moatmat_teacher/Core/services/channels_s.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/paper.dart';
import 'dart:async';
import '../../../Core/functions/scanner/scanner_state.dart';

class ImageDisplayWidget extends StatefulWidget {
  //
  const ImageDisplayWidget({
    super.key,
    required this.contoursStream,
    this.onCapture,
    required this.controller,
    required this.paperType,
  });
  //
  final PaperType paperType;
  final CameraController controller;
  final Stream<int> contoursStream;
  final Function(List<Uint8List>)? onCapture;

  @override
  State<ImageDisplayWidget> createState() => _ImageDisplayWidgetState();
}

class _ImageDisplayWidgetState extends State<ImageDisplayWidget> {
  //
  final scannerState = ValueNotifier(ScannerState.search);
  //
  late StreamSubscription<int> subscription;
  //

  //
  bool loading = false;

  @override
  void initState() {
    //
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //
      subscription = widget.contoursStream.listen((counter) async {
        //
        if (widget.onCapture == null) return;
        //
        if (onCheck(counter)) {
          //
          scannerState.value = ScannerState.stand;
          //
          onCapture();
        }
        //
      });
    });
    super.initState();
  }

  bool onCheck(int counter) {
    print("count is $counter");
    if (widget.onCapture != null) {
      switch (widget.paperType) {
        case PaperType.A4:
          if (counter == (4 + 2)) {
            scannerState.value = ScannerState.stand;
            return true;
          }
          break;
        case PaperType.A5:
          if (counter == (3 + 2)) {
            scannerState.value = ScannerState.stand;
            return true;
          }
          break;
        case PaperType.A6:
          if (counter == (2 + 2)) {
            scannerState.value = ScannerState.stand;
            return true;
          }
          break;
      }
    }
    scannerState.value = ScannerState.search;
    return false;
  }

  onCapture() async {
    //
    if (loading) return;
    //
    scannerState.value = ScannerState.stand;
    //
    try {
      //
      loading = true;
      //
      final image = await widget.controller.takePicture();
      //
      final response = await ChannelsService.extractImages(
        await image.readAsBytes(),
        widget.paperType,
      );
      //
      if (onCheck(response.length)) {
        widget.onCapture!(response);
      }
      //
      loading = false;
      //
    } catch (e) {
      print("log : f lat $e");
      loading = false;
    }
    scannerState.value = ScannerState.search;
    loading = false;
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //
    final double w = MediaQuery.sizeOf(context).width;

    final double h = (836 / 589) * w;
    //
    return Stack(
      alignment: Alignment.center,
      children: [
        //

        //
        SizedBox(
          width: w,
          child: CameraPreview(widget.controller),
        ),
        //
        ValueListenableBuilder(
          valueListenable: scannerState,
          builder: (context, value, child) {
            return Center(
              child: Container(
                width: w,
                height: h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: w * 0.95,
                        height: getPreviewHeight((w * 0.95)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: scannerColor(value),
                            width: 4,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            scannerStateText(value),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  double getPreviewHeight(double w) {
    double height = 0;
    switch (widget.paperType) {
      case PaperType.A4:
        height = w * 1.3;
      case PaperType.A5:
        height = w * 1.4;
      case PaperType.A6:
        height = w * 1.59;
    }
    return height;
  }
}

enum ScannerState {
  search,
  stand,
}

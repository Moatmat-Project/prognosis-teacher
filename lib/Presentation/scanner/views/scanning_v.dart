import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/services/channels_s.dart';
import "package:camera_platform_interface/src/types/flash_mode.dart" as f;

import 'package:rxdart/subjects.dart';

import '../state/scanner_views_manager_cubit.dart';
import '../widgets/image_display_w.dart';

class ScanningView extends StatefulWidget {
  const ScanningView({super.key, required this.state});
  final ScannerViewsManagerScanning state;
  @override
  State<ScanningView> createState() => _ScanningViewState();
}

class _ScanningViewState extends State<ScanningView> {
  //
  bool startCam = false;
  //
  bool flashOn = true;
  //
  late CameraController controller;
  //
  final contoursController = BehaviorSubject<int>();
  //
  late final Stream<int> contoursStream = contoursController.stream;
  //
  late List<CameraDescription> cameras;
  //
  late Throttler throttler;
  //
  late StreamSubscription<int> timer;
  //
  List<CameraImage> pendingImages = [];
  //
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((t) {
      try {
        //
        throttler = Throttler(milliSeconds: 200);
        //
        initCamera();
      } on Exception catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    });
    //

    //
    super.initState();
  }

  initCamera() async {
    //
    cameras = await availableCameras();
    //
    final cameraDescription = cameras.first;
    //
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.veryHigh,
      enableAudio: false,
      fps: 24,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    //
    await controller.initialize();
    //
    await controller.startImageStream((image) {
      throttler.run(() {
        //
        streamCallBack(image);
      });
    });
    //
    await controller.setFlashMode(f.FlashMode.off);
    //
    await controller.setFlashMode(f.FlashMode.torch);
    //
    setState(() {
      startCam = true;
    });
  }

  streamCallBack(CameraImage image) async {
    try {
      // //
      var contoursLength = await ChannelsService.processImage(
        image,
        widget.state.paperType,
      );
      // //
      if (mounted) {
        contoursController.add(contoursLength);
      }
      //
    } on PlatformException catch (e) {
      //
      debugPrint(
        "==== checkLiveness Method is not implemented ${e.message}",
      );
      //
      return;
      //
    } on Exception {
      //
      return;
    }
  }

  @override
  void dispose() {
    contoursController.close();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (mounted) {
          context.read<ScannerViewsManagerCubit>().showPapers();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black12,
          elevation: 0,
          shadowColor: Colors.transparent,
          foregroundColor: ColorsResources.whiteText2,
          title: const Text(
            "مسح الورقة",
            style: TextStyle(
              color: ColorsResources.whiteText2,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await controller.setFlashMode(
                  flashOn ? f.FlashMode.off : f.FlashMode.torch,
                );
                setState(() {
                  flashOn = !flashOn;
                });
              },
              icon: Icon(flashOn ? Icons.flash_on : Icons.flash_off),
            ),
          ],
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (startCam)
                ImageDisplayWidget(
                  controller: controller,
                  contoursStream: contoursStream,
                  paperType: widget.state.paperType,
                  onCapture: (images) async {
                    if (mounted) {
                      context.read<ScannerViewsManagerCubit>().scanPaper(
                            images,
                          );
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class TestingView extends StatefulWidget {
  const TestingView({Key? key, required this.images}) : super(key: key);
  final List<Uint8List> images;
  @override
  _TestingViewState createState() => _TestingViewState();
}

class _TestingViewState extends State<TestingView> {
  List<Widget> images = [];

  @override
  void initState() {
    widget.images.reversed;
    super.initState();
    fix();
  }

  fix() async {
    //
    images = [];
    //
    for (var i in widget.images) {
      images.add(
        RotatedBox(
          quarterTurns: 1,
          child: Image.memory(i),
        ),
      );
    }
    setState(() {});
  }

  testCutting() async {
    images = [];
    final res = await ChannelsService.analyzeImage(
      image: widget.images[1],
      rows: 25,
      columns: 6,
    );
    for (var r in res) {
      images.add(Row(
        children: r.bubbles.map((e) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
                child: Stack(
              alignment: Alignment.center,
              children: [Image.memory(e.image), Text(e.count.toString())],
            )),
          );
        }).toList(),
      ));
    }
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant TestingView oldWidget) {
    testCutting();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images,
          ),
        ),
      ),
    );
  }
}

class Throttler {
  Throttler({required this.milliSeconds});

  final int milliSeconds;

  int? lastActionTime;

  void run(VoidCallback action) {
    if (lastActionTime == null) {
      action();
      lastActionTime = DateTime.now().millisecondsSinceEpoch;
    } else {
      if (DateTime.now().millisecondsSinceEpoch - lastActionTime! >
          (milliSeconds)) {
        action();
        lastActionTime = DateTime.now().millisecondsSinceEpoch;
      }
    }
  }
}

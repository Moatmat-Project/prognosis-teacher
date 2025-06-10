import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_record.dart';
import 'package:moatmat_teacher/Presentation/attendance/state/set_up_attendance/set_up_attendance_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class ScanningStudentsCodesView extends StatefulWidget {
  const ScanningStudentsCodesView({
    super.key,
    required this.setId,
    required this.onReadRecord,
  });
  final String setId;
  final void Function(AttendanceRecord record) onReadRecord;
  @override
  State<ScanningStudentsCodesView> createState() => _ScanningStudentsCodesViewState();
}

class _ScanningStudentsCodesViewState extends State<ScanningStudentsCodesView> {
  QRViewController? _controller;
  final qrKey = GlobalKey(debugLabel: "QR");
  AttendanceRecord? currentRecord;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider.value(
        value: locator<SetUpAttendanceBloc>(),
        child: BlocBuilder<SetUpAttendanceBloc, SetUpAttendanceState>(
          builder: (context, state) {
            return Stack(
              children: [
                QRView(
                  key: qrKey,
                  overlay: QrScannerOverlayShape(
                    borderWidth: 7.5,
                    borderColor: ColorsResources.primary,
                    borderLength: 35,
                    borderRadius: 6,
                  ),
                  onQRViewCreated: (QRViewController controller) {
                    setState(() {
                      _controller = controller;
                    });
                    _controller!.scannedDataStream.listen((qrCode) async {
                      if (qrCode.code != null) {
                        //
                        final record = AttendanceRecord.fromQrValue(qrCode.code!, widget.setId);
                        //
                        if (currentRecord?.studentId == record.studentId) {
                          return;
                        }
                        //
                        await HapticFeedback.lightImpact();
                        //
                        setState(() {
                          currentRecord = record;
                        });
                        //
                        if (state.records.every((e) => e.studentId != record.studentId)) {
                          widget.onReadRecord(record);
                        }
                      }
                    });
                  },
                ),
                if (currentRecord != null)
                  Align(
                    alignment: Alignment(0.0, 0.75),
                    child: AnimatedOpacity(
                      opacity: currentRecord != null ? 1.0 : 0.0,
                      duration: Durations.medium3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentRecord!.studentName,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: SizesResources.s2),
                          Icon(Icons.check_box, color: Colors.green),
                        ],
                      ),
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller?.pauseCamera();
    } else if (Platform.isIOS) {
      _controller?.resumeCamera();
    }
  }
}

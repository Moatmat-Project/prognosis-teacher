import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/purchase/domain/entities/purchase_item.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/get_my_tests_uc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

part 'export_purchases_event.dart';
part 'export_purchases_state.dart';


class ExportPurchasesBloc extends Bloc<ExportPurchasesEvent, ExportPurchasesState> {

  ExportPurchasesBloc() : super(ExportPurchasesInitial()) {
    on<ExportPurchasesRequested>(_onExportRequested);
  }

  Future<void> _onExportRequested(
    ExportPurchasesRequested event,
    Emitter<ExportPurchasesState> emit,
  ) async {
    emit(ExportPurchasesLoading());

    try {
      // get all tests
      final result = await locator<GetMyTestsUC>().call();
      List<Test> tests = result.fold((l) => [], (r) => r);

      // Create an Excel document
      var excel = Excel.createExcel();
      // Access the sheet named 'resultsSheet'
      Sheet resultsSheet = excel['Sheet1'];

      // Header
      resultsSheet.appendRow([
        // 1 - test id
        TextCellValue("رقم الاختبار"),
        // 2 - test title
        TextCellValue("اسم الاختبار"),
        // 3 - num of purchases
        TextCellValue("عدد عمليات الشراء"),
        // 4 - all amount
        TextCellValue("المجموع"),
      ]);

      // handle all purchases
      for (var test in tests) {
        //
        final relatedPurchases = event.purchases
            .where((p) => p.itemId == test.id.toString())
            .toList();
        //
        final numOfPurchases = relatedPurchases.length;
        final allAmount = relatedPurchases.fold<int>(0, (sum, p) => sum + p.amount);
        //
        resultsSheet.appendRow([
          TextCellValue(test.id.toString()),
          TextCellValue(test.information.title),
          TextCellValue(numOfPurchases.toString()),
          TextCellValue(allAmount.toString()),
        ]);
      }

      // Save the file to the local storage
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/عمليات_الشراء_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      //
      var fileBytes = excel.save();
      //
      if (fileBytes != null) {
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);
      }
      //
      if (kDebugMode) {
        OpenFile.open(filePath);
      } else {
        await Share.shareXFiles([XFile(filePath)]);
      }
      //
      emit(ExportPurchasesSuccess(filePath: filePath));
    } catch (e) {
      emit(ExportPurchasesFailure(message: e.toString()));
    }
  }
}

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/purchase/domain/entities/purchase_item.dart';
import 'package:moatmat_teacher/Features/purchase/domain/usecases/get_test_purchases_by_ids_uc.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/get_my_tests_uc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

part 'export_purchases_event.dart';
part 'export_purchases_state.dart';

class ExportPurchasesBloc extends Bloc<ExportPurchasesEvent, ExportPurchasesInitial> {
  ExportPurchasesBloc() : super(ExportPurchasesInitial(isLoading: false)) {
    on<ExportPurchasesRequested>(_onExportRequested);
    on<ChangeRangeFiltersEvent>(_onChangeRangeFiltersEvent);
  }

  void _onChangeRangeFiltersEvent(
    ChangeRangeFiltersEvent event,
    Emitter<ExportPurchasesInitial> emit,
  ) {
    emit(state.copyWith(
      starting: event.starting ?? state.starting,
      ending: event.ending ?? state.ending,
    ));
  }

  Future<void> _onExportRequested(
    ExportPurchasesRequested event,
    Emitter<ExportPurchasesInitial> emit,
  ) async {
    emit(state.copyWith(isLoading: true, message: null));
    //
    if (event.exportType == 'teacher') {
      try {
        // get all purchase
        List<PurchaseItem> purchases = event.purchases;

        // Create an Excel document
        var excel = Excel.createExcel();
        // Access the sheet named 'resultsSheet'
        Sheet resultsSheet = excel['Sheet1'];

        // Header
        resultsSheet.appendRow([
          // 1 - purchase id
          TextCellValue("رقم الشراء"),
          // 2 - username
          TextCellValue("اسم الطالب"),
          // 3 - amount
          TextCellValue("المبلغ"),
          // 4 - day and month
          TextCellValue("تاريخ يوم/شهر"),
        ]);

        // handle all purchases
        for (var purchase in purchases) {
          resultsSheet.appendRow([
            TextCellValue(purchase.id.toString()),
            TextCellValue(purchase.userName),
            TextCellValue(purchase.amount.toString()),
            TextCellValue(purchase.dayAndMoth),
          ]);
        }

        // Save the file to the local storage
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/عمليات_الشراء_الاشتراكات_${DateTime.now().millisecondsSinceEpoch}.xlsx';
        //
        var fileBytes = excel.save();
        //
        if (fileBytes != null) {
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(fileBytes);
        }
        //
        emit(state.copyWith(isLoading: false));
        //
        if (kDebugMode) {
          OpenFile.open(filePath);
        } else {
          await Share.shareXFiles([XFile(filePath)]);
        }
      } catch (e) {
        emit(state.copyWith(isLoading: false, message: e.toString()));
      }
      return;
    }
    try {
      // get all tests
      final result = await locator<GetMyTestsUC>().call(queryIds: true);
      List<Test> tests = result.fold((l) => [], (r) => r);

      final res = await locator<GetTestPurchasesByIdsUC>().call(testIds: tests.map((e) => e.id).toList());
      List<PurchaseItem> purchases = res.fold((l) => [], (r) => r);

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
        final relatedPurchases = purchases.where((p) => p.itemId == test.id.toString()).toList();
        // print('length of list: ${relatedPurchases.length}');
        //
        final numOfPurchases = relatedPurchases.length;
        final allAmount = relatedPurchases.fold<int>(0, (sum, p) => sum + p.amount);
        //
        // print('Num Of Purchases: $numOfPurchases ,All Amount: $allAmount');
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
      final filePath = '${directory.path}/عمليات_الشراء_الاختبارات_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      //
      var fileBytes = excel.save();
      //
      if (fileBytes != null) {
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);
      }
      //
      emit(state.copyWith(isLoading: false));
      //
      if (kDebugMode) {
        OpenFile.open(filePath);
      } else {
        await Share.shareXFiles([XFile(filePath)]);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, message: e.toString()));
    }
  }
}

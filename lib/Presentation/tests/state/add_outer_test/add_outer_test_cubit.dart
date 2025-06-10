import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Core/errors/exceptions.dart';
import 'package:moatmat_teacher/Features/outer_tests/data/models/outer_question.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test_form.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test_information.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/usecases/add_outer_test_uc.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/usecases/udpate_outer_test.dart';

import '../../../../Core/injection/app_inj.dart';

part 'add_outer_test_state.dart';

class AddOuterTestCubit extends Cubit<AddOuterTestState> {
  AddOuterTestCubit() : super(const AddOuterTestLoading());
  OuterTest? test;
  String teacher = "";
  OuterTestInformation? information;
  List<OuterTestForm> forms = [];
  //
  init({OuterTest? test}) {
    //
    emit(const AddOuterTestLoading());
    //
    this.test = test;
    //
    information = test?.information;
    //
    forms = test?.forms.cast<OuterTestForm>() ?? [];

    emit(AddOuterTestInformation(
      information: information,
      forms: forms,
    ));
  }

  showInformation() {
    emit(AddOuterTestInformation(
      information: information,
      forms: forms,
    ));
  }

  setInformation(OuterTestInformation information, List<OuterTestForm> forms) {
    if (this.forms.isEmpty) {
      this.forms = forms.cast<OuterTestForm>();
    }

    if (this.information?.length != information.length) {
      fixForms(forms);
    }
    if (this.information?.paperType != information.paperType) {
      fixForms(forms);
    }
    if (this.forms.length != forms.length) {
      fixForms(forms);
    }
    //
    this.information = information;
    //
    emit(AddOuterTestViewForms(forms: this.forms));
  }

  setForms(List<OuterTestForm> forms) async {
    this.forms = forms;
    await uploadTest();
  }

  fixForms(List<OuterTestForm> newForms) {
    List<OuterTestForm> result = List.from(forms);
    //
    if (forms.length < newForms.length) {
      for (var i = forms.length; i < newForms.length; i++) {
        result.add(newForms[i]);
      }
    }
    //
    if (forms.length > newForms.length) {
      for (var i = forms.length - 1; i >= newForms.length; i--) {
        result.removeAt(i);
      }
    }
    //
    for (int i = 0; i < result.length; i++) {
      if (result[i].questions.length > newForms[i].questions.length) {
        for (var j = result[i].questions.length - 1; j >= newForms[i].questions.length; j--) {
          result[i].questions.removeAt(j);
        }
      }
      if (result[i].questions.length < newForms[i].questions.length) {
        for (var j = result[i].questions.length; j < newForms[i].questions.length; j++) {
          result[i].questions.add(OuterQuestionModel.fromClass(newForms[i].questions[j]));
        }
      }
    }
    forms = result;
  }

  back(BuildContext context) {
    if (state is AddOuterTestViewForms && test == null) {
      emit(AddOuterTestInformation(information: information, forms: forms));
    } else {
      Navigator.of(context).pop();
    }
  }

  //
  uploadTest() async {
    emit(const AddOuterTestLoading());
    //
    if (test != null) {
      test = test!.copyWith(
        id: test!.id,
        forms: forms,
        information: information!,
      );
      // upload test information
      var res = await locator<UpdateOuterTestUseCase>().call(test: test!);
      //
      res.fold(
        (l) => emit(AddOuterTestError(exception: l)),
        (r) async {
          emit(AddOuterTestDone());
        },
      );
    } else {
      test = OuterTest(
        id: 0,
        information: information!,
        forms: forms,
      );
      // upload test information
      var res = await locator<AddOuterTestUseCase>().call(test: test!);
      //
      res.fold(
        (l) => emit(AddOuterTestError(exception: l)),
        (r) async {
          emit(AddOuterTestDone());
        },
      );
    }

    //s
  }
}

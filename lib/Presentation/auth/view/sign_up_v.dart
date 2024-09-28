import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_options.dart';
import '../../../Core/injection/app_inj.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/texts_resources.dart';
import '../../../Core/validators/email_v.dart';
import '../../../Core/validators/not_empty_v.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';
import '../../../Core/widgets/fields/text_input_field.dart';
import '../../../Features/auth/domain/use_cases/sign_up_uc.dart';
import '../state/auth_c/auth_cubit_cubit.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  //
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //
  late String name;
  late String motherName;
  late String age;
  late String email;
  late String password;
  //
  late String phoneNumber;
  late String whatsappNumber;
  //
  late String schoolName;
  late String classroom;
  late String governorate;
  //
  bool loading = false;
  //
  void onFinish() async {
    setState(() {
      loading = true;
    });
    TeacherData teacherData = TeacherData(
      name: "",
      email: email,
      banksFolders: {},
      testsFolders: {},
      options: TeacherOptions(
        allowInsert: false,
        allowUpdate: false,
        allowDelete: false,
        allowScanning: false,
      ),
      description: '',
      image: '',
      purchaseDescription: '',
      price: 0,
    );
    var query = locator<SignUpUC>().call(
      teacherData: teacherData,
      password: password,
    );
    await query.then((value) {
      value.fold(
        (l) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.text),
            ),
          );
        },
        (r) {
          //
          if (!GetIt.instance.isRegistered<TeacherData>()) {
            locator.registerFactory<TeacherData>(() => r);
          } else {
            GetIt.instance.unregister<TeacherData>();
            locator.registerFactory<TeacherData>(() => r);
          }
          //
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم آنشاء حساب بنجاح"),
            ),
          );
          context.read<AuthCubit>().finishAuth();
        },
      );
    });
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppBarTitles.signUp,
        ),
        leading: IconButton(
          onPressed: () {
            context.read<AuthCubit>().startAuth();
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: SizesResources.s4),
              MyTextFormFieldWidget(
                validator: (p0) {
                  return emailValidator(text: p0);
                },
                hintText: "البريد الالكتروني",
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                onSaved: (p0) {
                  email = p0!;
                },
              ),
              const SizedBox(height: SizesResources.s4),
              MyTextFormFieldWidget(
                validator: (p0) {
                  return notEmptyValidator(text: p0);
                },
                hintText: "الرمز السري",
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                onSaved: (p0) {
                  password = p0!;
                },
              ),
              const SizedBox(height: SizesResources.s4),
              ElevatedButtonWidget(
                loading: loading,
                text: AppBarTitles.signUp,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    onFinish();
                  }
                },
              ),
              const SizedBox(height: SizesResources.s10 * 2),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/resources/sizes_resources.dart';
import '../state/auth_c/auth_cubit_cubit.dart';

class ErrorView extends StatefulWidget {
  const ErrorView({super.key, this.error});
  final String? error;
  @override
  State<ErrorView> createState() => _ErrorViewState();
}

class _ErrorViewState extends State<ErrorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: SizesResources.s10,
            ),
            const Icon(
              Icons.warning,
              size: 40,
            ),
            const SizedBox(
              height: SizesResources.s5,
            ),
            Text(
              widget.error ?? "حصل خطا ما اثناء محاولة الاتصال بالخدام",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: SizesResources.s2,
            ),
            TextButton(
              onPressed: () {
                context.read<AuthCubit>().startAuth();
              },
              child: const Text("اعادة التحميل"),
            ),
          ],
        ),
      ),
    );
  }
}

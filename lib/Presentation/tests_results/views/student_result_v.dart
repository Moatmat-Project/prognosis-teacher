import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/result.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';

class StudentResultView extends StatefulWidget {
  const StudentResultView({
    super.key,
    required this.result,
    required this.userData,
  });
  final Result result;
  final UserData userData;
  @override
  State<StudentResultView> createState() => _StudentResultViewState();
}

class _StudentResultViewState extends State<StudentResultView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

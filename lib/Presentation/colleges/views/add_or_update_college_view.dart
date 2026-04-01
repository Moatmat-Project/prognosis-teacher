import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_teacher/Features/colleges/domain/entities/college.dart';
import 'package:moatmat_teacher/Presentation/colleges/state/college_bloc/college_bloc.dart';
import 'package:moatmat_teacher/Presentation/colleges/widgets/college_form_actions_widget.dart';
import 'package:moatmat_teacher/Presentation/colleges/widgets/college_form_header_widget.dart';

class AddOrUpdateCollegeView extends StatefulWidget {
  final College? college;
  final int? schoolId;

  const AddOrUpdateCollegeView({
    super.key,
    this.college,
    this.schoolId,
  });

  @override
  State<AddOrUpdateCollegeView> createState() => _AddOrUpdateCollegeViewState();
}

class _AddOrUpdateCollegeViewState extends State<AddOrUpdateCollegeView> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _nameController = TextEditingController(text: widget.college?.name);
    _descriptionController =
        TextEditingController(text: widget.college?.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _isUpdating => widget.college != null;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text.trim();
      final String description = _descriptionController.text.trim();
      final int schoolId =
          widget.schoolId!; // School ID is passed from the previous screen

      if (_isUpdating) {
        _updateCollege(name, description, schoolId);
      } else {
        _addCollege(name, description, schoolId);
      }

      Navigator.of(context).pop();
    }
  }

  void _addCollege(String name, String description, int schoolId) {
    final newCollege = College(
      id: 0, // Will be auto-generated
      name: name,
      description: description,
      imageUrl: null, // Can be added later if needed
      schoolId: schoolId,
    );
    context.read<CollegeBloc>().add(AddCollegeEvent(newCollege));
  }

  void _updateCollege(String name, String description, int schoolId) {
    final updatedCollege = College(
      id: widget.college!.id,
      name: name,
      description: description,
      imageUrl: widget.college!.imageUrl, // Keep existing image
      schoolId: schoolId,
    );
    context.read<CollegeBloc>().add(UpdateCollegeEvent(updatedCollege));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isUpdating ? 'تعديل كُلية' : 'اضافة كُلية'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(SpacingResources.sidePadding),
          child: BlocListener<CollegeBloc, CollegeState>(
            listener: (context, state) {
              if (state is CollegeActionSuccess) {
                Navigator.of(context).pop();
              } else if (state is CollegeError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CollegeFormHeader(isUpdating: _isUpdating),
                  const SizedBox(height: SizesResources.s8),
                  MyTextFormFieldWidget(
                    controller: _nameController,
                    hintText: 'ادخل اسم الكُلية',
                    textAlign: TextAlign.right,
                    validator: _validateCollegeName,
                  ),
                  const SizedBox(height: SizesResources.s5),
                  MyTextFormFieldWidget(
                    controller: _descriptionController,
                    hintText: 'ادخل وصف الكُلية',
                    textAlign: TextAlign.right,
                    maxLines: 3,
                    validator: _validateCollegeDescription,
                  ),
                  const SizedBox(height: SizesResources.s8),
                  CollegeFormActions(
                    onCancel: () => Navigator.of(context).pop(),
                    isUpdating: _isUpdating,
                    onSubmit: _submitForm,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateCollegeName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رجاء ادخل اسم الكُلية';
    }
    return null;
  }

  String? _validateCollegeDescription(String? value) {
    // if (value == null || value.trim().isEmpty) {
    //   return 'رجاء ادخل وصف الكُلية';
    // }
    return null;
  }
}

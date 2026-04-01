import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/validators/not_empty_v.dart';
import 'package:moatmat_teacher/Core/widgets/fields/drop_down_w.dart';
import 'package:moatmat_teacher/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_teacher/Core/widgets/view/attach_files_v.dart';
import 'package:moatmat_teacher/Core/widgets/view/material_picker_v.dart';
import 'package:moatmat_teacher/Features/colleges/domain/entities/college.dart';
import 'package:moatmat_teacher/Features/school/domain/entities/school.dart';
import 'package:moatmat_teacher/Features/tests/data/models/video_m.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/mini_test.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/video.dart';
import 'package:moatmat_teacher/Presentation/colleges/state/college_bloc/college_bloc.dart';
import 'package:moatmat_teacher/Presentation/tests/views/pick_mini_test_v.dart';

class SetInformationView extends StatefulWidget {
  const SetInformationView({
    super.key,
    this.title,
    this.classs,
    this.material,
    this.teacher,
    this.schoolId,
    this.schools,
    this.period,
    this.price,
    this.afterSet,
    this.password,
    this.videos,
    this.images,
    this.files,
    this.previous,
    this.isBank = false,
  });
  //
  final String? title;
  final String? classs;
  final String? material;
  final String? teacher;
  final String? schoolId;
  final String? password;
  final int? period;
  final int? price;
  final List<String>? images;
  final List<Video>? videos;
  final List<String>? files;
  final List<School>? schools;
  final MiniTest? previous;
  final bool isBank;
  //
  final Function({
    required String title,
    required String classs,
    required String material,
    required String teacher,
    required String? schoolId,
    required String? collegeId,
    required String? password,
    required int? period,
    required int price,
    required List<String>? images,
    required List<Video>? videos,
    required List<String>? files,
    MiniTest? previous,
  })? afterSet;
  //
  @override
  State<SetInformationView> createState() => _SetInformationViewState();
}

class _SetInformationViewState extends State<SetInformationView> {
  final _formKey = GlobalKey<FormState>();
  String? title;
  String classs = "class";
  String material = "material";
  String? teacher;
  String? schoolId;
  String? collegeId;
  String? password;
  int? period;
  int? price;
  //
  List<String>? images;
  List<Video>? videos;
  List<String>? files;
  MiniTest? previous;
  List<College> colleges = [];
  //
  @override
  void initState() {
    title = widget.title;
    classs = widget.classs ?? "class";
    material = widget.material ?? "material";
    teacher = widget.teacher;
    schoolId = widget.schoolId;
    password = widget.password;
    period = widget.period;
    price = widget.price;
    videos = widget.videos;
    images = widget.images;
    files = widget.files;
    previous = widget.previous;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: widget.isBank
            ? const Text("معلومات البنك الرئيسية")
            : const Text("معلومات الاختبار الرئيسية"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: SizesResources.s2),
              MyTextFormFieldWidget(
                hintText: widget.isBank ? "عنوان البنك" : "عنوان الاختبار",
                textInputAction: TextInputAction.next,
                initialValue: title,
                validator: (p0) {
                  return notEmptyValidator(text: p0);
                },
                onSaved: (p0) {
                  title = p0;
                },
              ),
              const SizedBox(height: SizesResources.s2),
              if (widget.schools?.isNotEmpty != null) ...[
                const SizedBox(height: SizesResources.s2),
                DropDownWidget(
                  hintText: "الجامعة : ",
                  selectedItem: widget.schools
                          ?.where(((e) => e.id.toString() == schoolId))
                          .firstOrNull
                          ?.information
                          .name ??
                      "غير محدد",
                  items: ["غير محدد"] +
                      widget.schools!.map((e) => e.information.name).toList(),
                  onChanged: (p0) {
                    setState(() {
                      schoolId = widget.schools
                          ?.where((e) => e.information.name == p0)
                          .firstOrNull
                          ?.id
                          .toString();
                      // Reset college selection when university changes
                      collegeId = null;
                      colleges = [];
                    });
                    // Fetch colleges for the selected university
                    if (schoolId != null && schoolId != "غير محدد") {
                      context.read<CollegeBloc>().add(
                            FetchCollegesBySchoolId(int.parse(schoolId!)),
                          );
                    }
                  },
                  onSaved: (p0) {
                    setState(() {
                      schoolId = widget.schools
                          ?.where((e) => e.information.name == p0)
                          .firstOrNull
                          ?.id
                          .toString();
                    });
                  },
                ),
                const SizedBox(height: SizesResources.s2),
                // College dropdown - shows only when a university is selected
                if (schoolId != null && schoolId != "غير محدد") ...[
                  BlocConsumer<CollegeBloc, CollegeState>(
                    listener: (context, state) {
                      if (state is CollegeLoaded) {
                        setState(() {
                          colleges = state.colleges;
                        });
                      }
                    },
                    builder: (context, state) {
                      if (state is CollegeLoading) {
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      }
                      return DropDownWidget(
                        hintText: "الكلية : ",
                        selectedItem: colleges
                                .where((e) => e.id.toString() == collegeId)
                                .firstOrNull
                                ?.name ??
                            "غير محدد",
                        items:
                            ["غير محدد"] + colleges.map((e) => e.name).toList(),
                        onChanged: (p0) {
                          setState(() {
                            collegeId = colleges
                                .where((e) => e.name == p0)
                                .firstOrNull
                                ?.id
                                .toString();
                          });
                        },
                        onSaved: (p0) {
                          setState(() {
                            collegeId = colleges
                                .where((e) => e.name == p0)
                                .firstOrNull
                                ?.id
                                .toString();
                          });
                        },
                      );
                    },
                  ),
                ],
              ],
              const SizedBox(height: SizesResources.s2),
              MyTextFormFieldWidget(
                hintText: "مدرس المادة",
                initialValue: teacher,
                textInputAction: TextInputAction.next,
                validator: (p0) {
                  return notEmptyValidator(text: p0);
                },
                onSaved: (p0) {
                  teacher = p0 ?? "unKnown";
                },
              ),
              if (!widget.isBank) ...[
                const SizedBox(height: SizesResources.s2),
                MyTextFormFieldWidget(
                  hintText: "الرمز السري",
                  initialValue: password,
                  textInputAction: TextInputAction.next,
                  onSaved: (p0) {
                    password = p0;
                  },
                ),
              ],
              if (!widget.isBank) ...[
                const SizedBox(height: SizesResources.s2),
                MyTextFormFieldWidget(
                  hintText: "المدة (بالثواني)",
                  initialValue: period?.toString(),
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (p0) {
                    if (p0 == null) return null;
                    if (p0 == "") return null;
                    if (p0 == "0") {
                      return "ادخل وقت صالح";
                    }
                    return null;
                  },
                  onSaved: (p0) {
                    if (p0 == null) return;
                    period = int.tryParse(p0);
                  },
                ),
              ],
              const SizedBox(height: SizesResources.s2),
              MyTextFormFieldWidget(
                hintText: "السعر",
                initialValue: price?.toString(),
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (p0) {
                  int? price = int.tryParse(p0 ?? "0");
                  if (price != null) {
                    if (price > 200000) {
                      return "يرجى ادخال سعر ادنى من 200,000";
                    }
                  }
                  return notEmptyValidator(text: p0);
                },
                onSaved: (p0) {
                  if (p0 == null) return;
                  price = int.tryParse(p0);
                },
              ),
              const SizedBox(height: SizesResources.s2),
              TouchableTileWidget(
                title: "ارفاق صور",
                subTitle: "عدد الصور : ${(images ?? []).length}",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AttachFilesView(
                        type: FileType.image,
                        assets: images ?? [],
                        onSave: (res) {
                          setState(() {
                            images = res;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: SizesResources.s2),
              TouchableTileWidget(
                title: "ارفاق مقاطع فيديو",
                subTitle: "عدد مقاطع الفيديو : ${(videos ?? []).length}",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AttachFilesView(
                        type: FileType.video,
                        assets: videos?.map((e) => e.url).toList() ?? [],
                        onSave: (res) {
                          setState(() {
                            videos =
                                res.map((e) => VideoModel.fromUrl(e)).toList();
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: SizesResources.s2),
              TouchableTileWidget(
                title: "ارفاق ملفات PDF",
                subTitle: "عدد الملفات : ${(files ?? []).length}",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AttachFilesView(
                        type: FileType.any,
                        assets: files ?? [],
                        onSave: (res) {
                          setState(() {
                            files = res;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: SizesResources.s10),
        child: ElevatedButtonWidget(
          text: "تعيين المعلومات",
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState?.save();
              widget.afterSet!(
                title: title!,
                classs: "classs!",
                material: "material!",
                schoolId: schoolId,
                collegeId: collegeId,
                teacher: teacher!,
                password: password,
                period: period,
                price: price!,
                videos: videos,
                files: files,
                previous: previous,
                images: images,
              );
            }
          },
        ),
      ),
    );
  }
}

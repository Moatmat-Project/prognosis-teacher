import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/functions/show_alert.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/paper.dart';
import 'package:moatmat_teacher/Presentation/scanner/state/scanner_views_manager_cubit.dart';

class ScannerResultsView extends StatefulWidget {
  const ScannerResultsView({super.key, required this.state});
  final ScannerViewsManagerPapers state;
  @override
  State<ScannerResultsView> createState() => _ScannerResultsViewState();
}

class _ScannerResultsViewState extends State<ScannerResultsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("النتائج"),
        actions: widget.state.papers.isNotEmpty
            ? [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton(
                    onPressed: () {
                      showAlert(
                        context: context,
                        title: "تاكيد",
                        body: "هل انت متاكد من انك تريد رفع نتائج الاختبار؟",
                        onAgree: () {
                          context.read<ScannerViewsManagerCubit>().uploadPapers();
                        },
                      );
                    },
                    child: const Text("رفع النتائج"),
                  ),
                ),
              ]
            : [],
      ),
      body: BlocConsumer<ScannerViewsManagerCubit, ScannerViewsManagerState>(
        listener: (context, state) {
          if (state is ScannerViewsManagerPapers) {
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error ?? "حصل خطا ما"),
                ),
              );
            }
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: SizesResources.s3),
                child: Row(
                  children: [
                    Text(
                      "عدد الاوراق المصححة : ${widget.state.papers.length}",
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SizesResources.s1),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.state.papers.length,
                  itemBuilder: (context, index) {
                    return ScannerResultWidget(
                      result: widget.state.papers[index],
                      onDelete: () {
                        context.read<ScannerViewsManagerCubit>().removePaper(index);
                      },
                      onTap: () {
                        context.read<ScannerViewsManagerCubit>().explorePaper(index);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.read<ScannerViewsManagerCubit>().showScanning();
        },
        child: const Icon(Icons.document_scanner_outlined),
      ),
    );
  }
}

class ScannerResultWidget extends StatelessWidget {
  const ScannerResultWidget({
    super.key,
    required this.result,
    required this.onTap,
    required this.onDelete,
  });

  final Paper result;
  final VoidCallback onTap, onDelete;
  @override
  Widget build(BuildContext context) {
    return TouchableTileWidget(
      title: (result.student?.name ?? "اسم الطالب"),
      subTitle: "علامة الطالب : %${result.getMark()}",
      icon: IconButton(
          onPressed: () {
            showAlert(
              context: context,
              title: "حذف نتيجة",
              body: "هل انت متاكد من انك تريد حذف النتيجة؟",
              onAgree: onDelete,
            );
          },
          icon: const Icon(
            Icons.delete,
            color: ColorsResources.red,
          )),
      onTap: onTap,
    );
  }
}

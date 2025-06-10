import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/functions/math/mark_to_latter_f.dart';
import '../../../Core/functions/parsers/period_to_text_f.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/widgets/repository_details_item.dart';
import '../../../Core/widgets/toucheable_tile_widget.dart';
import '../../../Core/widgets/view/search_in_results_v.dart';
import '../../../Features/banks/domain/entities/bank.dart';
import '../../export/views/results/choose_export_v.dart';
import '../../students/views/student_v.dart';
import '../../tests_results/views/test_results_v.dart';
import '../state/cubit/bank_results_cubit.dart';
import 'answers_percentage_v.dart';

class BankResultsView extends StatefulWidget {
  const BankResultsView({super.key, required this.bank});
  final Bank bank;
  @override
  State<BankResultsView> createState() => _BankResultsViewState();
}

class _BankResultsViewState extends State<BankResultsView> {
  @override
  void initState() {
    context.read<BankResultsCubit>().init(widget.bank);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BankResultsCubit, BankResultsState>(
        builder: (context, state) {
          if (state is BankResultsInitial) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "نتائج ${widget.bank.information.title}",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChooseExportV(
                            name: widget.bank.information.title,
                            results:
                                state.details.marks.map((e) => e.$1).toList(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.file_open_sharp),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SearchInResultsView(
                            results: state.details.marks.map((e) {
                              return e.$1;
                            }).toList(),
                            onPick: (r) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => StudentView(
                                    userName: r.userName,
                                    userId: r.userId,
                                    result: r,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
              body: RefreshIndicator(
                  onRefresh: () async {
                    context.read<BankResultsCubit>().update();
                    return;
                  },
                  child: Column(
                    children: [
                      RepositoryDetailsItemWidget(
                        averageMark: "%${state.details.averageMark * 100}",
                        averageTime: ((state.details.averageTime)).toInt(),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BankAnswersPercentage(
                                details: state.details,
                                bank: widget.bank,
                              ),
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 5 / 3,
                            crossAxisSpacing: SizesResources.s2,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: SizesResources.s2,
                          ),
                          itemCount: state.details.marks.length,
                          itemBuilder: (context, index) {
                            //
                            return MarkInfoItemWidget(
                              //
                              name: state.details.marks[index].$1.userName,
                              //
                              markLetter: markToLatterFunction(
                                state.details.marks[index].$2,
                              ),
                              mark: "%${state.details.marks[index].$1.mark}",
                              //
                              time: periodToTextFunction(
                                state.details.marks[index].$1.period,
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => StudentView(
                                      userName: widget.bank.information.title,
                                      userId:
                                          state.details.marks[index].$1.userId,
                                      result: state.details.marks[index].$1,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )),
            );
          }
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:moatmat_teacher/Presentation/banks/state/my_banks/my_banks_cubit.dart';
import 'package:moatmat_teacher/Presentation/banks/views/bank_details_v.dart';
import 'package:moatmat_teacher/Presentation/banks/widgets/bank_tile_w.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/widgets/appbar/search_icon_w.dart';
import '../../../Core/widgets/view/search_in_banks_v.dart';
import '../../reports/view/reports_v.dart';
import '../../../Core/widgets/appbar/report_icon_w.dart';
import 'add_bank_view.dart';

class MyBanksView extends StatefulWidget {
  const MyBanksView({super.key});

  @override
  State<MyBanksView> createState() => _MyBanksViewState();
}

class _MyBanksViewState extends State<MyBanksView> {
  @override
  void initState() {
    context.read<MyBanksCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MyBanksCubit, MyBanksState>(
        builder: (context, state) {
          if (state is MyBanksInitial) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("بنوكي"),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SearchInBanksView(
                            banks: state.banks,
                            onPick: (bank) async {
                              await Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => BankDetailsView(
                                    bank: bank,
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
                  context.read<MyBanksCubit>().update();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: state.banks.length,
                  itemBuilder: (context, index) => BankTileWidget(
                    bank: state.banks[index],
                    onPick: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BankDetailsView(
                            bank: state.banks[index],
                          ),
                        ),
                      );

                      if (mounted) {
                        context.read<MyBanksCubit>().update();
                      }
                    },
                  ),
                ),
              ),
            );
          } else if (state is MyBanksError) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                "data",
                textAlign: TextAlign.center,
              )),
            );
          }
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_home,
        children: [
          SpeedDialChild(
            label: "اضافة بنك",
            child: const Icon(Icons.add),
            onTap: () async {
              await Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => const AddBankView(),
                    ),
                  )
                  .then(
                    (value) => context.read<MyBanksCubit>().update(),
                  );
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
        ],
      ),
    );
  }
}

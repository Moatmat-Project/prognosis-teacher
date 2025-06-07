import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Presentation/auth/view/auth_views_manager.dart';

import '../state/auth_c/auth_cubit_cubit.dart';
import '../state/switch_accounts/switch_accounts_bloc.dart';

class SwitchAccountsView extends StatefulWidget {
  const SwitchAccountsView({super.key});

  @override
  State<SwitchAccountsView> createState() => _SwitchAccountsViewState();
}

class _SwitchAccountsViewState extends State<SwitchAccountsView> {
  @override
  void initState() {
    context.read<SwitchAccountsBloc>().add(const SwitchAccountsLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
          context.read<AuthCubit>().init(forceSigning: true);
        },
        backgroundColor: ColorsResources.primary,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('تبديل الحساب'),
      ),
      body: BlocBuilder<SwitchAccountsBloc, SwitchAccountsState>(
        builder: (context, state) {
          if (state is SwitchAccountsLoading) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (state is SwitchAccountsInitial) {
            final accounts = state.accounts;
            return ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: ColorsResources.darkPrimary,
                        width: 2.5,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        radius: 32,
                        backgroundColor: ColorsResources.primary,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            account.email[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        account.email,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: account.email == locator<TeacherData>().email
                          ? Text(
                              "الحساب الحالي",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            )
                          : null,
                      onTap: () {
                        context.read<SwitchAccountsBloc>().add(SwitchAccountsPickAccountEvent(account));
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            );
          }
          return CupertinoActivityIndicator();
        },
      ),
    );
  }
}

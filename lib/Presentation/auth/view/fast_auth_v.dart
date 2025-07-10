import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/services/cache/cache_manager.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/cached_credentials.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import '../../../Core/functions/show_alert.dart';
import '../../../Core/injection/app_inj.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/texts_resources.dart';
import '../../../Core/services/cache/cache_constant.dart';
import '../../../Features/auth/domain/use_cases/sign_in_uc.dart';
import '../state/auth_c/auth_cubit_cubit.dart';

class FastAuthView extends StatefulWidget {
  const FastAuthView({super.key, required this.state});
  final AuthFastAuth state;
  @override
  State<FastAuthView> createState() => _FastAuthViewState();
}

class _FastAuthViewState extends State<FastAuthView> {
  bool loading = false;
  void onPickAccount(CachedCredentials credentials) async {
    setState(() {
      loading = true;
    });
    var query = locator<SignInUC>().call(
      email: credentials.email,
      password: credentials.password,
      saveCredentials: false,
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
        (r) async {
          if (!GetIt.instance.isRegistered<TeacherData>()) {
            locator.registerFactory<TeacherData>(() => r);
          } else {
            GetIt.instance.unregister<TeacherData>();
            locator.registerFactory<TeacherData>(() => r);
          }
          await context.read<AuthCubit>().registerDeviceToken();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم تسجيل الدخول بنجاح"),
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

  void onDeleteAccount(CachedCredentials credentials) async {
    //
    List cachedConditionals = [];
    //
    if (locator<CacheManager>()().exist(CacheConstant.cachedCredentialKey)) {
      cachedConditionals = await locator<CacheManager>()().read(CacheConstant.cachedCredentialKey);
    }
    //
    cachedConditionals.removeWhere((e) => e["email"] == credentials.email);
    //
    await locator<CacheManager>()().write(CacheConstant.cachedCredentialKey, cachedConditionals);
    //
    context.read<AuthCubit>().startFastAuth();
    //
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppBarTitles.changeAccount,
        ),
      ),
      body: loading
          ? const Center(child: CupertinoActivityIndicator())
          : widget.state.accounts.isNotEmpty
              ? ListView.builder(
                  itemCount: widget.state.accounts.length,
                  itemBuilder: (context, index) {
                    final account = widget.state.accounts[index];
                    if (index == widget.state.accounts.length - 1) {
                      return Column(
                        children: [
                          CachedAccountWidget(
                            account: account,
                            onPickAccount: onPickAccount,
                            onDeleteAccount: onDeleteAccount,
                          ),
                          const SizedBox(height: SizesResources.s4),
                          TextButton(
                            onPressed: () {
                              context.read<AuthCubit>().init(forceSigning: true);
                            },
                            child: Text(
                              "اضافة حساب جديد",
                              style: TextStyle(
                                color: ColorsResources.primary,
                                fontSize: SizesResources.s4,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return CachedAccountWidget(
                      account: account,
                      onPickAccount: onPickAccount,
                      onDeleteAccount: onDeleteAccount,
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "لا يوجد حسابات مؤرشفة",
                        style: TextStyle(
                          fontSize: SizesResources.s4,
                        ),
                      ),
                      const SizedBox(height: SizesResources.s4),
                      TextButton(
                        onPressed: () {
                          context.read<AuthCubit>().init(forceSigning: true);
                        },
                        child: Text(
                          "اضافة حساب جديد",
                          style: TextStyle(
                            color: ColorsResources.primary,
                            fontSize: SizesResources.s4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class CachedAccountWidget extends StatelessWidget {
  const CachedAccountWidget({super.key, required this.account, required this.onPickAccount, required this.onDeleteAccount});
  final CachedCredentials account;
  final Function(CachedCredentials) onPickAccount;
  final Function(CachedCredentials) onDeleteAccount;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Card(
        color: ColorsResources.onPrimary,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          trailing: IconButton(
            onPressed: () {
              showAlert(
                context: context,
                title: "تاكيد الحذف",
                body: "هل انت متاكد من حذف الحساب؟",
                onAgree: () {
                  onDeleteAccount(account);
                },
              );
            },
            icon: const Icon(
              Icons.delete,
              color: ColorsResources.red,
            ),
          ),
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
          onTap: () async {
            onPickAccount(account);
          },
        ),
      ),
    );
  }
}

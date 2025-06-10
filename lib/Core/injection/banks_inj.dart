import 'package:moatmat_teacher/Features/banks/data/datasources/banks_remote_ds.dart';
import 'package:moatmat_teacher/Features/banks/data/repository/banks_repository_impl.dart';
import 'package:moatmat_teacher/Features/banks/domain/repository/banks_repository.dart';
import 'package:moatmat_teacher/Features/banks/domain/usecases/delete_bank_uc.dart';
import 'package:moatmat_teacher/Features/banks/domain/usecases/upload_bank_uc.dart';
import '../../Features/banks/domain/usecases/get_bank_by_id_uc.dart';
import '../../Features/banks/domain/usecases/get_banks_by_ids_uc.dart';
import '../../Features/banks/domain/usecases/get_my_banks_uc.dart';
import '../../Features/banks/domain/usecases/update_bank_uc.dart';
import 'app_inj.dart';

injectBanks() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<UploadBankUC>(
    () => UploadBankUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<UpdateBankUC>(
    () => UpdateBankUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetBankByIdUC>(
    () => GetBankByIdUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetMyBanksUC>(
    () => GetMyBanksUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<DeleteBankUC>(
    () => DeleteBankUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetBanksByIdsUC>(
    () => GetBanksByIdsUC(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<BanksRepository>(
    () => BanksRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<BanksRemoteDS>(
    () => BanksRemoteDSImpl(),
  );
}

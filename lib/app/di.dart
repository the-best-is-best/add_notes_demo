import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pos_bank/data/network/dio_manager.dart';
import 'package:pos_bank/data/network/network_info.dart';
import 'package:pos_bank/services/init_sqlite.dart';

import 'cubit/app_cubit.dart';

final di = GetIt.instance;

Future initAppModel() async {
  DioManger.init();
  await GetStorage.init();
  di.registerFactory(() => SqfliteInit());

  await di<SqfliteInit>().initDatabase();
  await di.unregister<SqfliteInit>();

  di.registerFactory<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  di.registerLazySingleton<AppCubit>(() => AppCubit(di(), di()));
}

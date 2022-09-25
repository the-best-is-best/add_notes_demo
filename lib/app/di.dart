import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos_bank/data/network/dio_manager.dart';
import 'package:pos_bank/services/init_sqlite.dart';

import 'cubit/app_cubit.dart';

final di = GetIt.instance;

Future initAppModel() async {
  DioManger.init();
  GetStorage.init();
  di.registerFactory(() => SqfliteInit());

  await di<SqfliteInit>().initDatabase();
  await di.unregister<SqfliteInit>();

  di.registerLazySingleton<AppCubit>(() => AppCubit(di()));
}

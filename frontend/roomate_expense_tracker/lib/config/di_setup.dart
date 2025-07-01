import 'package:api_client/api_client.dart';
import 'package:credentials_repository/credentials_repository.dart';
import 'package:users_repository/users_repository.dart';
import 'package:houses_repository/houses_repository.dart';
import 'package:expenses_repository/expenses_repository.dart';

////////////////////////////////////////////////////////////////////////////
//                                                                        //
//                           PERFECT LINE LLC                             //
//                                                                        //
//           THIS FILE IS AUTO-GENERATED. DO NOT EDIT MANUALLY.           //
//                                                                        //
//  Any changes to this file will be overwritten the next time the code   //
//  is regenerated. If you need to modify behavior, update the source     //
//                         template instead.                              //
//                                                                        //
//                Generated on: 2025-07-01 17:10:50 UTC                   //
//                                                                        //
////////////////////////////////////////////////////////////////////////////

final getIt = GetIt.instance;

void setupDependencies(Isar isarInstance) {
  // Register Isar if not already done. Pass the instance from openIsar().
  // This is typically called from main.dart after Isar.open().
  getIt.registerLazySingleton<Isar>(() => isarInstance);
  // Register CacheManager, which depends on Isar
  getIt.registerLazySingleton<CacheManager>(() => CacheManager(getIt<Isar>()));
  // Register all your repositories as lazy singletons
  getIt.registerLazySingleton<UsersRepository>(
    () => UsersRepository(cacheManager: getIt<CacheManager>()),
  );
  getIt.registerLazySingleton<HousesRepository>(
    () => HousesRepository(cacheManager: getIt<CacheManager>()),
  );
  getIt.registerLazySingleton<ExpensesRepository>(
    () => ExpensesRepository(cacheManager: getIt<CacheManager>()),
  );
  getIt.registerLazySingleton<CredentialsRepository>(
    () => CredentialsRepository(
      cacheManager: getIt<CacheManager>(),
      dio: Dio(),
    ),
  );
}

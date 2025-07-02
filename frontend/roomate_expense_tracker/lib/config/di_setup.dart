import 'package:api_client/api_client.dart';
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
//                Generated on: 2025-07-02 02:59:11 UTC                   //
//                                                                        //
////////////////////////////////////////////////////////////////////////////



final getIt = GetIt.instance;

Future<void> setupDependencies({
  required Isar isarInstance,
  required GoogleSignIn googleSignIn,
  required FirebaseAuth firebaseAuth,
}) async {
  // Register Dependencies
  getIt.registerLazySingleton<Isar>(() => isarInstance);
  getIt.registerLazySingleton<GoogleSignIn>(() => googleSignIn);
  getIt.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);
  // Register CacheManager, which depends on Isar
  getIt.registerLazySingleton<CacheManager>(() => CacheManager(getIt<Isar>()));
  // Register all your repositories as lazy singletons
  getIt.registerSingletonWithDependencies<UsersRepository>(
      () => UsersRepository(
        cacheManager: getIt<CacheManager>(),
      ),
    dependsOn: [CacheManager ],
  );
  getIt.registerSingletonWithDependencies<HousesRepository>(
      () => HousesRepository(
        cacheManager: getIt<CacheManager>(),
      ),
    dependsOn: [CacheManager ],
  );
  getIt.registerSingletonWithDependencies<ExpensesRepository>(
      () => ExpensesRepository(
        cacheManager: getIt<CacheManager>(),
      ),
    dependsOn: [CacheManager ],
  );
}

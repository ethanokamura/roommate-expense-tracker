import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:flutter/foundation.dart';
import 'package:users_repository/users_repository.dart';
import 'package:houses_repository/houses_repository.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:roommate_expense_tracker/app/app.dart';
// Your DI setup
import 'package:roommate_expense_tracker/config/di_setup.dart';
import 'firebase_options.dart';

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

Future<Isar> openIsar() async {
  final dir = await getApplicationSupportDirectory();
  return Isar.open(
    [CachedHttpResponseSchema],
    directory: dir.path,
    inspector: false, // Only enable Isar Inspector in debug mode
  );
}

Future<void> main() async {
  try {
    await bootstrap(
      init: () async {
        try {
          // Perform any necessary setup here
          await dotenv.load();
          // Initialize Isar
          final isar = await openIsar();
          // Initialize Firebase
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
          // Init Google Auth
          final googleSignIn = GoogleSignIn.instance;
          await googleSignIn.initialize();
          // Init Firebase Auth
          final firebaseAuth = FirebaseAuth.instance;
          // Setup Dependency Injection
          await setupDependencies(
            isarInstance: isar,
            googleSignIn: googleSignIn,
            firebaseAuth: firebaseAuth,
          );
          // Trigger initial cache cleanup (optional, but good practice)
          // You might want to control how often this runs (e.g., once a day)
          // using SharedPreferences to store the last cleanup timestamp.
          await getIt<CacheManager>().cleanupAllCaches();
        } catch (e) {
          throw Exception('Database initialization error: $e');
        }
      },
      builder: () async {
        final usersRepository = UsersRepository();
        final housesRepository = HousesRepository();
        final expensesRepository = ExpensesRepository();
        return App(
          usersRepository: usersRepository,
          housesRepository: housesRepository,
          expensesRepository: expensesRepository,
        );
      },
    );
  } catch (e) {
    throw Exception('Fatal error during bootstrap: $e');
  }
}

import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:roommate_expense_tracker/features/home/view/home_page.dart';
import 'package:roommate_expense_tracker/app/cubit/app_cubit.dart';
import 'package:roommate_expense_tracker/features/authentication/authentication.dart';
import 'package:roommate_expense_tracker/theme/theme_cubit.dart';
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



/// Generate pages based on AppStatus
List<Page<dynamic>> onGenerateAppPages(
  AppStatus status,
  List<Page<dynamic>> pages,
) {
  if (status.isUnauthenticated) {
    return [CognitoSignInScreen.page()];
  }
  if (status.isAuthenticated) {
    return [HomePage.page()];
  }
  return pages;
}

class App extends StatelessWidget {
  const App({
    required this.credentialsRepository,
    required this.usersRepository,
    required this.housesRepository,
    required this.expensesRepository,
    super.key,
  });

  final CredentialsRepository credentialsRepository;
  final UsersRepository usersRepository;
  final HousesRepository housesRepository;
  final ExpensesRepository expensesRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CredentialsRepository>.value(
          value: credentialsRepository,
        ),
        RepositoryProvider<UsersRepository>.value(
          value: usersRepository,
        ),
        RepositoryProvider<HousesRepository>.value(
          value: housesRepository,
        ),
        RepositoryProvider<ExpensesRepository>.value(
          value: expensesRepository,
        ),
      ],

      /// Initialize top level providers
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(
            create: (_) => ThemeCubit(),
          ),
          BlocProvider<AppCubit>(
            create: (_) => AppCubit(credentialsRepository: credentialsRepository),
          ),
        ],

        /// Return AppView
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          title: 'Roommate Expense Tracker',
          // onGenerateTitle: (context) => context.l10n.appTitle,
          // localizationsDelegates: const [
          //   AppLocalizations.delegate,
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          //   // GlobalCupertinoLocalizations.delegate
          // ],
          // supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          theme: context.read<ThemeCubit>().themeData,
          home: BlocListener<AppCubit, AppState>(
            listenWhen: (_, current) => current.isFailure,
            listener: (context, state) {
              return switch (state.failure) {
                AuthChangesFailure() =>
                  context.showSnackBar("Failure to authenticate"),
                SignOutFailure() => context.showSnackBar("Failure to sign out"),
                _ => context.showSnackBar("Unknown failure occured"),
              };
            },
            child: BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                return FlowBuilder(
                  onGeneratePages: onGenerateAppPages,
                  state: state.status,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

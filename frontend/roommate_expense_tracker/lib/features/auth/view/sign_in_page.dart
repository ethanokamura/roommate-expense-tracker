import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:roommate_expense_tracker/app/cubit/app_cubit.dart';
import 'package:roommate_expense_tracker/features/auth/cubit/authentication_cubit.dart';
import 'package:users_repository/users_repository.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  static MaterialPage<dynamic> page() =>
      const MaterialPage<void>(child: SignInPage());

  @override
  Widget build(BuildContext context) {
    return DefaultPageView(
      body: BlocProvider(
        create: (context) => AuthCubit(
          usersRepository: context.read<UsersRepository>(),
        ),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.isLoading) {
              context.showSnackBar('Loading...');
            } else if (state.isSuccess) {
              context.showSnackBar('Welcome 🥳🏠');
              context.read<AppCubit>().verifyAuthentication();
            } else if (state.isFailure) {
              context.showSnackBar('Failure to load credentials.');
            }
          },
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const VerticalSpacer(multiple: 15),
                  // Corky Icon Container
                  Container(
                    width: 256,
                    height: 256,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/logos/ret_logo_no_bg.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const VerticalSpacer(),
                  SizedBox(
                    width: 256,
                    child: CustomButton(
                      color: context.theme.accentColor,
                      text: state.isLoading ? 'One Moment' : 'Sign In',
                      onTap: state.isLoading
                          ? null
                          : () => context.read<AuthCubit>().signIn(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

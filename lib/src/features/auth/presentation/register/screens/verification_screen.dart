import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/components/app_button.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../bloc/register_bloc.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  static const routeName = '/verification';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (context) => RegisterBloc(context),
      child: const _VerificationScreen(),
    );
  }
}

class _VerificationScreen extends StatelessWidget {
  const _VerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registerBloc = BlocProvider.of<RegisterBloc>(context);
    return BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
      if (state is LoadingAuthState) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: registerBloc.registerFormKey,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 68,
                  ),
                  SvgPicture.asset(
                    'assets/icons/login.svg',
                    height: 50,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Welcome to Chat App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      letterSpacing: 0.5,
                      color: Color(0xFF223263),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Sign in to continue',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color(0xFF9098B1),
                          letterSpacing: 0.5,
                        ),
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  Pinput(
                    length: 6,
                    onChanged: registerBloc.onChangeSmsCode,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  AppButton(
                    onTap: registerBloc.submitVerificationForm,
                    labelText: 'Sign In',
                  ),
                  const SizedBox(
                    height: 21,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}

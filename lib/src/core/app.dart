import 'package:chatapp/src/config/routes/routes.dart';
import 'package:chatapp/src/config/theme/app_themes.dart';
import 'package:chatapp/src/core/localization/locale_bloc.dart';
import 'package:chatapp/src/core/localization/locale_state.dart';
import 'package:chatapp/src/core/locator.dart';
import 'package:chatapp/src/features/auth/presentation/account/bloc/profile_bloc.dart';
import 'package:chatapp/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'localization/locale_eevent.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.initialRoute,
  });

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleBloc>(
          create: (context) => locator()..add(const ChangeLocaleEvent(locale: Locale('en'))),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => locator(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => locator(),
        ),
      ],
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (_, state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routes: AppRoutes(locator()).routes(),
          locale: state.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          initialRoute: initialRoute,
        ),
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import 'package:data_layer/data_layer.dart';
import 'package:student_app/core/theme/bloc/theme_bloc.dart';
import 'package:bursary_home_ui/enums.dart';
import 'package:student_app/core/theme/bloc/theme_event.dart';
import 'package:student_app/core/theme/bloc/theme_state.dart';
import 'package:student_app/core/theme/theme_preferences.dart';
import 'package:student_app/features/auth/bloc/app_bloc.dart';
import 'package:student_app/features/auth/bloc/sign_in_bloc.dart';
import 'package:student_app/features/profile/bloc/profile_bloc.dart';
import 'package:student_app/features/applications/bloc/applications_bloc.dart';
import 'package:student_app/core/routes/app_router.dart';

import 'firebase_options.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('onEvent -- ${bloc.runtimeType}, ${event}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType}, ${error}, ${stackTrace}');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('onTransition -- ${bloc.runtimeType}, ${transition}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType}, ${change}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Bloc.observer = AppBlocObserver();

  final AuthRepository authRepository = AuthRepository();
  final ProfileRepository profileRepository = ProfileRepository();
  final BursaryRepository bursaryRepository = BursaryRepository();
  final ApplicationRepository applicationRepository = ApplicationRepository();
  final ThemePreferences themePreferences = ThemePreferences();

  final ThemeBloc themeBloc = ThemeBloc(themePreferences: themePreferences);
  themeBloc.add(ThemeStarted());
  final AppBloc appBloc = AppBloc(
    authRepository: authRepository,
    profileRepository: profileRepository,
    themeBloc: themeBloc,
  );
  final ProfileBloc profileBloc = ProfileBloc(
    profileRepository: profileRepository,
    firebaseAuth: fb_auth.FirebaseAuth.instance,
  );
  final ApplicationsBloc applicationsBloc = ApplicationsBloc(
    applicationRepository: applicationRepository,
    firebaseAuth: fb_auth.FirebaseAuth.instance,
    bursaryRepository: bursaryRepository,
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: profileRepository),
        RepositoryProvider.value(value: bursaryRepository),
        RepositoryProvider.value(value: applicationRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>.value(value: themeBloc),
          BlocProvider<AppBloc>.value(value: appBloc),
          BlocProvider<SignInBloc>(
            create: (context) => SignInBloc(authRepository: authRepository),
          ),
          BlocProvider<ProfileBloc>.value(value: profileBloc),

          BlocProvider<ApplicationsBloc>.value(value: applicationsBloc),
        ],
        child: MyApp(
          appBloc: appBloc,
          profileBloc: profileBloc,
          applicationsBloc: applicationsBloc,
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final AppBloc appBloc;
  final ProfileBloc profileBloc;
  final ApplicationsBloc applicationsBloc;

  const MyApp({
    super.key,
    required this.appBloc,
    required this.profileBloc,
    required this.applicationsBloc,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router =
        AppRouter(
          appBloc: widget.appBloc,
          profileBloc: widget.profileBloc,
          applicationsBloc: widget.applicationsBloc,
        ).router;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Bursary Home',
          theme: themeState.themeData,
          routerConfig: _router,
        );
      },
    );
  }
}

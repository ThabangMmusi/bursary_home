import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import 'package:student_app/data/repositories/auth_repository.dart';
import 'package:student_app/data/repositories/profile_repository.dart';
import 'package:student_app/data/repositories/bursary_repository.dart';
import 'package:student_app/data/repositories/application_repository.dart';
import 'package:student_app/features/auth/bloc/auth_bloc.dart';
import 'package:student_app/features/auth/bloc/sign_in_bloc.dart';
import 'package:student_app/features/profile/bloc/profile_bloc.dart';
import 'package:student_app/features/profile/bloc/document_upload_bloc.dart';
import 'package:student_app/features/dashboard/bloc/bursary_bloc.dart';
import 'package:student_app/features/applications/bloc/applications_bloc.dart';
import 'package:student_app/core/routes/app_router.dart';
import 'package:bursary_home_ui/theme/themes.dart';

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
  final AuthBloc authBloc = AuthBloc(authRepository: authRepository);
  final ProfileBloc profileBloc = ProfileBloc(
    profileRepository: profileRepository,
    firebaseAuth: fb_auth.FirebaseAuth.instance,
  );
  final BursaryBloc bursaryBloc = BursaryBloc(
    bursaryRepository: bursaryRepository,
  );
  final ApplicationsBloc applicationsBloc = ApplicationsBloc(
    applicationRepository: applicationRepository,
    firebaseAuth: fb_auth.FirebaseAuth.instance,
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
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<SignInBloc>(
            create: (context) => SignInBloc(authRepository: authRepository),
          ),
          BlocProvider<ProfileBloc>.value(value: profileBloc),
          BlocProvider<DocumentUploadBloc>(
            create:
                (context) =>
                    DocumentUploadBloc(profileRepository: profileRepository),
          ),
          BlocProvider<BursaryBloc>.value(value: bursaryBloc),
          BlocProvider<ApplicationsBloc>.value(value: applicationsBloc),
        ],
        child: MyApp(
          authBloc: authBloc,
          profileBloc: profileBloc,
          applicationsBloc: applicationsBloc,
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final AuthBloc authBloc;
  final ProfileBloc profileBloc;
  final ApplicationsBloc applicationsBloc;

  const MyApp({
    super.key,
    required this.authBloc,
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
          authBloc: widget.authBloc,
          profileBloc: widget.profileBloc,
          applicationsBloc: widget.applicationsBloc,
        ).router;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Bursary Home',
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}

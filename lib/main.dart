import 'package:deardiaryv2/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:deardiaryv2/features/auth/data/datasources/auth_local_datasource_impl.dart';
import 'package:deardiaryv2/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:deardiaryv2/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:deardiaryv2/features/auth/domain/repositories/auth_repository.dart';
import 'package:deardiaryv2/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:deardiaryv2/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:deardiaryv2/features/auth/domain/usecases/get_access_token_usecase.dart';
import 'package:deardiaryv2/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:deardiaryv2/features/auth/domain/usecases/login_usecase.dart';
import 'package:deardiaryv2/features/auth/domain/usecases/logout_usecase.dart';
import 'package:deardiaryv2/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:deardiaryv2/features/auth/domain/usecases/register_usecase.dart';
import 'package:deardiaryv2/features/auth/presentation/providers/auth_provider.dart';
import 'package:deardiaryv2/features/auth/presentation/providers/login_provider.dart';
import 'package:deardiaryv2/features/auth/presentation/providers/profile_provider.dart';
import 'package:deardiaryv2/features/auth/presentation/providers/register_provider.dart';
import 'package:deardiaryv2/features/auth/presentation/screens/login.dart';
import 'package:deardiaryv2/features/auth/presentation/screens/register.dart';
import 'package:deardiaryv2/features/auth/presentation/screens/splash.dart';
import 'package:deardiaryv2/features/diary/data/datasources/diary_local_datasource.dart';
import 'package:deardiaryv2/features/diary/data/datasources/diary_local_datasource_impl.dart';
import 'package:deardiaryv2/features/diary/data/datasources/diary_remote_datasource.dart';
import 'package:deardiaryv2/features/diary/data/datasources/diary_remote_datasource_impl.dart';
import 'package:deardiaryv2/features/diary/data/models/diary_model.dart';
import 'package:deardiaryv2/features/diary/data/repositories/diary_repository_impl.dart';
import 'package:deardiaryv2/features/diary/domain/entities/diary_entry.dart';
import 'package:deardiaryv2/features/diary/domain/repositories/diary_repository.dart';
import 'package:deardiaryv2/features/diary/domain/usecases/add_entry_usecase.dart';
import 'package:deardiaryv2/features/diary/domain/usecases/delete_entry_usecase.dart';
import 'package:deardiaryv2/features/diary/domain/usecases/get_entry_usecase.dart';
import 'package:deardiaryv2/features/diary/domain/usecases/search_entry_usecase.dart';
import 'package:deardiaryv2/features/diary/domain/usecases/sync_entry_usecase.dart';
import 'package:deardiaryv2/features/diary/domain/usecases/update_entry_usecase.dart';
import 'package:deardiaryv2/features/diary/presentation/providers/diary_provider.dart';
import 'package:deardiaryv2/features/diary/presentation/providers/theme_provider.dart';
import 'package:deardiaryv2/features/diary/presentation/screens/profile.dart';
import 'package:deardiaryv2/features/diary/presentation/screens/write.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(DiaryModelAdapter());

  await Hive.openBox<DiaryModel>('diaryBox');

  runApp(
    MultiProvider(
      providers: [
        Provider<Box<DiaryModel>>(
          create: (_) => Hive.box<DiaryModel>('diaryBox'),
        ),
        Provider<AuthRemoteDatasource>(
          create: (context) => AuthRemoteDatasourceImpl(),
        ),
        Provider<AuthLocalDatasource>(
          create: (context) => AuthLocalDatasourceImpl(),
        ),
        Provider<DiaryLocalDatasource>(
          create: (context) =>
              DiaryLocalDatasourceImpl(context.read<Box<DiaryModel>>()),
        ),
        Provider<DiaryRemoteDatasource>(
          create: (context) => DiaryRemoteDatasourceImpl(),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            remote: context.read<AuthRemoteDatasource>(),
            local: context.read<AuthLocalDatasource>(),
          ),
        ),
        Provider<DiaryRepository>(
          create: (context) => DiaryRepositoryImpl(
            local: context.read<DiaryLocalDatasource>(),
            remote: context.read<DiaryRemoteDatasource>(),
            authRepository: context.read<AuthRepository>()
          ),
        ),
        Provider<LoginUsecase>(
          create: (context) => LoginUsecase(context.read<AuthRepository>()),
        ),
        Provider<RegisterUsecase>(
          create: (context) => RegisterUsecase(context.read<AuthRepository>()),
        ),
        Provider<RefreshTokenUsecase>(
          create: (context) =>
              RefreshTokenUsecase(context.read<AuthRepository>()),
        ),
        Provider<LogoutUsecase>(
          create: (context) => LogoutUsecase(context.read<AuthRepository>()),
        ),
        Provider<CheckAuthUsecase>(
          create: (context) => CheckAuthUsecase(context.read<AuthRepository>()),
        ),
        Provider<GetEntryUsecase>(
          create: (context) => GetEntryUsecase(context.read<DiaryRepository>()),
        ),
        Provider<AddEntryUsecase>(
          create: (context) => AddEntryUsecase(context.read<DiaryRepository>(), context.read<AuthRepository>()),
        ),
        Provider<DeleteEntryUsecase>(
          create: (context) => DeleteEntryUsecase(context.read<DiaryRepository>()),
        ),
         Provider<SearchEntryUsecase>(
          create: (context) => SearchEntryUsecase(context.read<DiaryRepository>()),
        ),
        Provider<UpdateEntryUsecase>(
          create: (context) =>
              UpdateEntryUsecase(context.read<DiaryRepository>()),
        ),
        Provider<GetAccessTokenUsecase>(
          create: (context) =>
              GetAccessTokenUsecase(context.read<AuthRepository>()),
        ),
        Provider<GetCurrentUserUsecase>(
          create: (context) =>
              GetCurrentUserUsecase(context.read<AuthRepository>()),
        ),
        Provider<SyncEntryUsecase>(
          create: (context) =>
              SyncEntryUsecase(context.read<DiaryRepository>()),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            context.read<CheckAuthUsecase>(),
            context.read<LogoutUsecase>(),
          ),
        ),
        ChangeNotifierProvider<LoginProvider>(
          create: (context) => LoginProvider(context.read<LoginUsecase>()),
        ),
        ChangeNotifierProvider<RegisterProvider>(
          create: (context) =>
              RegisterProvider(context.read<RegisterUsecase>()),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DiaryProvider(
            getEntryUsecase: context.read<GetEntryUsecase>(),
            addEntryUsecase: context.read<AddEntryUsecase>(),
            deleteEntryUsecase: context.read<DeleteEntryUsecase>(),
            updateEntryUsecase: context.read<UpdateEntryUsecase>(),
            syncEntryUsecase: context.read<SyncEntryUsecase>(),
            searchEntryUsecase: context.read<SearchEntryUsecase>()

          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(
            context.read<GetCurrentUserUsecase>(),
            context.read<GetAccessTokenUsecase>(),
            context.read<LogoutUsecase>()
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/write') {
          final entry = settings.arguments as DiaryEntry?;
          return MaterialPageRoute(builder: (_) => WriteScreen(entry: entry));
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.1,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.1,
          ),
        ),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 94, 117, 249),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.2,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
          ),
        ),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF10182b),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: themeProvider.themeMode,
    );
  }
}

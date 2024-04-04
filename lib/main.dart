import 'package:flutter/material.dart';
import 'package:moatmat_teacher/views/home_v.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://kckjiyqmxbrhsrbdlujw.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtja2ppeXFteGJyaHNyYmRsdWp3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDY1NTUyNjEsImV4cCI6MjAyMjEzMTI2MX0._Q_LS0jLZEzfBU1atsCkIN-zFjcu0wga9UNep2-K9Lw",
    debug: false,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff6199DB),
        ),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff6199DB),
            fixedSize: Size(
              MediaQuery.sizeOf(context).width - 16,
              50,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
              side: const BorderSide(
                width: 0.5,
              ),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ar"),
      ],
      home: const HomeView(),
    );
  }
}

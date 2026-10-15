import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubit/note_cubit.dart';
import 'package:note_app/screens/onboarding_screen.dart';
import 'package:note_app/theme.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
// باقي الـ imports زي ما هي

void main() {
  if (kIsWeb) databaseFactory = databaseFactoryFfiWeb;
  runApp(const NotesApp());
}

// باقي الـ imports زي ما هي

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => NoteCubit()..loadNotes()),
      BlocProvider(create: (_) => EventCubit()..load()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const OnboardingScreen(),
    ),
  );
}

import 'package:festively/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light().copyWith(
        cardColor: Colors.black,
        appBarTheme: const AppBarTheme(
          color: Colors.black,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          iconColor: Colors.black,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(
              Colors.black,
            ),
          ),
        ),
      ),
      dark: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF80CBC4),
        cardColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          iconColor: Color(0xFF80CBC4),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF80CBC4)),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(
              const Color(0xFF80CBC4),
            ),
          ),
        ),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

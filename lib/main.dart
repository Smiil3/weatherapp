import 'package:flutter/material.dart';
import 'feature/weather/screens/home_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Météo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.bgDeep,
        colorScheme: const ColorScheme.dark(
          primary:   AppColors.skyBlue,
          secondary: AppColors.iceBlue,
          surface:   AppColors.bgCard,
          error:     AppColors.error,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bgMid,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          iconTheme: IconThemeData(color: AppColors.iconPrimary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.skyBlue,
            foregroundColor: AppColors.bgDeep,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.bgGlass,
          hintStyle: TextStyle(color: AppColors.textMuted),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide(color: AppColors.skyBlue, width: 1.5),
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.bgCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            side: BorderSide(color: AppColors.border),
          ),
        ),
        dividerTheme: const DividerThemeData(color: AppColors.divider),
        textTheme: const TextTheme(
          bodyLarge:   TextStyle(color: AppColors.textPrimary),
          bodyMedium:  TextStyle(color: AppColors.textSecondary),
          titleLarge:  TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
          titleMedium: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
          labelSmall:  TextStyle(color: AppColors.textMuted),
        ),
        iconTheme: const IconThemeData(color: AppColors.iconPrimary),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.bgCard,
          contentTextStyle: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

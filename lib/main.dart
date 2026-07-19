import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sephsuu_care/core/network/network_checker.dart';
import 'package:sephsuu_care/features/initial/landing_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sephsuu Care',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      home: const LandingScreen(),
    );
  }
}


void startSyncListener({
  required NetworkService networkService,
}) {
  networkService.onConnectionChanged.listen((results) async {
    final hasInternet = !results.contains(ConnectivityResult.none);

    if (hasInternet) {
      // await allergyRepository.syncPendingOperations();
    }
  });
}
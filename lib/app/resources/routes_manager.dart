import 'package:flutter/material.dart';
import 'package:pos_bank/presentation/add_note/screen/add_note_screen.dart';
import 'package:pos_bank/presentation/add_user/screen/add_user_screen.dart';
import 'package:pos_bank/presentation/home/screen/home_screen.dart';
import 'package:pos_bank/presentation/setting/setting_screen.dart';

class Routes {
  static const String mainRoute = '/';
  static const String editNoteScreen = '/editNoteScreen';
  static const String addUserScreen = '/addUserScreen';
  static const String addNoteScreen = '/addNoteScreen';
  static const String settingScreen = '/settingScreen';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.mainRoute:
        return MaterialPageRoute(
          builder: (_) => const AppScreen(),
        );
      case Routes.addUserScreen:
        return MaterialPageRoute(
          builder: (_) => const AddUserScreen(),
        );
      case Routes.addNoteScreen:
        return MaterialPageRoute(
          builder: (_) => const AddNoteScreen(),
        );
      case Routes.settingScreen:
        return MaterialPageRoute(
          builder: (_) => const SettingScreen(),
        );
      default:
        return _unDefinedRoute();
    }
  }

  static Route<dynamic> _unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text("No Route Found !"),
        ),
        body: const Center(child: Text("No Route Found !")),
      ),
    );
  }
}

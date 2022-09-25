import 'package:flutter/material.dart';
import 'package:pos_bank/app/app.dart';
import 'package:pos_bank/app/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppModel();
  runApp(const MyApp());
}

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos_bank/app/cubit/app_cubit.dart';
import 'package:pos_bank/app/resources/font_manger.dart';
import 'package:pos_bank/app/resources/styles_manger.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Option")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Use Local Database",
                    style: getMediumStyle(fontSize: FontSize.s18),
                  ),
                  Text(
                    "instead of using http call to work with app data , please use SqlLite for this",
                    style: getRegularStyle(fontSize: FontSize.s16),
                  ),
                ],
              ),
              trailing: Checkbox(
                activeColor: Colors.purple[800],
                value: AppCubit.get(context).useSqlLite,
                onChanged: (bool? val) {
                  AppCubit.get(context).useSqlLite = val ?? false;
                  GetStorage().write('useSql', val);
                  setState(() {});
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mit_x/mit_x.dart';
import 'package:pos_bank/app/cubit/app_cubit.dart';
import 'package:pos_bank/app/di.dart';
import 'package:pos_bank/app/resources/routes_manager.dart';
import 'package:pos_bank/presentation/add_user/cubit/add_user_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This Widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di<AppCubit>()..getAppData(),
        ),
      ],
      child: BlocProvider(
        create: (context) => di<AppCubit>()..getAppData(),
        child: MitXMaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.deepPurple[800],
              )),
          initialRoute: Routes.mainRoute,
          onGenerateRoute: RouteGenerator.getRoute,
        ),
      ),
    );
  }
}

part of 'app_cubit.dart';

abstract class AppState {
  const AppState();
}

class AppInitial extends AppState {}

class AppLoadDataState extends AppState {}

class AppLoadedDataState extends AppState {}

class AppChangeUserDataState extends AppState {}

class AppLoadUpdateDataState extends AppState {}

class AppSuccessUpdateDataState extends AppState {}

class AppErrorUpdateDataState extends AppState {}

class AppInsertNoteSuccessState extends AppState {}

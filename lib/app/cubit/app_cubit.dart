import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mit_x/mit_x.dart';
import 'package:pos_bank/app/constants.dart';
import 'package:pos_bank/data/network/dio_manager.dart';
import 'package:pos_bank/data/network/network_info.dart';
import 'package:pos_bank/domain/models/interested_model.dart';
import 'package:pos_bank/domain/models/note_model.dart';
import 'package:pos_bank/domain/models/users_model.dart';
import 'package:sqflite/sqflite.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit(this.db, this.networkInfo) : super(AppInitial());

  static AppCubit get(BuildContext context) => BlocProvider.of(context);
  List<NoteModel> notes = [];
  List<UserModel> users = [];
  List<InterestedModel> interested = [];
  List<NoteModel> searchNotes = [];
  String? userSelected;
  final Database db;
  final NetworkInfo networkInfo;

  // Future<void> MitXNotes() async {
  //   var result = await _repository.getNote();
  //   result.fold((failure) {
  //     if (failure.statusCode == -6) {
  //       debugPrint(failure.messages);
  //     } else {
  //       debugPrint(failure.messages);
  //     }
  //   }, (data) async {
  //     debugPrint(data.length.toString());
  //   });
  // }
  bool useSqlLite = false;

// get data
  Future<void> getUsers() async {
    users.clear();

    List? result;
    if (useSqlLite) {
      result = await db.rawQuery('SELECT * FROM users');
    } else {
      Response<List<dynamic>> resultResponse =
          await DioManger.dioApi.get(Constants.getUsers);
      result = resultResponse.data;
    }
    result?.forEach((element) {
      users.add(UserModel.fromJson(element));
    });
    if (users.isNotEmpty) {
      userSelected = users[0].id;
    }
  }

  Future<void> getInterested() async {
    interested.clear();
    List? result;
    if (useSqlLite) {
      result = await db.rawQuery('SELECT * FROM intrests');
    } else {
      Response<List<dynamic>> resultResponse =
          await DioManger.dioApi.get(Constants.getInterested);
      result = resultResponse.data;
    }
    result?.forEach((element) {
      debugPrint(element['id'].toString());
      interested.add(InterestedModel.fromJson(element));
    });
  }

  void selectUser(String userName) {
    userSelected = userName;
    emit(AppChangeUserDataState());
  }

  Future<void> getAppData() async {
    emit(AppLoadDataState());
    useSqlLite = GetStorage().read('useSql') ?? false;
    if (!useSqlLite && !await networkInfo.isConnected) {
      MitX.defaultDialog(
          title: "No Internet",
          middleText: "Please check your internet -  or click active local db",
          textConfirm: "Active db",
          textCancel: "restart app",
          onCancel: () async {
            await MitX.forceAppUpdate();
            MitX.back();
            getAppData();
          },
          onConfirm: () async {
            GetStorage().write('useSql', true);
            await MitX.forceAppUpdate();
            MitX.back();

            getAppData();
          });
    } else {
      await Future.wait([getNotes(), getUsers(), getInterested()]);
      emit(AppLoadedDataState());
    }
  }

  Future<void> getNotes() async {
    notes.clear();

    List? result;
    if (useSqlLite) {
      result = await db.rawQuery('SELECT * FROM notes');
    } else {
      var response = await DioManger.dioApi.get(Constants.getNote);
      result = response.data;
    }
    result?.forEach((element) {
      notes.add(NoteModel.fromJson(element));
    });
  }

//update data
  Future<void> updateNotes(
      {required String id,
      required String text,
      required String placeDateTime}) async {
    emit(AppLoadUpdateDataState());

    if (useSqlLite) {
      db.rawQuery(
          'UPDATE notes SET text = $text , userId = $userSelected, placeDateTime = $placeDateTime WHERE id = $id');
    } else {
      Response<dynamic> result = await DioManger.dioApi
          .post(Constants.updateNote, data: {
        "id": id,
        "text": text,
        "userId": userSelected,
        "placeDateTime": placeDateTime
      });

      if (result.data == "Update Successfully") {
        emit(AppSuccessUpdateDataState());
      } else {
        emit(AppErrorUpdateDataState());
      }
    }
  }

  Future<void> addNote(
      {required String text, required String placeDateTime}) async {
    emit(AppLoadDataState());
    if (useSqlLite) {
      await db.transaction((txn) async => await txn.rawInsert(
          """INSERT INTO notes(text, userId, placeDateTime ) 
        VALUES("$text", "$userSelected" ,"$placeDateTime")"""));
      emit(AppInsertNoteSuccessState());
      Future.delayed(const Duration(milliseconds: 500), (() async {
        emit(AppLoadDataState());
        await getNotes();
        emit(AppLoadedDataState());
      }));
    } else {
      Response<dynamic> result = await DioManger.dioApi
          .post(Constants.insertNote, data: {
        "text": text,
        "userId": userSelected,
        "placeDateTime": placeDateTime
      });

      if (result.data == "Inserted Successfully") {
        emit(AppInsertNoteSuccessState());
        Future.delayed(const Duration(milliseconds: 500), (() async {
          emit(AppLoadDataState());
          await getNotes();
          emit(AppLoadedDataState());
        }));
      }
    }
  }

  Future<void> searchNote(String search) async {
    if (search.length < 3) {
      searchNotes.clear();
    } else {
      searchNotes = notes
          .where((element) =>
              element.text.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    emit(AppLoadedDataState());
  }
}

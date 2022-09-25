import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_bank/app/constants.dart';
import 'package:pos_bank/data/network/dio_manager.dart';
import 'package:pos_bank/domain/models/interested_model.dart';
import 'package:pos_bank/domain/models/note_model.dart';
import 'package:pos_bank/domain/models/users_model.dart';
import 'package:sqflite/sqflite.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit(this.db) : super(AppInitial());

  static AppCubit get(BuildContext context) => BlocProvider.of(context);
  List<NoteModel> notes = [];
  List<UserModel> users = [];
  List<InterestedModel> interested = [];
  List<NoteModel> searchNotes = [];
  late String userSelected;
  final Database db;

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

  Future<void> getUsers() async {
    if (useSqlLite) {
      List<Map> result = await db.rawQuery('SELECT * FROM users');
      for (var element in result) {
        users.add(UserModel(
            id: element['id'],
            email: element['email'],
            imageAsBase64: element['imageAsBase64'] != null
                ? (base64.decode(element['imageAsBase64'].toString()))
                    .toString()
                : null,
            interestId: element['intrestId'],
            name: element['username'],
            password: element['password']));
      }
      if (users.isNotEmpty) {
        userSelected = users[0].id;
      }
      return;
    }
    users.clear();
    Response<List<dynamic>> result =
        await DioManger.dioApi.get(Constants.getUsers);
    result.data?.forEach((element) {
      users.add(UserModel(
          id: element['id'],
          email: element['email'],
          imageAsBase64: element['imageAsBase64'] != null
              ? (base64.decode(element['imageAsBase64'].toString())).toString()
              : null,
          interestId: element['intrestId'],
          name: element['username'],
          password: element['password']));
    });
    userSelected = users[0].id;
  }

  Future<void> getInterested() async {
    Response<List<dynamic>> result =
        await DioManger.dioApi.get(Constants.getInterested);
    result.data?.forEach((element) {
      interested.add(InterestedModel(
          id: element['id'], interestText: element["intrestText"]));
    });
  }

  void selectUser(String userName) {
    userSelected = userName;
    emit(AppChangeUserDataState());
  }

  Future<void> getAppData() async {
    emit(AppLoadDataState());
    await Future.wait([getNotes(), getUsers(), getInterested()]);
    emit(AppLoadedDataState());
  }

  Future<void> getNotes() async {
    notes.clear();
    Response<List<dynamic>> result =
        await DioManger.dioApi.get(Constants.getNote);
    result.data?.forEach((element) {
      notes.add(NoteModel(
          id: element['id'],
          text: element['text'],
          placeDateTime: element['placeDateTime'],
          userId: element['userId'] ?? "0"));
    });
  }

  Future<void> updateNotes(
      {required String id,
      required String text,
      required String placeDateTime}) async {
    emit(AppLoadUpdateDataState());

    Response<dynamic> result = await DioManger.dioApi.post(Constants.updateNote,
        data: {
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

  Future<void> addNote(
      {required String text, required String placeDateTime}) async {
    emit(AppLoadDataState());

    Response<dynamic> result = await DioManger.dioApi.post(Constants.insertNote,
        data: {
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

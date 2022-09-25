import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_bank/app/constants.dart';
import 'package:pos_bank/app/cubit/app_cubit.dart';
import 'package:pos_bank/data/network/dio_manager.dart';
import 'package:pos_bank/presentation/add_user/cubit/add_user_state.dart';

class AddUserCubit extends Cubit<AddUserState> {
  AddUserCubit() : super(AddUserInitial());

  static AddUserCubit get(BuildContext context) => BlocProvider.of(context);
  XFile? userImage;
  void addImage(XFile? file) {
    userImage = file;
    emit(AddUserChangeProfileImageState());
  }

  bool isVisiblePassword = false;
  void visiblePassword() {
    isVisiblePassword = !isVisiblePassword;
    emit(AddUserChangeVisiblePasswordState());
  }

  String interestsIdSelected = "0";
  Future insertUser(
      {required String userName,
      required String password,
      required String email,
      required bool useSql}) async {
    emit(AddUserLoadingState());
    String? base64string;
    if (userImage != null) {
      List<int> imageBytes = File(userImage!.path).readAsBytesSync();

// convert that list to a string & encode the as base64 files
      base64string = base64Encode(imageBytes);
    }
    if (useSql) {
      return;
    }
    var result = await DioManger.dioApi.post(Constants.insertUser, data: {
      "Username": userName,
      "Password": password,
      "Email": email,
      "ImageAsBase64": base64string,
      "IntrestId": interestsIdSelected,
    });
    if (result.data == "Inserted Successfully") {
      emit(AddUserSuccessState());
    } else {
      emit(AddUserFailureState());
    }
  }
}

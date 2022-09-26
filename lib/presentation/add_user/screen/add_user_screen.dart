import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mit_x/mit_x.dart';
import 'package:pos_bank/app/components/my_input_field.dart';
import 'package:pos_bank/app/cubit/app_cubit.dart';
import 'package:pos_bank/app/di.dart';
import 'package:pos_bank/app/extension/form_state_extension.dart';
import 'package:pos_bank/app/resources/font_manger.dart';
import 'package:pos_bank/app/resources/styles_manger.dart';
import 'package:pos_bank/domain/models/interested_model.dart';
import 'package:pos_bank/gen/assets.gen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_bank/presentation/add_user/cubit/add_user_cubit.dart';
import 'package:pos_bank/presentation/add_user/cubit/add_user_state.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController userNameText = TextEditingController();
  final TextEditingController passwordText = TextEditingController();
  final TextEditingController emailText = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);

    return BlocProvider(
      create: (context) => AddUserCubit(di()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Add User")),
        body: Builder(builder: (context) {
          AddUserCubit addUserCubit = AddUserCubit.get(context);

          if (appCubit.useSqlLite) {
            addUserCubit.interestsIdSelected = "1";
          }
          return SingleChildScrollView(
              child: SizedBox(
            height: context.height * .9,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            addUserCubit.addImage(image);
                          }
                        },
                        child: BlocBuilder<AddUserCubit, AddUserState>(
                            builder: (context, state) {
                          return Column(
                            children: [
                              Center(
                                  child: addUserCubit.userImage != null
                                      ? CircleAvatar(
                                          radius: 60,
                                          backgroundImage: FileImage(File(
                                              addUserCubit.userImage!.path)))
                                      : CircleAvatar(
                                          radius: 60,
                                          backgroundImage: AssetImage(
                                              const $AssetsImagesJpgGen()
                                                  .profile
                                                  .path))),
                              Text(
                                "Select Image",
                                style: getRegularStyle(fontSize: FontSize.s16),
                              )
                            ],
                          );
                        }),
                      ),
                      const SizedBox(height: 30),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            MyInputField(
                              controller: userNameText,
                              title: "User Name",
                            ),
                            const SizedBox(height: 30),
                            BlocBuilder<AddUserCubit, AddUserState>(
                              builder: (context, state) {
                                return MyInputField(
                                  controller: passwordText,
                                  title: "Password",
                                  isVisible: addUserCubit.isVisiblePassword,
                                  suffixIcon: TextButton(
                                    onPressed: () {
                                      addUserCubit.visiblePassword();
                                    },
                                    child: addUserCubit.isVisiblePassword
                                        ? SvgGenImage(
                                                const $AssetsImagesSvgGen()
                                                    .visibilityOf
                                                    .path)
                                            .svg(height: 30)
                                        : SvgGenImage(
                                                const $AssetsImagesSvgGen()
                                                    .visibility
                                                    .path)
                                            .svg(height: 30),
                                  ),
                                  validator: (val) {
                                    RegExp regex = RegExp(
                                        r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
                                    if (val != null) {
                                      if (!regex.hasMatch(val) ||
                                          val.length < 8) {
                                        return "Password should have alphabet and numbers with minimum length of 8 char";
                                      }
                                    } else {
                                      return "Password empty";
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 30),
                            MyInputField(
                              controller: emailText,
                              title: "Email",
                              validator: (val) {
                                if (val != null) {
                                  if (!MitXUtils.isEmail(val)) {
                                    return "Incorrect email";
                                  }
                                } else {
                                  return "Email empty";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              height: 60,
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                style: getRegularStyle(fontSize: FontSize.s18),

                                value: addUserCubit.interestsIdSelected,
                                decoration: InputDecoration(
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  label: const Text("Interested"),
                                  isDense: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                                items: appCubit.interested
                                    .map((InterestedModel items) {
                                  debugPrint(items.id);
                                  return DropdownMenuItem(
                                    value: items.id,
                                    child: Text(items.interestText),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String? val) {
                                  addUserCubit.interestsIdSelected = val!;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: SizedBox(
                      width: context.width,
                      child: BlocConsumer<AddUserCubit, AddUserState>(
                        listener: (context, state) async {
                          if (state is AddUserSuccessState) {
                            await AppCubit.get(context).getUsers();
                            MitX.back();
                            MitX.showSnackbar(const MitXSnackBar(
                              duration: Duration(seconds: 2),
                              message: "User Added",
                              title: "",
                            ));
                          }
                        },
                        builder: (context, state) {
                          if (state is! AddUserLoadingState &&
                              state is AddUserSuccessState) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple[800]),
                              onPressed: () {
                                if (formKey.isValid()) {
                                  formKey.save();
                                  addUserCubit.insertUser(
                                      useSql: appCubit.useSqlLite,
                                      email: emailText.text,
                                      password: passwordText.text,
                                      userName: userNameText.text);
                                }
                              },
                              child: Text(
                                "SAVE",
                                style: getRegularStyle(
                                    fontSize: FontSize.s18,
                                    color: Colors.white),
                              ));
                        },
                      ),
                    ))
              ],
            ),
          ));
        }),
      ),
    );
  }
}

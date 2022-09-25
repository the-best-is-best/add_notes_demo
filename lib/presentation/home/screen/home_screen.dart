import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mit_x/mit_x.dart';
import 'package:pos_bank/app/components/my_input_field.dart';
import 'package:pos_bank/app/cubit/app_cubit.dart';
import 'package:pos_bank/app/resources/font_manger.dart';
import 'package:pos_bank/app/resources/routes_manager.dart';
import 'package:pos_bank/app/resources/styles_manger.dart';
import 'package:pos_bank/domain/models/note_model.dart';
import 'package:pos_bank/presentation/edit_note/screen/edit_note_screen.dart';
import 'package:pos_bank/gen/assets.gen.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AppCubit appCubit = AppCubit.get(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple[800],
        onPressed: () {
          MitX.toNamed(Routes.addNoteScreen);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          SizedBox(
            width: 40,
            child: TextButton(
                onPressed: () {
                  MitX.toNamed(Routes.addUserScreen);
                },
                child: SvgGenImage(const $AssetsImagesSvgGen().addUser.path)
                    .svg(color: Colors.white, height: 25)),
          ),
          SizedBox(
            width: 40,
            child: TextButton(
                onPressed: () {
                  MitX.toNamed(Routes.settingScreen);
                },
                child: SvgGenImage(const $AssetsImagesSvgGen().setting.path)
                    .svg(color: Colors.white, height: 25)),
          ),
          SizedBox(
            width: 40,
            child: TextButton(
                onPressed: () {},
                child: SvgGenImage(const $AssetsImagesSvgGen().menu.path)
                    .svg(color: Colors.white, height: 25)),
          ),
        ],
        title: const Text("Notes"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 40,
                  child: TextButton(
                      onPressed: () {},
                      child: SvgGenImage(
                              const $AssetsImagesSvgGen().filterList.path)
                          .svg(
                        color: Colors.deepPurple[800],
                        height: 25,
                      )),
                ),
                SizedBox(
                  width: 40,
                  child:
                      SvgGenImage(const $AssetsImagesSvgGen().search.path).svg(
                    color: Colors.deepPurple[800],
                    height: 25,
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: 50,
                    child: MyInputField(
                      withClearButton: true,
                      controller: searchText,
                      onChanged: (val) {
                        appCubit.searchNote(val);
                      },
                    ),
                  ),
                ))
              ],
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: context.height * .7,
              child: BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                  // if (state is SubjectFailed) {
                  //   return ErrorOutput(message: state.message);
                  // }
                  if (state is! AppLoadDataState) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: appCubit.searchNotes.isNotEmpty
                            ? appCubit.searchNotes.length
                            : appCubit.notes.length,
                        itemBuilder: (context, index) {
                          List<NoteModel> itemsNote =
                              appCubit.searchNotes.isNotEmpty
                                  ? appCubit.searchNotes
                                  : appCubit.notes;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: context.width * .7,
                                    child: Text(
                                      itemsNote[index].text,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: getRegularStyle(
                                          fontSize: FontSize.s16),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: TextButton(
                                        onPressed: () {
                                          MitX.to(
                                            EditNoteScreen(index: index),
                                          );
                                        },
                                        child: SvgGenImage(
                                                const $AssetsImagesSvgGen()
                                                    .edit
                                                    .path)
                                            .svg()),
                                  )
                                ],
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Column(
                            children: const [
                              Divider(),
                            ],
                          );
                        },
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

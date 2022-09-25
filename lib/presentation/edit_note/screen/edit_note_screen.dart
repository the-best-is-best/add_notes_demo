import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mit_x/mit_x.dart';
import 'package:pos_bank/app/components/my_input_field.dart';
import 'package:pos_bank/app/cubit/app_cubit.dart';
import 'package:pos_bank/app/resources/font_manger.dart';
import 'package:pos_bank/app/resources/styles_manger.dart';
import 'package:pos_bank/domain/models/note_model.dart';
import 'package:pos_bank/domain/models/users_model.dart';
import 'package:pos_bank/gen/assets.gen.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  TextEditingController noteTextEditing = TextEditingController();

  @override
  void initState() {
    AppCubit appCubit = AppCubit.get(context);
    noteTextEditing.text = appCubit.notes[widget.index].text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);

    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is AppErrorUpdateDataState) {
          MitX.showSnackbar(const MitXSnackBar(
            duration: Duration(seconds: 2),
            message: "Error Validation",
            title: "",
          ));
        }
        if (state is AppSuccessUpdateDataState) {
          appCubit.notes[widget.index] = NoteModel(
              id: appCubit.notes[widget.index].id,
              text: noteTextEditing.text,
              placeDateTime: appCubit.notes[widget.index].placeDateTime,
              userId: appCubit.userSelected);

          MitX.back();

          MitX.showSnackbar(const MitXSnackBar(
            duration: Duration(seconds: 2),
            title: "",
            message: "Note has been Editing Successfully",
          ));
        }
      },
      builder: (context, state) {
        if (state is! AppLoadUpdateDataState) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                SizedBox(
                  width: 40,
                  child: TextButton(
                      onPressed: () {
                        appCubit.updateNotes(
                            id: widget.index.toString(),
                            text: noteTextEditing.text,
                            placeDateTime:
                                appCubit.notes[widget.index].placeDateTime);
                      },
                      child: SvgGenImage(const $AssetsImagesSvgGen().save.path)
                          .svg(
                        color: Colors.white,
                        height: 25,
                      )),
                ),
              ],
              title: const Text("Edit Note"),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 30) +
                  const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyInputField(
                    controller: noteTextEditing,
                    isMultiLine: true,
                    title: "Note",
                  ),
                  const SizedBox(height: 25),
                  Column(
                    children: [
                      SizedBox(
                        height: 60,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          style: getRegularStyle(fontSize: FontSize.s18),

                          value: appCubit.notes[widget.index].userId,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.black),
                            label: const Text("Assign To User"),
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                          items: appCubit.users.map((UserModel items) {
                            return DropdownMenuItem(
                              value: items.id,
                              child: Text(items.name),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? val) {
                            appCubit.userSelected = val!;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

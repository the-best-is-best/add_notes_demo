import 'package:flutter/material.dart';
import 'package:mit_x/mit_x.dart';
import 'package:pos_bank/app/cubit/app_cubit.dart';
import 'package:pos_bank/app/resources/font_manger.dart';
import 'package:pos_bank/app/resources/styles_manger.dart';

class MyInputField extends StatelessWidget {
  const MyInputField({
    Key? key,
    this.title,
    this.isMultiLine = false,
    required this.controller,
    this.withClearButton = false,
    this.suffixIcon,
    this.validator,
    this.isVisible = true,
    this.onChanged,
  }) : super(key: key);
  final String? title;
  final bool isMultiLine;
  final TextEditingController controller;
  final bool withClearButton;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool isVisible;
  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isVisible ? false : true,
      validator: validator,
      controller: controller,
      minLines: isMultiLine ? (context.height * .004).toInt() : null,
      maxLines: isMultiLine ? (context.height * .008).toInt() : 1,
      cursorHeight: 20,
      cursorWidth: 2,
      decoration: InputDecoration(
        errorMaxLines: 2,
        label: title != null ? Text(title!) : null,
        labelStyle: getRegularStyle(fontSize: FontSize.s16),
        isDense: true,
        enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        focusedBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        errorBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        suffix: withClearButton
            ? IconButton(
                onPressed: () {
                  controller.text = "";
                  AppCubit.get(context).searchNote('');
                },
                icon: const Icon(Icons.close))
            : null,
        suffixIcon: suffixIcon,
      ),
      onChanged: onChanged,
    );
  }
}

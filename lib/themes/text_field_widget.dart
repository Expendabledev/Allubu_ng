import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';

class TextFieldWidget extends StatelessWidget {
  final String? title;
  final String hintText;
  final Color? textColor;
  final TextEditingController? controller;
  final Widget? prefix;
  final Widget? suffix;
  final bool? enable;
  final bool? readOnly;
  final bool? obscureText;
  final int? maxLine;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onchange;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;

  const TextFieldWidget(
      {super.key,
      this.textColor,
      this.textInputType,
      this.enable,
      this.readOnly,
      this.obscureText,
      this.prefix,
      this.suffix,
      this.title,
      required this.hintText,
      required this.controller,
      this.maxLine,
      this.inputFormatters,
      this.onchange,
      this.textInputAction,
      this.focusNode,
      this.onFieldSubmitted});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: title != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title == null ? '' : title!.tr,
                    style: TextStyle(
                        fontFamily: AppThemeData.boldOpenSans,
                        fontSize: 14,
                        color: themeChange.getThem()
                            ? AppThemeData.greyDark01
                            : AppThemeData.grey01)),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          TextFormField(
            keyboardType: textInputType ?? TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: controller,
            maxLines: maxLine ?? 1,
            focusNode: focusNode,
            textInputAction: textInputAction ?? TextInputAction.done,
            inputFormatters: inputFormatters,
            obscureText: obscureText ?? false,
            obscuringCharacter: '●',
            onChanged: onchange,
            readOnly: readOnly ?? false,
            onFieldSubmitted: onFieldSubmitted,
            style: TextStyle(
                color: textColor ??
                    (themeChange.getThem()
                        ? AppThemeData.greyDark01
                        : AppThemeData.grey01),
                fontFamily: AppThemeData.medium),
            decoration: InputDecoration(
              errorStyle: const TextStyle(color: Colors.red),
              filled: true,
              enabled: enable ?? true,
              contentPadding: EdgeInsets.symmetric(
                  vertical: title == null
                      ? 15
                      : enable == false
                          ? 13
                          : 8,
                  horizontal: 10),
              fillColor: themeChange.getThem()
                  ? AppThemeData.greyDark10
                  : AppThemeData.grey10,
              prefixIcon: prefix,
              suffixIcon: suffix,
              suffixIconConstraints:
                  BoxConstraints(minHeight: 20, minWidth: 20),
              prefixIconConstraints:
                  BoxConstraints(minHeight: 20, minWidth: 20),
              disabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                    color: themeChange.getThem()
                        ? AppThemeData.greyDark06
                        : AppThemeData.grey06,
                    width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                    color: themeChange.getThem()
                        ? AppThemeData.redDark02
                        : AppThemeData.red02,
                    width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                    color: themeChange.getThem()
                        ? AppThemeData.greyDark06
                        : AppThemeData.grey06,
                    width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                    color: themeChange.getThem()
                        ? AppThemeData.greyDark06
                        : AppThemeData.grey06,
                    width: 1),
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                    color: themeChange.getThem()
                        ? AppThemeData.greyDark06
                        : AppThemeData.grey06,
                    width: 1),
              ),
              hintText: hintText.tr,
              hintStyle: TextStyle(
                fontSize: 14,
                color: themeChange.getThem()
                    ? AppThemeData.greyDark04
                    : AppThemeData.grey04,
                fontFamily: AppThemeData.regularOpenSans,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

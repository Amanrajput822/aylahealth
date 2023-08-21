// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common_function.dart';
import '../styles/const.dart';

class AllInputDesign extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final controller;
  final floatingLabelBehavior;
  final prefixText;
  final fillColor;
  final enabled;
  final initialValue;
  final hintText;
  final labelText;
  final textInputAction;
  final prefixStyle;
  final validator;
  final errorText;
  final keyBoardType;
  final validatorFieldValue;
  final List<TextInputFormatter>? inputFormatterData;
  final FormFieldSetter<String>? onSaved;
  final onTap;
  final onSubmitted;
  final obsecureText;
  final suffixIcon;
  final prefixIcon;
  final maxLength;
  final outlineInputBorderColor;
  final outlineInputBorder;
  final enabledBorderRadius;
  final focusedBorderRadius;
  final enabledOutlineInputBorderColor;
  final focusedBorderColor;
  final hintTextStyleColor;
  final counterText;
  final cursorColor;
  final textStyleColors;
  final inputHeaderName;
  final autofillHints;
  final onEditingComplete;
  final textCapitalization;
  final keyboardType;
  final maxLines;
  final minLines;
  final boxshadow;
  final elevation;
  final widthtextfield;
  final higthtextfield;
  final inputHeaderTextStyle;
  final inputLableColor;
  final focusNode;
  final onExpands;


  const AllInputDesign({
    Key? key,
    this.textStyleColors,
    this.controller,
    this.floatingLabelBehavior,
    this.initialValue,
    this.cursorColor,
    this.prefixIcon,
    this.textInputAction,
    this.outlineInputBorder,
    this.enabledBorderRadius,
    this.focusedBorderRadius,
    this.enabled,
    this.prefixText,
    this.fillColor,
    this.prefixStyle,
    this.keyBoardType,
    this.obsecureText,
    this.suffixIcon,
    this.hintText,
    this.labelText,
    this.validatorFieldValue,
    this.inputFormatterData,
    this.validator,
    this.onSaved,
    this.onTap,
    this.onSubmitted,
    this.errorText,
    this.onChanged,
    this.maxLength,
    this.outlineInputBorderColor,
    this.enabledOutlineInputBorderColor,
    this.focusedBorderColor,
    this.hintTextStyleColor,
    this.counterText,
    this.inputHeaderName,
    this.onEditingComplete,
    this.autofillHints,
    this.textCapitalization,
    this.keyboardType,
    this.maxLines,
    this.minLines,
    this.boxshadow,
    this.elevation,
    this.widthtextfield,
    this.higthtextfield,
    this.inputHeaderTextStyle,
    this.inputLableColor,
    this.focusNode,
    this.onExpands,
  }) : super(key: key);

  @override
  _AllInputDesignState createState() => _AllInputDesignState();
}

class _AllInputDesignState extends State<AllInputDesign> {
  var cf = CommonFunctions();
  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    return myTextfieldWidget(context);
  }

  Widget myTextfieldWidget(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    return Material(
      borderRadius: widget.enabledBorderRadius ?? BorderRadius.circular(6),
      color: Colors.transparent,
      elevation: widget.elevation ?? 0,
      child: Column(
        children: [
          Container(
            width: widget.widthtextfield ?? screensize,
            height:widget.higthtextfield,
            decoration: BoxDecoration(
              color: colorWhite,
                borderRadius: widget.boxshadow != null
                    ? BorderRadius.circular(6)
                    : BorderRadius.circular(6),
                boxShadow: widget.boxshadow ??
                    [
                      BoxShadow(
                        color: Colors.transparent,
                        // spreadRadius: 1,
                        // blurRadius: 1,
                        // offset: Offset(0, 3),
                      )
                    ]),
            child: TextFormField(
              focusNode: widget.focusNode,
               expands: widget.onExpands?? false,
              onFieldSubmitted: widget.onSubmitted,
              minLines: widget.maxLines ?? 1,
              maxLines: widget.maxLines ?? 1,
              textCapitalization:
                  widget.textCapitalization ?? TextCapitalization.none,
              cursorColor: widget.cursorColor ?? colorgrey,
              key: Key(cf.convertKey(widget.labelText)),
              //onSaved: widget.onSaved,
              onEditingComplete: widget.onEditingComplete,
              style: TextStyle(
                  color: widget.textStyleColors ?? colorRichblack,
                  // fontFamily: 'Nunito',
                  fontFamily: 'Messina Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: screensize <= 350 ? 14 : 16),
              keyboardType: widget.keyBoardType,
             // validator: widget.validator,
              controller: widget.controller,
              maxLength: widget.maxLength,
              enabled: widget.enabled,

              // initialValue: widget.initialValue == null ? '' : widget.initialValue,
              inputFormatters: widget.inputFormatterData,
              obscureText: widget.obsecureText ?? false,
              onChanged: widget.onChanged,
              onTap: widget.onTap,
              onSaved: widget.onSaved,
              textInputAction: widget.textInputAction??TextInputAction.next,
              autofillHints: widget.autofillHints,
              decoration: InputDecoration(
                labelText: widget.labelText ?? widget.hintText ?? '',
                labelStyle: (widget.inputHeaderTextStyle != null)
                    ? widget.inputHeaderTextStyle
                    : TextStyle(
                    color: widget.inputLableColor ?? colorTextFieldHadingText,
                    // fontFamily: 'Nunito',
                    fontFamily: 'Messina Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: screensize <= 350 ? 10 : 12),
                // labelStyle: textstylesubtitle1(context)!
                //     .copyWith(color: widget.inputLableColor ?? colorgrey),
                counterText: widget.counterText,

                filled: true,
                  fillColor: widget.fillColor ?? colorDisabledTextField,
                hintText: (widget.hintText != null) ? widget.hintText : '',
                floatingLabelBehavior:
                    widget.floatingLabelBehavior ?? FloatingLabelBehavior.auto,
                hintStyle: TextStyle(
                  color: widget.hintTextStyleColor ?? colorTextFieldHintText,
                  fontSize: 16,
                   fontFamily: 'Messina Sans',
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: widget.prefixIcon != null
                    ? SizedBox(
                        width: 15,
                        height: 15,
                        child: widget.prefixIcon,
                      ) : null,

                suffixIcon: widget.suffixIcon != null
                    ? widget.suffixIcon ?? Text('')
                    : null,
                prefixText: (widget.prefixText != null) ? widget.prefixText : '',
                prefixStyle: widget.prefixStyle,
                errorText: widget.errorText,
                // errorStyle: TextStyle(fontFamily: pCommonRegularFont),
                contentPadding: const EdgeInsets.all(10.0),
                  border:  OutlineInputBorder(
                    borderRadius:
                    widget.focusedBorderRadius ?? BorderRadius.circular(6),
                    borderSide: BorderSide(
                        color:widget.fillColor ??  colorDisabledTextField, width: 0.6),
                  ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      widget.focusedBorderRadius ?? BorderRadius.circular(6),
                  borderSide: BorderSide(
                      color: widget.fillColor ?? colorDisabledTextField, width: 0.6),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                  widget.focusedBorderRadius ?? BorderRadius.circular(6),
                  borderSide: BorderSide(
                      color: widget.fillColor ?? colorDisabledTextField, width: 0.6),
                ),
                errorMaxLines: 1,

                errorBorder:  OutlineInputBorder(
                  borderRadius:
                  widget.focusedBorderRadius ?? BorderRadius.circular(6),
                  borderSide: BorderSide(
                      color:colorDisabledTextField, width: 0.6),
                ),
                errorStyle: TextStyle(fontSize: 0)
                // focusedBorder: UnderlineInputBorder(
                //   borderRadius: BorderRadius.circular(8),
                //   borderSide: BorderSide(color: colorWhite),
                // ),

                // border: widget.outlineInputBorder ??
                //     OutlineInputBorder(
                //       borderRadius:
                //           widget.enabledBorderRadius ?? BorderRadius.circular(10),
                //       borderSide: BorderSide(
                //           color: widget.outlineInputBorderColor ?? colorhintcolor,
                //           width: 0.6),
                //     ),
              ),
              validator: (value) {
                if (widget.validator != null) {
                  setState(() {
                    errorMessage = widget.validator!(value);
                  });
                }
               return errorMessage;
              },

            ),
          ),
          errorMessage==null?Container():Container(
            width: widget.widthtextfield ?? screensize,
              child: Align(
                alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(errorMessage.toString(),
                    style: TextStyle(
                        color: Colors.red,
                        // fontFamily: 'Nunito',
                        fontFamily: 'Messina Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 14 ),),
                  )),)
        ],
      ),
    );
  }
}

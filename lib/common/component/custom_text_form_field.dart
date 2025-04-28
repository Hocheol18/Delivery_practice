import 'package:delivery/common/const/colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.autofocus = false,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(color: INPUT_BORDER_COLOR, width: 1.0),
    );

    return TextFormField(
      cursorColor: PRIMARY_COLOR,

      // 비밀번호 입력할 때
      obscureText: obscureText,

      // 자동으로 포커스할 건지 안힐건지
      autofocus: autofocus,

      // 안에 세부사항 바뀌는 것
      onChanged: onChanged,

      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: TextStyle(color: BODY_TEXT_COLOR, fontSize: 14.0),
        fillColor: INPUT_BG_COLOR,
        filled: true,
        // false :: 배경색 없음 // true :: 배경색 있음
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          // 이렇게 하면 전체 가져오는데, 안의 세부 사항만 바꿀 수 있음.
          borderSide: baseBorder.borderSide.copyWith(color: PRIMARY_COLOR),
        ),
        // 모든 Input 상태의 기본 스타일 세팅
      ),
    );
  }
}

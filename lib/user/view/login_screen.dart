// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:delivery/common/const/colors.dart';
import 'package:delivery/common/const/securetoken.dart';
import 'package:delivery/common/layout/default_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/component/custom_text_form_field.dart';
import '../../common/view/root_tab.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();


    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Title(),
                SizedBox(height: 16.0,),
                _SubTitle(),
                Center(
                  child: Image.asset(
                    'asset/img/misc/logo.png',
                    width: MediaQuery.of(context).size.width / 4 * 3,
                  ),
                ),
                SizedBox(height: 16.0,),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요',
                  onChanged: (String value) {
                    username = value;
                  },
                  autofocus: true,
                ),
                SizedBox(height: 16.0,),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요',
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                ),
                SizedBox(height: 16.0,),
                ElevatedButton(
                  onPressed: () async {
                    final rawString = '$username:$password';

                    // 이렇게 인코딩함
                    Codec<String, String> stringToBase64 = utf8.fuse(base64);

                    String token = stringToBase64.encode(rawString);

                    final resp = await dio.post('http://$ip/auth/login', options: Options(
                      headers: {
                        'authorization' : 'Basic $token',
                      }
                    ));

                    final accessToken = resp.data['accessToken'];
                    final refreshToken = resp.data['refreshToken'];

                    storage.write(key: ACCESS_TOKEN, value: accessToken);
                    storage.write(key: REFRESH_TOKEN, value: refreshToken);

                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => RootTab(),));
                  },
                  style: ElevatedButton.styleFrom(foregroundColor: PRIMARY_COLOR, fixedSize: Size(MediaQuery.of(context).size.width, 10.0)),
                  child: Text('로그인'),
                ),
                SizedBox(height: 3.0,),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(foregroundColor: Colors.black, fixedSize: Size(MediaQuery.of(context).size.width, 10.0)),
                  child: Text('회원가입'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인해주세요!\n 오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(fontSize: 16, color: BODY_TEXT_COLOR),
    );
  }
}

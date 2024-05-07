import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:modile_app/pages/index.dart';
import 'package:modile_app/pages/registration.dart';

import '../api_service/user_service.dart';
import '../models/jwt_token_model.dart';

class Entry extends StatelessWidget {
  const Entry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .onPrimary,
        body: Center(
            child: Column(
                children: [
                  const SizedBox(height: 50),
                  Text('Добро пожаловать', style: Theme
                      .of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(
                      fontSize: 20
                  ),),
                   const Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                      child: Authorization(),
                    ),
                  ),
                ]
            )
        )
    );
  }
}

class Authorization extends StatefulWidget {
  const Authorization({super.key});

  @override
  State<Authorization> createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {

  String username = '';
  String password = '';

  Map<String, String> fieldMap = {
    'username': 'Имя пользователя',
    'password': 'Пароль',
  };

  bool _isFieldEmpty(String field) {
    switch (field) {
      case 'username':
        return username.isEmpty;
      case 'password':
        return password.isEmpty;
      default:
        return false;
    }
  }

  Future<void> loginUser() async {
    try {
      for (var field in fieldMap.keys) {
        if (_isFieldEmpty(field)) {
          throw ('поле "${fieldMap[field]}" не заполнено');
        }
      }
      JwtTokenModel? jwtTokenModel = await UserService().loginUser(username, password);
      if (jwtTokenModel == null) {
        throw Exception('Ошибка при получении токена');
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.onPrimary,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person),
              suffixIcon: const Icon(Icons.clear),
              labelText: 'Имя пользователя',
              hintText: 'Ваше имя',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              labelStyle: const TextStyle(fontSize: 14),
              hintStyle: const TextStyle(fontSize: 14),
            ),
            onChanged: (value) {
              username = value;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: Icon(Icons.remove_red_eye_outlined, color: Theme.of(context).colorScheme.primary,),
                labelText: 'Пароль',
                hintText: 'Пароль',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                labelStyle: const TextStyle(fontSize: 14),
                hintStyle: const TextStyle(fontSize: 14),
              ),
              onChanged: (value) {
                password = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: ElevatedButton(
              onPressed: () {
                loginUser().then((result) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (
                            context) => const Index()),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                          'Произошла ошибка: ${error
                              .toString()}'),
                    ),
                  );
                });
              },
              child: const Text('Войти'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text('У вас нет аккаунта?', style: Theme
                .of(context)
                .textTheme
                .displayMedium!
                .copyWith(
                fontSize: 15
            ),),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Registration()),
              );
            },
            style: TextButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold,),
            ),
            child: Text('Зарегистрироваться'),
          )
        ],
      ),
    );
  }
}

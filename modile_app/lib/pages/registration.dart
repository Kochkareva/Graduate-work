import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modile_app/api_service/user_service.dart';
import 'package:modile_app/models/jwt_token_model.dart';
import 'package:modile_app/pages/entry.dart';
import 'package:modile_app/pages/survey.dart';

import '../contracts/enums/race_enum.dart';
import '../models/user_model.dart';

class Registration extends StatelessWidget {
  const Registration({super.key});

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
                  Text('Создание аккаунта', style: Theme
                      .of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(
                      fontSize: 20
                  ),),
                  const Flexible(
                    child: Padding(
                        padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                        child: Registering(),
                      ),
                  ),
                ]
            )
        )
    );
  }
}

class Registering extends StatefulWidget {
  const Registering({super.key});

  @override
  State<Registering> createState() => _RegisteringState();
}

class _RegisteringState extends State<Registering> {

  late UserModel newUser;
  String email = '';
  String userName = '';
  String password = '';
  String rePassword = '';
  late DateTime dateOfBirth;
  String textDateOfBirth = 'Выбрать дату';
  List<String> listGender = ['Male', 'Female'];
  String gender = '';
  bool groupGender = true;
  late Race race = Race.European;
  List<String> listRace = <String>[
    'Европеец',
    'Афроамериканец',
    'Азиатское происхождение',
    'Индеец',
    'Другое'
  ];

  String codeFromMail = '';
  bool activateDone = false;
  bool _isObscure = true;
  bool _isObscureRe = true;

  TextEditingController _emailController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  Map<String, String> fieldMap = {
    'email': 'Email',
    'userName': 'Имя пользователя',
    'password': 'Пароль',
    'rePassword': 'Повторите пароль',
    'dateOfBirth': 'Дата рождения',
    // 'gender': 'Пол',
    // 'race': 'Раса',
  };

  void _clearUsername() {
    _emailController.clear();
  }

  bool _isFieldEmpty(String field) {
    switch (field) {
      case 'email':
        return email.isEmpty;
      case 'userName':
        return userName.isEmpty;
      case 'password':
        return password.isEmpty;
      case 'rePassword':
        return rePassword.isEmpty;
      case 'dateOfBirth':
        return dateOfBirth == null;
      default:
        return false;
    }
  }

  Future<void> registerUser() async {
    try {
      for (var field in fieldMap.keys) {
        if (_isFieldEmpty(field)) {
          throw Exception('Поле "${fieldMap[field]}" не заполнено');
        }
      }
      if(password != rePassword){
        throw Exception('Введенные вами пароли не совпадают');
      }
      newUser = UserModel(null, email: email,
          userName: userName,
          password: password,
          rePassword: rePassword,
          dateOfBirth: dateOfBirth,
          gender: gender,
          race: race);
      newUser.id = await UserService().registerUser(newUser);
      print(newUser.id);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> activateUser() async {
    try {
      await UserService().activateUser(newUser, codeFromMail);
      setState(() {
        activateDone = true;
      });
    } catch (e) {
      setState(() {
        activateDone = false;
      });
      log(e.toString());
      rethrow;
    }
  }

  Future<void> loginUser() async {
    try {
      JwtTokenModel? jwtTokenModel = await UserService().loginUser(newUser.userName, newUser.password);
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
      color: Theme
          .of(context)
          .colorScheme
          .onPrimary,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                labelText: 'Имя пользователя',
                hintText: 'Ваше имя',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                labelStyle: const TextStyle(fontSize: 14),
                hintStyle: const TextStyle(fontSize: 14),
              ),
              onChanged: (value) {
                userName = value;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearUsername,
                  ),
                  labelText: 'Email',
                  hintText: 'email@yandex.ru',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  labelStyle: const TextStyle(fontSize: 14),
                  hintStyle: const TextStyle(fontSize: 14),
                ),
                onChanged: (value) {
                  email = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off, color: Theme.of(context).colorScheme.primary,),
                    onPressed: (){
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                  labelText: 'Пароль',
                  hintText: 'Пароль',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  labelStyle: const TextStyle(fontSize: 14),
                  hintStyle: const TextStyle(fontSize: 14),
                ),
                obscureText: _isObscure,
                onChanged: (value) {
                  password = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscureRe ? Icons.visibility : Icons.visibility_off, color: Theme.of(context).colorScheme.primary,),
                    onPressed: (){
                      setState(() {
                        _isObscureRe = !_isObscureRe;
                      });
                    },
                  ),
                  labelText: 'Повторите пароль',
                  hintText: 'Повторите пароль',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  labelStyle: const TextStyle(fontSize: 14),
                  hintStyle: const TextStyle(fontSize: 14),
                ),
                obscureText: _isObscureRe,
                onChanged: (value) {
                  rePassword = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                  'Выберите ваш пол:', style: Theme
                  .of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(
                  fontSize: 14
              )),
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: RadioListTile(
                    dense: true,
                    title: Text('мужчина', style: Theme
                        .of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(
                        fontSize: 14
                    )),
                    value: true,
                    groupValue: groupGender,
                    onChanged: (value) {
                      setState(() {
                        groupGender = true;
                        gender = listGender[0];
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.41,
                  child: RadioListTile(
                    dense: true,
                    title: Text('женщина', style: Theme
                        .of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(
                        fontSize: 14
                    )),
                    value: false,
                    groupValue: groupGender,
                    onChanged: (value) {
                      setState(() {
                        groupGender = false;
                        gender = listGender[1];
                      });
                    },

                  ),
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: ElevatedButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1920),
                      lastDate: DateTime.now(),
                      locale: Locale('ru'),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        dateOfBirth = selectedDate;
                        setState(() {
                          dateOfBirth = selectedDate;
                          textDateOfBirth =
                              DateFormat('dd.MM.yyyy').format(
                                  dateOfBirth);
                        });
                      }
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.white), // Цвет фона
                    side: MaterialStateProperty.all(const BorderSide(
                        color: Color(0xFF3b5bdb),
                        width: 1)), // Цвет и ширина границы
                  ),
                  child: Text('Дата рождения: $textDateOfBirth', style: Theme
                      .of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(
                      fontSize: 14
                  )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text('Выберите свою этническую принадлежность: ',
                  style: Theme
                      .of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(
                      fontSize: 14
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: DropdownButton<Race>(
                value: race,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: Theme
                    .of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(
                    fontSize: 15
                ),
                underline: Container(
                  height: 2,
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary,
                ),
                onChanged: (Race? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    race = value!;
                  });
                },
                isExpanded: true,
                items: listRace
                    .asMap()
                    .entries
                    .map<DropdownMenuItem<Race>>((entry) {
                  int index = entry.key;
                  String value = entry.value;
                  return DropdownMenuItem<Race>(
                    value: Race.values[index],
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: ElevatedButton(
                  onPressed: () {
                    registerUser().then((result) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              SimpleDialog(
                                title: Text(
                                    'Вам на почту было отправлено письмо для подтверждения аккаунта. Введите код из письма:',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                        fontSize: 14
                                    )),
                                children: <Widget>[
                                  SimpleDialogOption(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        labelText: 'Код',
                                        hintText: '532567',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius
                                              .circular(20.0),
                                        ),
                                        contentPadding: const EdgeInsets
                                            .symmetric(
                                            vertical: 15.0,
                                            horizontal: 20.0),
                                        labelStyle: const TextStyle(
                                            fontSize: 14),
                                        hintStyle: const TextStyle(
                                            fontSize: 14),
                                      ),
                                      onChanged: (value) {
                                        codeFromMail = value;
                                      },
                                    ),
                                  ),
                                  SimpleDialogOption(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        activateUser().then((result) {
                                          if (activateDone) {
                                            loginUser().then((result) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (
                                                        context) => const Survey()),
                                              );
                                            }).catchError((error) {
                                              Navigator.of(context)
                                                  .pop();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Произошла ошибка: ${error
                                                          .toString()}'),
                                                ),
                                              );
                                            });
                                          }
                                        }).catchError((error) {
                                          Navigator.of(context)
                                              .pop();
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
                                      child: const Text('Ок'),
                                    ),
                                  )
                                ],
                              )
                      );
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Произошла ошибка: ${error.toString()}'),
                        ),
                      );
                    });
                  },
                  child: const Text('Продолжить регистрацию'),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Center(
                child: Column(
                  children: [
                    Text('У вас уже есть аккаунт?', style: Theme
                        .of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(
                        fontSize: 15
                    ),),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Entry()),
                        );
                      },
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold,),
                      ),
                      child: const Text('Войти'),
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

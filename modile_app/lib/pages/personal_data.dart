import 'package:flutter/material.dart';
import 'package:modile_app/contracts/enums/race_enum.dart';
import 'package:modile_app/models/user_model.dart';

class PersonalData extends StatefulWidget {
  const PersonalData({super.key});

  @override
  State<PersonalData> createState() => _PersonalDataState();
}

class _PersonalDataState extends State<PersonalData> {

  /// Имя пользователя
  late UserModel userModel;

  @override
  void initState() {
    userModel = UserModel(0, email: 'email', userName: 'Имя пользователя', password: 'password', rePassword: 'rePassword',
        dateOfBirth: DateTime(2022, 10, 1), gender: 'gender', race: Race.European);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 14,
      fontFamily: 'Montserrat',
    );
    final textSubtitleStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 16,
      fontFamily: 'Montserrat',
      // fontWeight: FontWeight.bold,
    );
    final titleText = theme.textTheme.displayMedium!.copyWith(
      // color: theme.colorScheme.onPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    );
    final titleBlueText = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.primary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    );
    final blueColor = Theme
        .of(context)
        .colorScheme
        .primary;
    final lightBlueColor = Color(0xFFBAC8FF);
    return Scaffold(
      backgroundColor: lightBlueColor,
      body: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only( top: 35),
                child: Text(
                    'Аккаунт',
                    style: titleText),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                    userModel.userName,
                    textAlign: TextAlign.left,
                    style: titleBlueText),
              ),
            ],
          ),
          Container(
            constraints: BoxConstraints.expand(
                height: MediaQuery.of(context).size.height * 0.78),
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(70.0),
                topRight: Radius.circular(70.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 30, right: 30, bottom: 20.0),
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.insert_chart, color: blueColor),
                    title: Text('Графики', style: textSubtitleStyle,),
                    onTap: () {
                      // Добавьте здесь обработчик для пункта "Графики"
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person, color: blueColor),
                    title: Text('Медицинская карта', style: textSubtitleStyle,),
                    onTap: () {
                      // Добавьте здесь обработчик для пункта "Данные пользователя"
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.dynamic_feed, color: blueColor),
                    title: Text('Трекер здоровья', style: textSubtitleStyle,),
                    onTap: () {
                      // Добавьте здесь обработчик для пункта "Динамичные данные пользователя"
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.lock, color: blueColor),
                    title: Text('Смена пароля', style: textSubtitleStyle,),
                    onTap: () {
                      // Добавьте здесь обработчик для пункта "Смена пароля"
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.create, color: blueColor),
                    title: Text('Создать свой план тренировок', style: textSubtitleStyle,),
                    onTap: () {
                      // Добавьте здесь обработчик для пункта "Смена пароля"
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.link, color: blueColor),
                    title: Text('Перейти на сайт', style: textSubtitleStyle,),
                    onTap: () {
                      // Добавьте здесь обработчик для пункта "Смена пароля"
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



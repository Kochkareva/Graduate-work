import 'dart:developer';

import 'package:flutter/material.dart';

import '../api_service/dynamic_info_service.dart';
import '../models/dynamic_info_model.dart';
import 'index.dart';

class HealthTracker extends StatefulWidget {
  const HealthTracker({super.key});

  @override
  State<HealthTracker> createState() => _HealthTrackerState();
}

class _HealthTrackerState extends State<HealthTracker> {
  late DynamicInfoModel dynamicInfoModel;
  double weight = 0.0;
  int physicalHealth = 0;
  int mentalHealth = 0;
  String generalHealth = 'Poor';
  int generalHealthId = 0;
  int sleepTime = 0;
  late double riskGroup;
  bool isInjury = false;
  bool isStress = false;
  Map<String, String> fieldMap = {
    'weight': 'вес',
    'sleep_time': 'длительность сна'
  };
  List<String> generalHealthState = [
    'Poor',
    'Fair',
    'Good',
    'Very good',
    'Excellent',
  ];

  bool _isFieldEmpty(String field) {
    switch (field) {
      case 'weight':
        return weight == 0.0;
      case 'sleep_time':
        return sleepTime == 0;

      default:
        return false;
    }
  }

  @override
  void initState() {
    getRiskGroup();
    super.initState();
  }

  Future<void> getRiskGroup() async {
    try {
      var result = await DynamicInfoService().getDynamicInfo();
      riskGroup = result!.riskGroupKp;
    } catch (e) {
      log('Произошла ошибка: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> createDynamicInfo() async {
    try {
      for (var field in fieldMap.keys) {
        if (_isFieldEmpty(field)) {
          throw Exception('Поле "${fieldMap[field]}" не заполнено');
        }
      }
      dynamicInfoModel = DynamicInfoModel(id: 1,
          createdAt: DateTime.now(),
          riskGroupKp: riskGroup,
          weight: weight,
          physicalHealth: physicalHealth,
          mentalHealth: mentalHealth,
          isDifficultToWalk: true,
          isBloodPressure: true,
          generalHealth: generalHealth,
          sleepTime: sleepTime);
      DynamicInfoService().createDynamicInfo(dynamicInfoModel);
    } catch (e) {
      log('Произошла ошибка ${e.toString()}');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final whiteColor = Theme
        .of(context)
        .colorScheme
        .onPrimary;
    final blueColor = Theme
        .of(context)
        .colorScheme
        .primary;
    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;
    final lightBlueColor = Color(0xFFBAC8FF);
    final titleText = textTheme.displayMedium!.copyWith(
      // color: theme.colorScheme.onPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    );
    return Scaffold(
      backgroundColor: lightBlueColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 25.0),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: whiteColor,),
                    iconSize: 40,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Index()),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 10),
                  child: Text(
                      'Добавить данные треккера здоровья',
                      style: titleText, softWrap: true, textAlign: TextAlign.center,),
                ),
              ],
            ),
            Container(
              constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.height * 0.83),
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(70.0),
                  topRight: Radius.circular(70.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 5.0, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 25.0),
                      child: Text(
                          'Укажите ваш вес', style: textTheme.displayMedium!
                          .copyWith(
                          fontSize: 14
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 25.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Вес в килограммах',
                          hintText: '60.5',
                          suffixText: 'кг',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 20.0),
                          labelStyle: const TextStyle(fontSize: 14),
                          hintStyle: const TextStyle(fontSize: 14),
                        ),
                        onChanged: (value) {
                          weight = double.parse(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 25.0),
                      child: Text(
                          'Получали ли вы какие-либо травмы за последний месяц?',
                          style: textTheme.displayMedium!
                              .copyWith(
                              fontSize: 14
                          )),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 160,
                          child: ListTile(
                            dense: true,
                            title: Text('да', style: textTheme.displayMedium!
                                .copyWith(
                                fontSize: 14
                            )),
                            leading: Radio<bool>(
                              value: true,
                              groupValue: isInjury,
                              onChanged: (bool?value) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContextcontext) {
                                      return SimpleDialog(
                                        title: Text(
                                            'Сколько дней длилось недомогание?',
                                            style: textTheme.displayMedium!
                                                .copyWith(
                                                fontSize: 14
                                            )),
                                        children: <Widget>[
                                          SimpleDialogOption(
                                            child: TextField(
                                              decoration: InputDecoration(
                                                labelText: 'Количество дней',
                                                hintText: '5',
                                                suffixText: 'дней',
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
                                                physicalHealth =
                                                    int.parse(value);
                                              },
                                            ),
                                          ),
                                          SimpleDialogOption(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                              },
                                              child: const Text('Ок'),
                                            ),
                                          )
                                        ],
                                      );
                                    });
                                setState(() {
                                  isInjury = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: ListTile(
                            dense: true,
                            title: Text('нет', style: textTheme.displayMedium!
                                .copyWith(
                                fontSize: 14
                            )),
                            leading: Radio<bool>(
                              value: false,
                              groupValue: isInjury,
                              onChanged: (bool?value) {
                                setState(() {
                                  isInjury = value!;
                                  physicalHealth = 0;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 25.0),
                      child: Text(
                          'Были ли у вас проблемы с ментальным самочувствием за последний месяц?',
                          style: textTheme.displayMedium!
                              .copyWith(
                              fontSize: 14
                          )),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 160,
                          child: ListTile(
                            dense: true,
                            title: Text('да', style: textTheme.displayMedium!
                                .copyWith(
                                fontSize: 14
                            )),
                            leading: Radio<bool>(
                              value: true,
                              groupValue: isStress,
                              onChanged: (bool?value) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SimpleDialog(
                                        title: Text(
                                            'Сколько дней это длилось?',
                                            style: textTheme.displayMedium!
                                                .copyWith(
                                                fontSize: 14
                                            )),
                                        children: <Widget>[
                                          SimpleDialogOption(
                                            child: TextField(
                                              decoration: InputDecoration(
                                                labelText: 'Количество дней',
                                                hintText: '5',
                                                suffixText: 'дней',
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
                                                mentalHealth = int.parse(value);
                                              },
                                            ),
                                          ),
                                          SimpleDialogOption(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                              },
                                              child: const Text('Ок'),
                                            ),
                                          )
                                        ],
                                      );
                                    });
                                setState(() {
                                  isStress = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: ListTile(
                            dense: true,
                            title: Text('нет', style: textTheme.displayMedium!
                                .copyWith(
                                fontSize: 14
                            )),
                            leading: Radio<bool>(
                              value: false,
                              groupValue: isStress,
                              onChanged: (bool?value) {
                                setState(() {
                                  isStress = value!;
                                  mentalHealth = 0;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 25.0),
                      child: Text(
                          'Как бы вы оценили свое самочувствие в целом?',
                          style: textTheme.displayMedium!
                              .copyWith(
                              fontSize: 14
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 0, right: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                              'Плохое',
                              style: textTheme.displayMedium!
                                  .copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(
                              'Нормальное',
                              style: textTheme.displayMedium!
                                  .copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(
                              'Хорошее',
                              style: textTheme.displayMedium!
                                  .copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(
                              'Очень хорошее',
                              style: textTheme.displayMedium!
                                  .copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(
                              'Превосходное',
                              style: textTheme.displayMedium!
                                  .copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                    Slider(
                      value: generalHealthId.toDouble(),
                      max: 4,
                      divisions: 4,
                      label: [
                        'Плохое',
                        'Нормальное',
                        'Хорошее',
                        'Очень хорошее',
                        'Превосходное',
                      ][generalHealthId],
                      onChanged: (double value) {
                        setState(() {
                          print(generalHealth);
                          generalHealthId = value.toInt();
                          generalHealth = generalHealthState[generalHealthId];
                          print(generalHealth);
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 25.0),
                      child: Text(
                          'Укажите, сколько часов в среднем вы спите в сутки',
                          style: textTheme.displayMedium!
                              .copyWith(
                              fontSize: 14
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 25.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Количество часов',
                          hintText: '8',
                          suffixText: 'часов',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 20.0),
                          labelStyle: const TextStyle(fontSize: 14),
                          hintStyle: const TextStyle(fontSize: 14),
                        ),
                        onChanged: (value) {
                          sleepTime = int.parse(value);
                        },
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            createDynamicInfo().then((result) {
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
                          child: const Text('Сохранить'),
                        ),
                      ),
                    ),
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

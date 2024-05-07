import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:modile_app/models/survey_model.dart';
import 'package:modile_app/pages/index.dart';

import '../api_service/user_service.dart';

class Survey extends StatelessWidget {
  const Survey({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme
            .of(context)
            .colorScheme
            .onPrimary,
        child:  const Center(
            child: Questions(),
          ),
    );
  }
}

class Questions extends StatefulWidget {
  const Questions({super.key});

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;

  late int codeFromMail;
  DateTime dateOfChange = DateTime.now();
  int generalHealthId = 0;
  bool isInjury = false;
  bool isStress = false;
  List<String> generalHealthState = [
    'Poor',
    'Fair',
    'Good',
    'Very good',
    'Excellent',
  ];

  late SurveyModel surveyModel;
  bool isSurveyDone = false;

  //----------------------------- Survey data ----------------------------------
  bool isUsingDataAgreed = true;
  int height = 0;
  bool? isHeartDiseased;
  bool? isDiabetic;
  bool? isDiabeticWithDiseases;
  int? diabeticPeriod = 0;
  bool isPhysicalActivity  = false;
  bool? isKidneyDiseased;
  bool? isKidneyDiseaseChronic;
  bool? isCholesterol;
  bool? isStroked;
  bool? isBloodPressure;
  bool isSmoker  = false;
  bool isAlcoholic = false;
  bool isAsthmatic  = false;
  bool isSkinCancer = false;
  double weight = 0.0;
  int physicalHealth = 0;
  int mentalHealth = 0;
  late bool isDifficultToWalk = false;
  String generalHealth = 'Poor';
  int sleepTime = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  Map<String, String> fieldMap = {
    'height': 'рост',
    'weight': 'вес',
    'sleep_time': 'длительность сна'
  };

  bool _isFieldEmpty(String field) {
    switch (field) {
      case 'height':
        return height == 0;
      case 'weight':
        return weight == 0.0;
      case 'sleep_time':
        return sleepTime == 0;

      default:
        return false;
    }
  }

  Future<void> surveyUser() async{
    try {
      for (var field in fieldMap.keys) {
        if (_isFieldEmpty(field)) {
          throw Exception('Поле "${fieldMap[field]}" не заполнено');
        }
      }
      surveyModel = SurveyModel(isUsingDataAgreed: isUsingDataAgreed, height: height, isHeartDiseased: isHeartDiseased,
          isDiabetic: isDiabetic, isDiabeticWithDiseases: isDiabeticWithDiseases, diabeticPeriod: diabeticPeriod,
          isPhysicalActivity: isPhysicalActivity, isKidneyDiseased: isKidneyDiseased,
          isKidneyDiseaseChronic: isKidneyDiseaseChronic, isCholesterol: isCholesterol,
          isStroked: isStroked, isBloodPressure: isBloodPressure, isSmoker: isSmoker, isAlcoholic: isAlcoholic,
          isAsthmatic: isAsthmatic, isSkinCancer: isSkinCancer, weight: weight, physicalHealth: physicalHealth,
          mentalHealth: mentalHealth, isDifficultToWalk: isDifficultToWalk, generalHealth: generalHealth,
          sleepTime: sleepTime);
      await UserService().surveyUser(surveyModel);
      setState(() {
        isSurveyDone = true;
      });
    }catch(e){
      setState(() {
        isSurveyDone = false;
      });
      log(e.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;

    return Material(
      color: Theme
          .of(context)
          .colorScheme
          .onPrimary,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Scaffold(
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .onPrimary,
            resizeToAvoidBottomInset: true,
            body: PageView(
              controller: _pageViewController,
              onPageChanged: _handlePageViewChanged,
              children: <Widget>[
                //-------------------- Страница 1 -----------------------
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30.0, right: 30.0, top: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: Text(
                          'Помогите нам стать лучше!',
                          textAlign: TextAlign.center,
                          style: Theme
                              .of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              'Согласны ли вы предоставть свои данные опроса для дальнейшего '
                                  'обучения системы с целью улучшения её работы?',
                              textAlign: TextAlign.center, style: Theme
                                .of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                fontSize: 14
                            ),),
                          ),
                          RadioListTile(
                            dense: true,
                            title: Text(
                                'Я даю согласие на обработку своих персональных данных',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                    fontSize: 14
                                )),
                            value: true,
                            groupValue: isUsingDataAgreed,
                            onChanged: (value) {
                              setState(() {
                                isUsingDataAgreed = true;
                              });
                            },
                          ),
                          RadioListTile(
                            dense: true,
                            title: Text('Нет', style: Theme
                                .of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                fontSize: 14
                            )),
                            value: false,
                            groupValue: isUsingDataAgreed,
                            onChanged: (value) {
                              setState(() {
                                isUsingDataAgreed = false;
                              });
                            },

                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //-------------------- Страница 2 -----------------------
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Давайте познакомимся!', textAlign: TextAlign.center,
                        style: Theme
                            .of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 50.0,),
                        child: Text(
                            'Укажите ваш рост', style: textTheme.displayMedium!
                            .copyWith(
                            fontSize: 14
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Рост в сантиметрах',
                            hintText: '165',
                            suffixText: 'см',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 20.0),
                            labelStyle: const TextStyle(fontSize: 14),
                            hintStyle: const TextStyle(fontSize: 14),
                          ),
                          onChanged: (value) {
                            height = int.parse(value);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0),
                        child: Text(
                            'Укажите ваш вес', style: textTheme.displayMedium!
                            .copyWith(
                            fontSize: 14
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0),
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
                        padding: const EdgeInsets.only(
                            top: 20.0),
                        child: Text(
                            'Укажите, сколько часов в среднем вы спите в сутки',
                            style: textTheme.displayMedium!
                                .copyWith(
                                fontSize: 14
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0),
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
                    ],
                  ),
                ),
                //-------------------- Страница 3 -----------------------
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Расскажите о ваших привычках!',
                        textAlign: TextAlign.center,
                        style: Theme
                            .of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 60.0),
                        child: Text('Употребляете ли вы алкоголь?',
                            style: textTheme.displayMedium!
                                .copyWith(
                                fontSize: 14
                            )),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('Да', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: true,
                              groupValue: isAlcoholic,
                              onChanged: (value) {
                                setState(() {
                                  isAlcoholic = true;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('Нет', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: false,
                              groupValue: isAlcoholic,
                              onChanged: (value) {
                                setState(() {
                                  isAlcoholic = false;
                                });
                              },

                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text('Вы курите (курили когда либо)?',
                            style: textTheme.displayMedium!
                                .copyWith(
                                fontSize: 14
                            )),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('Да', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: true,
                              groupValue: isSmoker,
                              onChanged: (value) {
                                setState(() {
                                  isSmoker = true;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('Нет', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: false,
                              groupValue: isSmoker,
                              onChanged: (value) {
                                setState(() {
                                  isSmoker = false;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text('Занимаетесь ли вы спортом?',
                            style: textTheme.displayMedium!
                                .copyWith(
                                fontSize: 14
                            )),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('Да', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: true,
                              groupValue: isPhysicalActivity,
                              onChanged: (value) {
                                setState(() {
                                  isPhysicalActivity = true;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('Нет', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: false,
                              groupValue: isPhysicalActivity,
                              onChanged: (value) {
                                setState(() {
                                  isPhysicalActivity = false;
                                });
                              },

                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //-------------------- Страница 4 -----------------------
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Начнём заполнять вашу медицинскую карту!',
                        textAlign: TextAlign.center,
                        style: Theme
                            .of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),),

                      Padding(
                        padding: const EdgeInsets.only(
                            top: 60.0),
                        child: Text(
                            'Есть ли у вас диагностированные сердечно-сосудистые заболевания?',
                            style: textTheme.displayMedium!
                                .copyWith(
                                fontSize: 14
                            )),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('Да', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: true,
                              groupValue: isHeartDiseased,
                              onChanged: (value) {
                                setState(() {
                                  isHeartDiseased = true;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('Нет', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: false,
                              groupValue: isHeartDiseased,
                              onChanged: (value) {
                                setState(() {
                                  isHeartDiseased = false;
                                });
                              },

                            ),
                          ),
                        ],
                      ),
                      RadioListTile(
                        dense: true,
                        title: Text('Не знаю', style: textTheme.displayMedium!
                            .copyWith(
                            fontSize: 14
                        )),
                        value: null,
                        groupValue: isHeartDiseased,
                        onChanged: (value) {
                          setState(() {
                            isHeartDiseased = value;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text('Был ли у вас инсульт?',
                            style: textTheme.displayMedium!
                                .copyWith(
                                fontSize: 14
                            )),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('Да', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: true,
                              groupValue: isStroked,
                              onChanged: (value) {
                                setState(() {
                                  isStroked = true;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('Нет', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: false,
                              groupValue: isStroked,
                              onChanged: (value) {
                                setState(() {
                                  isStroked = false;
                                });
                              },

                            ),
                          ),
                        ],
                      ),
                      RadioListTile(
                        dense: true,
                        title: Text('Не знаю', style: textTheme.displayMedium!
                            .copyWith(
                            fontSize: 14
                        )),
                        value: null,
                        groupValue: isStroked,
                        onChanged: (value) {
                          setState(() {
                            isStroked = value;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0),
                        child: Text(
                            'Есть ли у вас сахарный диабет?',
                            style: textTheme.displayMedium!
                                .copyWith(
                                fontSize: 14
                            )),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('да', style: textTheme.displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: true,
                              groupValue: isDiabetic,
                              onChanged: (bool?value) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SimpleDialog(
                                          title: Text(
                                              'Укажите продолжительность вашего сахарного диабета:',
                                              style: textTheme.displayMedium!
                                                  .copyWith(
                                                  fontSize: 14
                                              )),
                                          children: <Widget>[
                                            SimpleDialogOption(
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  labelText: 'Количество лет',
                                                  hintText: '5',
                                                  suffixText: 'лет',
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
                                                  diabeticPeriod =
                                                      int.parse(value);
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0,
                                                  right: 20.0,
                                                  top: 10.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                      'Есть ли у вас заболевания из списка ниже:',
                                                      style: textTheme
                                                          .displayMedium!
                                                          .copyWith(
                                                          fontSize: 14
                                                      )),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.check_sharp),
                                                      Text(
                                                          'Ретинопатия, глаукома, катаракта',
                                                          style: textTheme
                                                              .displayMedium!
                                                              .copyWith(
                                                              fontSize: 14
                                                          )),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.check_sharp),
                                                      Text(
                                                          'Нефропатия, ХПН',
                                                          style: textTheme
                                                              .displayMedium!
                                                              .copyWith(
                                                              fontSize: 14
                                                          )),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.check_sharp),
                                                      Text(
                                                          'Инсульт, ТИА',
                                                          style: textTheme
                                                              .displayMedium!
                                                              .copyWith(
                                                              fontSize: 14
                                                          )),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.check_sharp),
                                                      Text(
                                                          'Стенокардия, ИМ, ХСН',
                                                          style: textTheme
                                                              .displayMedium!
                                                              .copyWith(
                                                              fontSize: 14
                                                          )),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.check_sharp),
                                                      Text(
                                                          'Периферическая нейропатия',
                                                          style: textTheme
                                                              .displayMedium!
                                                              .copyWith(
                                                              fontSize: 14
                                                          )),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.check_sharp),
                                                      Text(
                                                          'Поражение сосудов',
                                                          style: textTheme
                                                              .displayMedium!
                                                              .copyWith(
                                                              fontSize: 14
                                                          )),
                                                    ],
                                                  ),
                                                  RadioListTile(
                                                    dense: true,
                                                    title: Text('да',
                                                        style: textTheme
                                                            .displayMedium!
                                                            .copyWith(
                                                            fontSize: 14
                                                        )),
                                                    value: true,
                                                    groupValue: isDiabeticWithDiseases,
                                                    onChanged: (bool?value) {
                                                      setState(() {
                                                        isDiabeticWithDiseases =
                                                        value!;
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    },
                                                  ),
                                                  RadioListTile(
                                                    dense: true,
                                                    title: Text('нет',
                                                        style: textTheme
                                                            .displayMedium!
                                                            .copyWith(
                                                            fontSize: 14
                                                        )),
                                                    value: false,
                                                    groupValue: isDiabeticWithDiseases,
                                                    onChanged: (bool?value) {
                                                      setState(() {
                                                        isDiabeticWithDiseases =
                                                        value!;
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),

                                          ]);
                                    });
                                setState(() {
                                  isDiabetic = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('нет', style: textTheme.displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: false,
                              groupValue: isDiabetic,
                              onChanged: (bool?value) {
                                setState(() {
                                  isDiabetic = value!;
                                  isDiabeticWithDiseases = null;
                                  diabeticPeriod = 0;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      RadioListTile(
                        dense: true,
                        title: Text('Не знаю', style: textTheme.displayMedium!
                            .copyWith(
                            fontSize: 14
                        )),
                        value: null,
                        groupValue: isDiabetic,
                        onChanged: (value) {
                          setState(() {
                            isDiabetic = null;
                            isDiabeticWithDiseases = null;
                            diabeticPeriod = 0;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                //-------------------- Страница 5 -----------------------
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Продолжим заполнять вашу медицинскую карту!',
                        textAlign: TextAlign.center,
                        style: Theme
                            .of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 60.0),
                        child: Text(
                            'Есть ли у вас диагностированные хронические заболевания почек?',
                            style: textTheme.displayMedium!
                                .copyWith(
                                fontSize: 14
                            )),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('Да', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: true,
                              groupValue: isKidneyDiseased,
                              onChanged: (value) {
                                setState(() {
                                  isKidneyDiseased = true;
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SimpleDialog(
                                            title: Text(
                                                'Они выражены в острой или умеренной форме?',
                                                style: textTheme.displayMedium!
                                                    .copyWith(
                                                    fontSize: 14
                                                )),
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 20.0,
                                                    top: 10.0),
                                                child: Column(
                                                  children: [
                                                    RadioListTile(
                                                      dense: true,
                                                      title: Text('Острой',
                                                          style: textTheme
                                                              .displayMedium!
                                                              .copyWith(
                                                              fontSize: 14
                                                          )),
                                                      value: true,
                                                      groupValue: isKidneyDiseaseChronic,
                                                      onChanged: (bool?value) {
                                                        setState(() {
                                                          isKidneyDiseaseChronic =
                                                          value!;
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                      },
                                                    ),
                                                    RadioListTile(
                                                      dense: true,
                                                      title: Text('Умеренной',
                                                          style: textTheme
                                                              .displayMedium!
                                                              .copyWith(
                                                              fontSize: 14
                                                          )),
                                                      value: false,
                                                      groupValue: isKidneyDiseaseChronic,
                                                      onChanged: (bool?value) {
                                                        setState(() {
                                                          isKidneyDiseaseChronic =
                                                          value!;
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            ]);
                                      });
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('Нет', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: false,
                              groupValue: isKidneyDiseased,
                              onChanged: (value) {
                                setState(() {
                                  isKidneyDiseased = false;
                                  isKidneyDiseaseChronic = null;
                                });
                              },

                            ),
                          ),
                        ],
                      ),
                      RadioListTile(
                        dense: true,
                        title: Text('Не знаю', style: textTheme.displayMedium!
                            .copyWith(
                            fontSize: 14
                        )),
                        value: null,
                        groupValue: isKidneyDiseased,
                        onChanged: (value) {
                          setState(() {
                            isKidneyDiseased = value;
                            isKidneyDiseaseChronic = null;
                          });
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0),
                        child: Text(
                            'Повышен ли ваш общий уровень холестерина? (больше 8ммоль/л)',
                            style: textTheme.displayMedium!
                                .copyWith(
                                fontSize: 14
                            )),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('Да', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: true,
                              groupValue: isCholesterol,
                              onChanged: (value) {
                                setState(() {
                                  isCholesterol = true;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('Нет', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: false,
                              groupValue: isCholesterol,
                              onChanged: (value) {
                                setState(() {
                                  isCholesterol = false;
                                });
                              },

                            ),
                          ),
                        ],
                      ),
                      RadioListTile(
                        dense: true,
                        title: Text('Не знаю', style: textTheme.displayMedium!
                            .copyWith(
                            fontSize: 14
                        )),
                        value: null,
                        groupValue: isCholesterol,
                        onChanged: (value) {
                          setState(() {
                            isCholesterol = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                //-------------------- Страница 6 -----------------------
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Заканчиваем заполнять вашу медицинскую карту!',
                        textAlign: TextAlign.center,
                        style: Theme
                            .of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 60.0),
                        child: Text(
                            'Страдаете ли вы от повышенного давления? (повышенное - в среднем 180 / 100 или больше)',
                            style: textTheme.displayMedium!
                                .copyWith(
                                fontSize: 14
                            )),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('Да', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: true,
                              groupValue: isBloodPressure,
                              onChanged: (value) {
                                setState(() {
                                  isBloodPressure = true;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('Нет', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: false,
                              groupValue: isBloodPressure,
                              onChanged: (value) {
                                setState(() {
                                  isBloodPressure = false;
                                });
                              },

                            ),
                          ),
                        ],
                      ),
                      RadioListTile(
                        dense: true,
                        title: Text('Не знаю', style: textTheme.displayMedium!
                            .copyWith(
                            fontSize: 14
                        )),
                        value: null,
                        groupValue: isBloodPressure,
                        onChanged: (value) {
                          setState(() {
                            isBloodPressure = value;
                          });
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0),
                        child: Text(
                            'У вас есть астма?',
                            style: textTheme.displayMedium!
                                .copyWith(
                                fontSize: 14
                            )),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('Да', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: true,
                              groupValue: isAsthmatic,
                              onChanged: (value) {
                                setState(() {
                                  isAsthmatic = true;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('Нет', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: false,
                              groupValue: isAsthmatic,
                              onChanged: (value) {
                                setState(() {
                                  isAsthmatic = false;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0),
                        child: Text(
                            'Вы страдаете от рака кожи?',
                            style: textTheme.displayMedium!
                                .copyWith(
                                fontSize: 14
                            )),
                      ),

                      Row(
                        children: [
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('Да', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: true,
                              groupValue: isSkinCancer,
                              onChanged: (value) {
                                setState(() {
                                  isSkinCancer = true;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 160,
                            child: RadioListTile(
                              dense: true,
                              title: Text('Нет', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  fontSize: 14
                              )),
                              value: false,
                              groupValue: isSkinCancer,
                              onChanged: (value) {
                                setState(() {
                                  isSkinCancer = false;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //-------------------- Страница 7 -----------------------
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Финальный шаг!',
                      textAlign: TextAlign.center,
                      style: Theme
                          .of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 60.0, left: 30.0, right: 30.0),
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
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 30.0, right: 30.0),
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
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 30.0, right: 30.0),
                      child: Text(
                          'Испытываете ли вы трудности при ходьбе?',
                          style: textTheme.displayMedium!
                              .copyWith(
                              fontSize: 14
                          )),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 160,
                          child: RadioListTile(
                            dense: true,
                            title: Text('Да', style: Theme
                                .of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                fontSize: 14
                            )),
                            value: true,
                            groupValue: isDifficultToWalk,
                            onChanged: (value) {
                              setState(() {
                                isDifficultToWalk = true;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: RadioListTile(
                            dense: true,
                            title: Text('Нет', style: Theme
                                .of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                fontSize: 14
                            )),
                            value: false,
                            groupValue: isDifficultToWalk,
                            onChanged: (value) {
                              setState(() {
                                isDifficultToWalk = false;
                              });
                            },

                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 30.0, right: 30.0),
                      child: Text(
                          'Как бы вы оценили свое самочувствие в целом?',
                          style: textTheme.displayMedium!
                              .copyWith(
                              fontSize: 14
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
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
                    //----------------- Завершение опроса ----------------
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 35.0, right: 35.0, top: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          surveyUser().then((result) {
                            if (isSurveyDone) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Index()),
                              );
                            }
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
                        child: const Text('Завершить'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PageIndicator(
            tabController: _tabController,
            currentPageIndex: _currentPageIndex,
            onUpdateCurrentPageIndex: _updateCurrentPageIndex,
          ),
        ],
      ),
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme
        .of(context)
        .colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 0) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex - 1);
            },
            icon: const Icon(
              Icons.arrow_left_rounded,
              size: 32.0,
            ),
          ),
          TabPageSelector(
            controller: tabController,
            color: colorScheme.background,
            selectedColor: colorScheme.primary,
          ),
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 6) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex + 1);
            },
            icon: const Icon(
              Icons.arrow_right_rounded,
              size: 32.0,
            ),
          ),
        ],
      ),
    );
  }
}
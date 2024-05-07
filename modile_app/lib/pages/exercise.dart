import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:modile_app/pages/complete_training.dart';

import '../api_service/dynamic_info_service.dart';
import '../logic/google_connect.dart';
import '../logic/google_connect_logic.dart';
import '../logic/regulator.dart';
import '../logic/training_regulation.dart';
import '../models/dynamic_info_model.dart';
import '../models/exercise_model.dart';
import 'package:modile_app/contracts/enums/intensity_enum.dart';

class Exercise extends StatefulWidget {

  late List<ExerciseModel> exercises;
  late Intensity intensity;

  Exercise({super.key, required this.exercises, required this.intensity});

  @override
  State<Exercise> createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {

  List<ExerciseModel> exerciseList = [];
  late Future<bool> isInitDone;
  int currentExercise = 0;
  /// утомление
  bool? isFatigue;
  /// Боли в сердце
  bool? isPainHeartArea;
  /// Отдышка
  bool? isShortnessBreath;
  /// Длительность выполнения тренировки
  int timeExercise = 0;
  late Intensity intensity;
  double coefRestTime = 1;
  late Regulator regulator;
  /// Группа риска пользователя
  late double riskGroup;
  // riskCorrector
  // trainingGroupRisk

  @override
  void initState() {
    isInitDone = fetchData();

    intensity = widget.intensity;
    regulator = Regulator(restTime: 30, intensity: intensity.index.toDouble() + 1, workoutMonitor: 0);
    super.initState();
  }

  /// Заменить на запрос о тренировках в планах
  Future<bool> fetchData() async {
    try {
      var result = await DynamicInfoService().getDynamicInfo();
      riskGroup = result!.riskGroupKp;
      exerciseList.addAll(widget.exercises);
      print(riskGroup);
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (error) {
      log(error.toString());
      throw Exception(error.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blackTextStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 14,
    );
    return Scaffold(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .onPrimary,
        body: FutureBuilder(future: isInitDone,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  return SingleChildScrollView(
                      child: _buildListViewProduct(exerciseList)
                  );

                  return const Center(child: CircularProgressIndicator());
              }
            }
        ));
  }

  Widget _buildListViewProduct(List<ExerciseModel> exercises) {
    final theme = Theme.of(context);
    final blackTextStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 20,
      fontFamily: 'Montserrat',
    );
    final blueBoldTextStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 14,
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    );
    final bigBlueTextStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 128,
      color: theme.colorScheme.primary,
      fontFamily: 'Montserrat',
    );
    final blackBoldTextStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    );
    final greyColor = Theme
        .of(context)
        .colorScheme
        .secondary;
    const lightGreyColor = Color(0xFFC0C0C0);
    final blueColor = Theme
        .of(context)
        .colorScheme
        .primary;
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 30.0, right: 30.0),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Изображение с выполнением упражнения
            Container(
              width: 250.0,
              height: 250.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(exercises[currentExercise].picture),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: greyColor.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),),
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    // Название и описание упражнения
                    child: Row(
                      children: [
                        SizedBox(
                          width: 250,
                          child: Text(
                            exercises[currentExercise].name,
                            textAlign: TextAlign.left,
                            style: blackBoldTextStyle,
                            maxLines: 2,
                            // Set the maximum number of lines
                            overflow: TextOverflow.ellipsis,),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    SimpleDialog(
                                      title: Text(
                                          'Описание',
                                          style: blackBoldTextStyle),
                                      children: <Widget>[
                                        SimpleDialogOption(
                                          child: Text(
                                              exercises[currentExercise]
                                                  .description
                                          ),
                                        ),
                                        SimpleDialogOption(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Понятно'),
                                          ),
                                        )
                                      ],
                                    )
                            );
                          },
                          icon: Icon(Icons.help, size: 25.0, color: blueColor,),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text(exercises[currentExercise].amount == null
                        ? 'Общая длительность:'
                        : 'Количество выполнений:',
                      style: blackTextStyle,),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Кнопка перехода к предыдущему упражнению
                        SizedBox(
                          width: 55,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (currentExercise > 0) {
                                  currentExercise--;
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios, color: lightGreyColor,
                              size: 55,),
                          ),
                        ),
                        // Количество выполнений / длительность выполнения упражнения
                        // SizedBox(
                        //   width: 180,
                        //   child: Text(exercises[currentExercise].amount == null
                        //       ? exercises[currentExercise].time.toString()
                        //       : exercises[currentExercise].amount.toString(),
                        //     style: bigBlueTextStyle, textAlign: TextAlign.center, ),
                        // ),
                        SizedBox(
                          width: 215,
                          child: Text(exercises[currentExercise].amount == null
                          // ? showTimeExercise((exercises[currentExercise].time!)!*(intensity.index+1)).toString()
                              ? showTimeExercise(((exercises[currentExercise]
                              .time!)! * (regulator.intensity)).toInt())
                              .toString()
                          // : ((exercises[currentExercise].amount)!*(intensity.index+1)).toString(),
                              : (((exercises[currentExercise].amount)! *
                              (regulator.intensity)).toInt()).toString(),
                            style: bigBlueTextStyle,
                            textAlign: TextAlign.center,),
                        ),
                        // Кнопка перехода к следующему упражнению
                        SizedBox(
                          width: 55,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                if(currentExercise == (exercises.length - 1)){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CompleteTraining(isSuccess: true, countExercises: currentExercise + 1),
                                      ));
                                }
                                if (currentExercise < exercises.length - 1) {
                                  currentExercise++;
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios, color: lightGreyColor,
                              size: 55,),

                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Text(exercises[currentExercise].amount == null
                        ? 'секунд'
                        : 'раз',
                      style: blackTextStyle,),
                  ),
                ],
              ),
            ),
            // Кнопка запуска таймера
            Visibility(
              visible: exercises[currentExercise].amount == null,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    startTimer(((exercises[currentExercise].time!) *
                        regulator.intensity).toInt());
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // устанавливаем белый цвет фона
                    onPrimary: blueColor, // устанавливаем синий цвет текста
                    side: BorderSide(color: blueColor,
                        width: 2), // устанавливаем синюю рамку
                  ),
                  child: const Text("Запуск таймера"),
                ),
              ),
            ),
            // Кнопка выполнения упражнения
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if(currentExercise == (exercises.length - 1)){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CompleteTraining(isSuccess: true, countExercises: currentExercise + 1),
                          ));
                    }
                    if (currentExercise < exercises.length - 1) {
                      setState(() {
                        currentExercise++;
                        if (exercises[currentExercise].amount == null) {
                          timeExercise = ((exercises[currentExercise].time!)! *
                              (regulator.intensity)).toInt();
                        }
                      });
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (
                              // context) => BuildPause(nextExercise: exercises[currentExercise], restTime: ((exercises[currentExercise].restTime)*coefRestTime.toInt()),)),
                              context) =>
                              BuildPause(
                                nextExercise: exercises[currentExercise],
                                restTime: ((exercises[currentExercise]
                                    .restTime) + regulator.restTime),)),
                    );
                    if (currentExercise % 5 == 0) {
                      // утомление
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            title: Text(
                                'Есть Утомление?',
                                style: blackTextStyle),
                            children: <Widget>[
                              SimpleDialogOption(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                          top: 10.0),
                                      child: Column(
                                        children: [
                                          RadioListTile(
                                            dense: true,
                                            title: Text('Да',
                                                style: blackTextStyle),
                                            value: true,
                                            groupValue: isFatigue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isFatigue =
                                                    value;
                                                Navigator.of(context)
                                                    .pop();
                                              });
                                            },
                                          ),
                                          RadioListTile(
                                            dense: true,
                                            title: Text('Нет',
                                                style: blackTextStyle),
                                            value: false,
                                            groupValue: isFatigue,
                                            onChanged: (bool ?value) {
                                              setState(() {
                                                isFatigue =
                                                value!;
                                                Navigator.of(context)
                                                    .pop();
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ).then((value) {
                        // боли в сердце
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: Text(
                                  'У вас есть боли в сердце?',
                                  style: blackTextStyle),
                              children: <Widget>[
                                SimpleDialogOption(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0,
                                            right: 20.0,
                                            top: 10.0),
                                        child: Column(
                                          children: [
                                            RadioListTile(
                                              dense: true,
                                              title: Text('Да',
                                                  style: blackTextStyle),
                                              value: true,
                                              groupValue: isPainHeartArea,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  isPainHeartArea =
                                                      value;
                                                  Navigator.of(context)
                                                      .pop();
                                                });
                                              },
                                            ),
                                            RadioListTile(
                                              dense: true,
                                              title: Text('Нет',
                                                  style: blackTextStyle),
                                              value: false,
                                              groupValue: isPainHeartArea,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  isPainHeartArea =
                                                  value!;
                                                  Navigator.of(context)
                                                      .pop();
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ).then((value) {
                          // отдышка

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                title: Text(
                                    'У вас есть отдышка?',
                                    style: blackTextStyle),
                                children: <Widget>[
                                  SimpleDialogOption(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0,
                                              right: 20.0,
                                              top: 10.0),
                                          child: Column(
                                            children: [
                                              RadioListTile(
                                                dense: true,
                                                title: Text('Да',
                                                    style: blackTextStyle),
                                                value: true,
                                                groupValue: isShortnessBreath,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    isShortnessBreath =
                                                        value;
                                                    Navigator.of(context)
                                                        .pop();
                                                  });
                                                },
                                              ),
                                              RadioListTile(
                                                dense: true,
                                                title: Text('Нет',
                                                    style: blackTextStyle),
                                                value: false,
                                                groupValue: isShortnessBreath,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    isShortnessBreath =
                                                    value!;
                                                    Navigator.of(context)
                                                        .pop();
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ).then((value) {
                            /// Дождаться получения данных
                            /// Прям здесь проверку превышения ебануть, добавить также как и для верхних булевскую переменную и гуд
                            /// в Трайнинг регулатион даже метод есть
                            // Future<int> currentHeartRate = GoogleConnect().getHeartRate();

                            ///----------------------------------------------------------
                            if (isFatigue! || isPainHeartArea! ||
                                isShortnessBreath!) {
                              setState(() {
                                regulator =
                                    TrainingRegulation(riskGroup: riskGroup)
                                        .regulator(regulator);
                                isFatigue = null;
                                isPainHeartArea = null;
                                isShortnessBreath = null;
                              });
                              if (regulator.intensity == 0 &&
                                  regulator.restTime == 0) {
                                /// Критическое заершение тренировки
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CompleteTraining(isSuccess: false, countExercises: currentExercise + 1),
                                    ));
                              }
                            }
                          });
                        });
                      }
                      );
                    }
                  }
                  );
                },
                child: const Text('Выполнено'),
              ),
            ),
            // Кнопка завершения тренировки
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextButton(
                onPressed: () {

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
                        title: Text('Завершение тренировки', style: blackBoldTextStyle,),
                        content: Text('Вы плохо себя чувствуете?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CompleteTraining(isSuccess: true, countExercises: currentExercise + 1),
                                  ));
                            },
                            child: const Text('Нет'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CompleteTraining(isSuccess: false, countExercises: currentExercise + 1),
                                  ));
                            },
                            child: const Text('Да'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold,),
                ),
                child: const Text('Завершить тренировку'),
              ),
            ),
          ]
      ),
    );
  }

  late Timer _timer;

  int showTimeExercise(int time){
    if(timeExercise == 0) {
        timeExercise = time;
    }
    return timeExercise;
  }

  void startTimer(int start) {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (timeExercise == 1) {
          setState(() {
            timer.cancel();
            timeExercise--;
            if (currentExercise < exerciseList.length - 1) {
              currentExercise++;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (
                        context) => BuildPause(nextExercise: exerciseList[currentExercise], restTime: exerciseList[currentExercise].restTime,)),
              );
            }
          });
        } else {
          setState(() {
            timeExercise--;
          });
        }
      },
    );
  }
}

class BuildPause extends StatefulWidget {

  late ExerciseModel nextExercise;
  late int restTime;

  BuildPause({super.key, required this.nextExercise, required this.restTime});

  @override
  State<BuildPause> createState() => _BuildPauseState();
}

class _BuildPauseState extends State<BuildPause> {

  late Timer _timer;
  int _start = 10;

  @override
  void initState() {
    super.initState();
    _start = widget.restTime;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 1) {
          setState(() {
            timer.cancel();
            Navigator.of(context)
                .pop();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bigBlackTextStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 170,
      fontFamily: 'Montserrat',
      color: theme.colorScheme.primary,
    );
    final middleBlackTextStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    );
    final smallTextStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 16,
      fontFamily: 'Montserrat',
    );
    final greyColor = Theme
        .of(context)
        .colorScheme
        .secondary;
    final blueColor = Theme
        .of(context)
        .colorScheme
        .primary;
    final lightBlueColor = Color(0xFFBAC8FF);
    return Scaffold(
      appBar: AppBar(
          title: const Text("Отдых"), backgroundColor: lightBlueColor),
      backgroundColor: lightBlueColor,
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(70.0),
            topRight: Radius.circular(70.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 30.0, right: 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Подготовьтесь к упражнению:", style: middleBlackTextStyle,
                  textAlign: TextAlign.center),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 20.0, top: 15.0, left: 10.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 250,
                      child: Text(
                        widget.nextExercise.name,
                        textAlign: TextAlign.left,
                        style: smallTextStyle,
                        maxLines: 2,
                        // Set the maximum number of lines
                        overflow: TextOverflow.ellipsis,),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                SimpleDialog(
                                  title: Text(
                                      'Описание',
                                      style: middleBlackTextStyle),
                                  children: <Widget>[
                                    SimpleDialogOption(
                                      child: Text(
                                          widget.nextExercise.description
                                      ),
                                    ),
                                    SimpleDialogOption(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Понятно'),
                                      ),
                                    )
                                  ],
                                )
                        );
                      },
                      icon: Icon(Icons.help, size: 25.0, color: blueColor,),
                    ),
                  ],
                ),
              ),
              Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.nextExercise.picture),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: greyColor.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text("$_start", style: bigBlackTextStyle,
                    textAlign: TextAlign.center),
              ),
              ElevatedButton(
                onPressed: () {
                  startTimer();
                },
                child: const Text("Начать отдых"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold,),
                  ),
                  child: const Text('Завершить отдых'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




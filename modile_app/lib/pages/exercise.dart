import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:modile_app/api_service/training_service.dart';
import 'package:modile_app/pages/complete_training.dart';
import '../api_service/dynamic_info_service.dart';
import '../logic/regulator.dart';
import '../logic/training_regulation.dart';
import '../models/exercise_model.dart';
import 'package:modile_app/contracts/enums/intensity_enum.dart';
import '../models/plan_model.dart';
import '../models/training_model.dart';
import '../models/training_performance_model.dart';
import 'emergency_completion_training.dart';

class Exercise extends StatefulWidget {

  late List<ExerciseModel> exercises;
  late TrainingModel trainingModel;
  late PlanModel planModel;
  late Intensity intensity;

  Exercise({super.key, required this.exercises, required this.intensity, required this.planModel, required this.trainingModel});

  @override
  State<Exercise> createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {

  List<ExerciseModel> exerciseList = [];
  late Future<bool> isInitDone;
  int currentExercise = 0;
  /// утомление
  bool? isFatigue;
  bool midFatigue = false;
  /// Боли в сердце
  bool? isPainHeartArea;
  bool shortBreath = false;
  /// Отдышка
  bool? isShortnessBreath;
  bool heartAce = false;
  /// Длительность выполнения тренировки
  int timeExercise = 0;
  late Intensity intensity;
  double coefRestTime = 1;
  late Regulator regulator;
  /// Группа риска пользователя
  late double riskGroup;
  late TrainingModel trainingModel;
  late int trainingHeartRate;
  late Future<int> futureTrainingHeartRate;
  late List<double> pulse = [];
  /// Тестовые данные
  late double trainingRiskG = 0.5;
  // riskCorrector
  // trainingGroupRisk
  final AudioCache player = AudioCache();

  @override
  void initState() {
    isInitDone = initializeData();
    super.initState();
  }

  Future<bool> initializeData() async{
    exerciseList.addAll(widget.exercises);
    trainingModel = widget.trainingModel;
    intensity = widget.intensity;
    regulator = Regulator(restTime: 30, intensity: intensity.index.toDouble() + 1, workoutMonitor: 0);

    try {
      await fetchData();
      await getTrainHeartRate();
      double valuePulse = 0.0;
      valuePulse = await TrainingRegulation(riskGroup: riskGroup).getHeartRate();
      print('valuePulse: $valuePulse');
      pulse.add(valuePulse);
      print('trainingHeartRate: $trainingHeartRate');
      return true;
    } catch (error) {
      log('Ошибка: $error');
      return false;
    }
    return false;
  }

  Future<void> fetchData() async {
    try {
      var result = await DynamicInfoService().getDynamicInfo();
      riskGroup = result!.riskGroupKp;
    } catch (error) {
      log(error.toString());
      throw Exception('Ошибка при получении данных: ${error.toString()}');
    }
  }

  Future<void> getTrainHeartRate() async {
    try {
      var result = await TrainingRegulation(riskGroup: riskGroup).getTrainingHeartRate();
      trainingHeartRate = result;
    } catch (error) {
      log(error.toString());
      throw Exception('Ошибка при вычислении тренировочной ЧСС: ${error.toString()}');
    }
  }

  /// Завершение тренировки
  Future<void> completeTraining(TrainingPerformanceModel trainingPerformance) async {
    try {
      await TrainingService().createTrainingPerformance(trainingPerformance);
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
      padding: const EdgeInsets.only(top: 40.0,),
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
                    padding: const EdgeInsets.only(top: 20.0, left: 35),
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
                    padding: const EdgeInsets.only(top: 30.0, right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Кнопка перехода к предыдущему упражнению
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
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
                          width: MediaQuery.of(context).size.width * 0.55,
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
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                if(currentExercise == (exercises.length - 1)){
                                  completeTraining(TrainingPerformanceModel(slug: '${widget.planModel.slug}-${trainingModel.slug}', pulse: pulse, midFatigue: midFatigue, shortBreath: shortBreath, heartAce: heartAce, trainingRiskG: trainingRiskG, createdAt: DateTime.now()));
                                  Navigator.push(

                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CompleteTraining(isSuccess: true, countExercises: currentExercise + 1, pulse: pulse),
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
                  AudioPlayer().play(AssetSource('audio/my_audio.mp3'));
                  setState(() {
                    if(currentExercise == (exercises.length - 1)){
                      completeTraining(TrainingPerformanceModel(slug: '${widget.planModel.slug}-${trainingModel.slug}', pulse: pulse, midFatigue: midFatigue, shortBreath: shortBreath, heartAce: heartAce, trainingRiskG: trainingRiskG, createdAt: DateTime.now()));

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CompleteTraining(isSuccess: true, countExercises: currentExercise + 1, pulse: pulse),
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
                                                midFatigue = isFatigue!;
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
                                                  shortBreath = isPainHeartArea!;
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
                                                    heartAce = isShortnessBreath!;
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
                            print('Heart Training Rate:');
                            print(trainingHeartRate.toString());

                            final stopwatch = Stopwatch()..start();

                            bool isHeartRate = TrainingRegulation(riskGroup: riskGroup)
                                .checkHeartRate(trainingHeartRate);


                            ///----------------------------------------------------------
                            if (isFatigue! || isPainHeartArea! ||
                                isShortnessBreath! || isHeartRate) {
                              setState(() {
                                regulator =
                                    TrainingRegulation(riskGroup: riskGroup)
                                        .regulator(regulator);
                                isFatigue = null;
                                isPainHeartArea = null;
                                isShortnessBreath = null;
                              });
                              stopwatch.stop();
                              print('Time elapsed: ${stopwatch.elapsedMilliseconds} milliseconds');
                              if (regulator.intensity == 0 &&
                                  regulator.restTime == 0) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EmergencyCompletionTraining(),
                                    ));
                              }
                            }
                          });
                        });
                      }
                      );
                      setState(() async {
                        double valuePulse = 0.0; // Инициализация начального значения

                        valuePulse = await TrainingRegulation(riskGroup: riskGroup).getHeartRate();
                        print('valuePulse: $valuePulse');
                        pulse.add(valuePulse);
                      });
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


                              completeTraining(TrainingPerformanceModel(slug: '${widget.planModel.slug}-${trainingModel.slug}', pulse: pulse, midFatigue: midFatigue, shortBreath: shortBreath, heartAce: heartAce, trainingRiskG: trainingRiskG, createdAt: DateTime.now()));

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CompleteTraining(isSuccess: true, countExercises: currentExercise + 1, pulse: pulse),
                                  ));
                            },
                            child: const Text('Нет'),
                          ),
                          TextButton(
                            onPressed: () {
                              completeTraining(TrainingPerformanceModel(slug: '${widget.planModel.slug}-${trainingModel.slug}', pulse: pulse, midFatigue: midFatigue, shortBreath: shortBreath, heartAce: heartAce, trainingRiskG: trainingRiskG, createdAt: DateTime.now()));


                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CompleteTraining(isSuccess: false, countExercises: currentExercise + 1, pulse: pulse),
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




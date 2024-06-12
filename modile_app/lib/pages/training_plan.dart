import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:modile_app/api_service/plan_service.dart';
import 'package:modile_app/api_service/training_service.dart';
import 'package:modile_app/models/plan_model.dart';
import 'package:modile_app/models/training_model.dart';
import 'package:modile_app/models/training_performance_model.dart';
import 'package:modile_app/pages/exercises_training.dart';
import 'index.dart';

class TrainingPlan extends StatefulWidget {
  /// slug Плана
  late String slugPlan;

  TrainingPlan({super.key, required this.slugPlan});

  @override
  State<TrainingPlan> createState() => _TrainingPlanState();
}

class _TrainingPlanState extends State<TrainingPlan> {

  late Future<bool> isInitDone;
  late PlanModel planModel;
  /// Отслеживание плана
  late bool isFollowedPlan;

  /// Список тренировок
  late List<TrainingModel> listTrainings = [];

  /// Список выполненных тренировок
  late List<TrainingPerformanceModel> listTrainingPerformances = [];
  // late Future<List<TrainingPerformanceModel>> futureListTrainingPerformances;

  @override
  void initState() {
    // isInitDone = getData();
    isInitDone = initializeData();
    // futureListTrainingPerformances = getTrainingPerformance();
    super.initState();
  }

  Future<bool> initializeData() async{
    try {
      await getData();
      await getTrainingPerformance();
      return true;
    } catch (error) {
      log('Ошибка: $error');
      return false;
    }
    return false;
  }

  Future<bool> getData() async {
    try {
      planModel = (await PlanService().getPlan(widget.slugPlan))!;
      isFollowedPlan = planModel.iFollow;
      // updateChildWidget(isFollowedPlan);
      for(int i=1; i<=planModel.trainingAmount; i++){
        listTrainings.add(TrainingModel(name: 'Тренировка $i', number: i, slug: 'training-$i', exercises: []));
      }
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

  Future<List<TrainingPerformanceModel>> getTrainingPerformance() async{
    try {
      if(isFollowedPlan) {
        listTrainingPerformances +=
        (await TrainingService().getTrainingPerformanceByPlan(
            widget.slugPlan))!;
      }
    } catch (e) {
      rethrow;
    }
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    return listTrainingPerformances;
  }

  Future<void> followPlan() async {
    try {
      await PlanService().followPlan(planModel.slug);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> stopFollowPlan() async {
    try {
      await PlanService().stopFollowPlan(planModel.slug);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleWhiteTextStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    );
    final titleBlackTextStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    );
    final whiteTextStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontFamily: 'Montserrat',
      fontSize: 14,
    );
    final blackBoldTextStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    );
    final blackTextStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 14,
      fontFamily: 'Montserrat',
    );
    final whiteColor = Theme.of(context).colorScheme.onPrimary;
    final blueColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .onPrimary,
      body: FutureBuilder(
          future: isInitDone,
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 300.0, // Ширина блока
                        height: 250.0, // Высота блока
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(planModel.picture),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.4),
                            BlendMode.darken,
                          ),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 50.0, left: 10.0, top: 15.0),
                              child: IconButton(
                                icon: Icon(Icons.arrow_back, color: whiteColor,),
                                iconSize: 40,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (
                                            context) => const Index()),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(planModel.name,
                                  textAlign: TextAlign.left,
                                  style: titleWhiteTextStyle,maxLines: 5, // Set the maximum number of lines
                                  overflow: TextOverflow.ellipsis,),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0, left: 30, bottom: 20.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                    child: Row(
                                      children: List.generate(
                                        planModel.intensity.index + 1,
                                            (index) =>  Icon(Icons.flash_on,
                                          size: 15,
                                          color: whiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 3.0,
                                    height: 20.0,
                                    decoration: BoxDecoration(
                                      color: whiteColor, // Цвет блока
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text('${planModel.trainingAmount} тренировок', style: whiteTextStyle,),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 20.0),
                        child: Row(
                          children: [
                            Text(
                              'Инвентарь:   ',
                              style: blackBoldTextStyle,),
                            Text(
                              planModel.equipment.isNotEmpty ? planModel.equipment : 'Не требуется',
                              style: blackTextStyle,),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 15.0),
                        child: Row(
                          children: [
                            Text(
                              'Группа здоровья:   ',
                              style: blackBoldTextStyle,),
                            Text(
                              '${planModel.healthGroup.toString()}-я группа',
                              style: blackTextStyle,),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 5.0),
                        child: Row(
                          children: [
                            Text(
                              'Отслеживание:   ',
                              style: blackBoldTextStyle,),
                            Switch(
                              // This bool value toggles the switch.
                              value: isFollowedPlan,
                              activeColor: whiteColor,
                              inactiveTrackColor: const Color(0xFFF6F6F6), // Цвет фона в неактивном состоянии
                              activeTrackColor: blueColor,
                              onChanged: (bool value) {
                                if(!isFollowedPlan){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        surfaceTintColor: whiteColor,
                                        title: Text('Подтверждение', style: titleBlackTextStyle,),
                                        content: Text('Вы уверены, что хотите отслеживать этот план?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Отмена'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              followPlan().then((result) {
                                                setState(() {
                                                  isFollowedPlan = value;
                                                  planModel.iFollow = isFollowedPlan;
                                                  });
                                                Navigator.of(context).pop();
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => TrainingPlan(slugPlan: widget.slugPlan)),
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
                                            },
                                            child: const Text('Подтвердить'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }else{
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        surfaceTintColor: whiteColor,
                                        title: Text('Подтверждение', style: titleBlackTextStyle,),
                                        content: Text('Вы уверены, что хотите прекратить отслеживать этот план?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Отмена'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              stopFollowPlan().then((result) {
                                                setState(() {
                                                  isFollowedPlan = value;
                                                  planModel.iFollow = isFollowedPlan;
                                                });
                                                Navigator.of(context).pop();
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => TrainingPlan(slugPlan: widget.slugPlan)),
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
                                            },
                                            child: const Text('Подтвердить'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 30.0, bottom: 15.0),
                        child: Text(
                          'Тренировки:',
                          style: blackBoldTextStyle,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: ListTrainings(list: listTrainings, planModel: planModel, indexCompleted: listTrainingPerformances.length, isFollowedPlan: isFollowedPlan,),
                      ),
                    ],
                  ),
                );
            }
          }
      ),
    );
  }
}

class ListTrainings extends StatefulWidget {
  late List<TrainingModel> list;
  late PlanModel planModel;
  late int indexCompleted;
  late bool isFollowedPlan;

  ListTrainings({super.key, required this.list, required this.planModel, required this.indexCompleted, required this.isFollowedPlan});

  @override
  State<ListTrainings> createState() => _ListTrainingsState();
}

class _ListTrainingsState extends State<ListTrainings> {
  late List<TrainingModel> list = widget.list;

  /// номер тренировки, с которой надо начать
  late int indexCompleted = widget.indexCompleted;
  late bool isFollowedPlan = widget.isFollowedPlan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blackTextStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 14,
      fontFamily: 'Montserrat',
    );
    final blueColor = Theme
        .of(context)
        .colorScheme
        .primary;
    final whiteColor = Theme
        .of(context)
        .colorScheme
        .onPrimary;

    const grayColor = Color(0xFFE2E2E2);
    final lightBlueColor = Color(0xFFBAC8FF);
    return Column(
      children: [
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6, // Количество элементов в строке
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          itemCount: list.isEmpty ? 0 : list.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: index == (indexCompleted) ? blueColor : whiteColor, // Цвет пунктирной линии
                    width: 2, // Толщина линии
                  ),
                  borderRadius: BorderRadius.circular(50), // Задайте радиус по вашему усмотрению
                ),
                child: CircleAvatar(
                  backgroundColor: index > (indexCompleted - 1) ? whiteColor : grayColor,
                  child: Text('${index + 1}',
                    style: blackTextStyle,
                  ),
                ),
              ),
            );
          },
        ),
        if (isFollowedPlan)
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseTraining(
                    slugTraining: 'training-${indexCompleted + 1}',
                    planModel: widget.planModel,
                  ),
                ),
              );
            },
            child: const Text('Начать тренировку'),
          ),
      ],
    );

    // return Column(
    //   children: [
    //     ListView.builder(
    //       physics: const NeverScrollableScrollPhysics(),
    //       shrinkWrap: true,
    //       padding: const EdgeInsets.only(top: 8, left: 8, bottom: 8, right: 18),
    //       itemCount: list.isEmpty ? 0 : list.length,
    //       itemBuilder: (BuildContext context, int index) {
    //         return
    //           Column(
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.only(bottom: 5.0),
    //                 child: Card(
    //                   color: index > (indexCompleted - 1) ? whiteColor : grayColor,
    //                   surfaceTintColor: Theme
    //                       .of(context)
    //                       .colorScheme
    //                       .onPrimary,
    //                   shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(10.0), // Радиус скругления углов
    //                   ),
    //                   elevation: 5, // Тень карточки
    //                   child: ListTile(
    //                     // tileColor: index > (indexCompleted - 1) ? whiteColor : grayColor,
    //                     title: Text(
    //                       'Тренировка день ${index + 1}',
    //                       style: blackTextStyle,
    //                     ),
    //                     subtitle: Padding(
    //                       padding: const EdgeInsets.only(top: 15.0, left: 50, right: 50),
    //                       child: Column(
    //                         children: [
    //                           if (index == indexCompleted && isFollowedPlan)
    //                             ElevatedButton(
    //                               onPressed: () {
    //                                 Navigator.push(
    //                                   context,
    //                                   MaterialPageRoute(
    //                                     builder: (context) => ExerciseTraining(
    //                                       slugTraining: 'training-${index + 1}',
    //                                       planModel: widget.planModel,
    //                                     ),
    //                                   ),
    //                                 );
    //                               },
    //                               child: const Text('Начать тренировку'),
    //                             ),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           );
    //       },
    //     ),
    //   ],
    // );

    /*
    Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              ExerciseTraining(slugTraining: 'training-${_index + 1}', planModel: widget.planModel,)),
                        );
     */

    // return Scaffold(
    //   backgroundColor: Theme
    //       .of(context)
    //       .colorScheme
    //       .onPrimary,
    //   body: Stepper(
    //     currentStep: _index,
    //     connectorColor: MaterialStateProperty.resolveWith((states) {
    //       if (states.contains(MaterialState.disabled)) {
    //         return blueColor; // Color for disabled state
    //       }
    //       return Colors.deepOrange; // Default color
    //     }),
    //     onStepCancel: () {
    //       if (_index > 0) {
    //         setState(() {
    //           _index -= 1;
    //         });
    //       }
    //     },
    //     onStepContinue: () {
    //       if (_index < list.length - 1) {
    //         setState(() {
    //           _index += 1;
    //         });
    //       }
    //     },
    //     onStepTapped: (int index) {
    //       setState(() {
    //         _index = index;
    //       });
    //     },
    //     controlsBuilder: (BuildContext context,
    //         ControlsDetails controlsDetails) {
    //       return Padding(
    //         padding: const EdgeInsets.only(top: 10.0),
    //         child: Row(
    //           children: [
    //             if (_index < list.length - 1)
    //               SizedBox(
    //                 width: 120,
    //                 height: 40,
    //                 child: ElevatedButton(
    //                   onPressed: () {
    //                     controlsDetails.onStepContinue;
    //                     Navigator.push(
    //                       context,
    //                       MaterialPageRoute(builder: (context) =>
    //                           ExerciseTraining(slugTraining: 'training-${_index + 1}', planModel: widget.planModel,)),
    //                     );
    //                   },
    //                   child: Text('Начать'),
    //                 ),
    //               ),
    //             const SizedBox(width: 8),
    //             if (_index > 0)
    //               SizedBox(
    //                 width: 120,
    //                 height: 40,
    //                 child: TextButton(
    //                   onPressed: controlsDetails.onStepCancel,
    //                   child: Text('Назад'),
    //                 ),
    //               ),
    //           ],
    //         ),
    //       );
    //     },
    //     steps: List.generate(
    //       list.length,
    //           (index) {
    //         return Step(
    //           title: Text('Тренировка ${index + 1}', style: blackTextStyle,),
    //           content: Container(
    //             alignment: Alignment.centerLeft,
    //             child: Text('Начать тренировку ${index + 1}'),
    //           ),
    //         );
    //       },
    //     ),
    //   ),
    // );
  }
}


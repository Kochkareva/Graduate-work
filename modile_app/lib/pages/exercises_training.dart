import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:modile_app/api_service/training_service.dart';
import 'package:modile_app/models/exercise_model.dart';
import 'package:modile_app/models/training_model.dart';

import '../api_service/dynamic_info_service.dart';
import '../models/plan_model.dart';
import 'exercise.dart';

class ExerciseTraining extends StatefulWidget {
  /// slug тренировки
  late String slugTraining;

  late PlanModel planModel;

  ExerciseTraining({super.key,required this.slugTraining, required this.planModel});

  @override
  State<ExerciseTraining> createState() => _ExerciseTrainingState();
}

class _ExerciseTrainingState extends State<ExerciseTraining> {

  late Future<bool> isInitDone;
  late TrainingModel trainingModel;
  /// Для отслеживания
  bool boolValue = true;

  /// Список упражнений
  late List<ExerciseModel> listExercises = [];

  @override
  void initState() {
    isInitDone = fetchData();
    super.initState();
  }

  /// Заменить на запрос о тренировках в планах
  Future<bool> fetchData() async {
    try {
      trainingModel = (await TrainingService().getTraining(widget.planModel.slug, widget.slugTraining))!;
      listExercises.addAll(trainingModel.exercises);
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
    final titleTextStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontFamily: 'Montserrat',
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    final whiteSubtitleTextStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontFamily: 'Montserrat',
      fontSize: 20,
    );
    final blackTextStyle = theme.textTheme.displayMedium!.copyWith(
      fontFamily: 'Montserrat',
      fontSize: 14,
    ); final titleBlackTextStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    );

    final whiteColor = Theme
        .of(context)
        .colorScheme
        .onPrimary;
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: 300.0, // Ширина блока
                            height: 200.0, // Высота блока
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(widget.planModel.picture),
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
                                  padding: const EdgeInsets.only(bottom: 10.0, left: 10.0, top: 15.0),
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back, color: whiteColor,),
                                    iconSize: 40,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, left: 30.0),
                                  child: Text(
                                      '${trainingModel.number}-й день', textAlign: TextAlign.left,
                                      style: titleTextStyle),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 30.0, bottom: 20.0),
                                  child: Text(
                                      widget.planModel.name, textAlign: TextAlign.left,
                                      style: whiteSubtitleTextStyle),
                                ),
                              ],
                            ),),
                          Container(
                            constraints: BoxConstraints.expand(
                                height: MediaQuery.of(context).size.height * 0.68),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(8),
                                itemCount: listExercises.isEmpty ? 0 : listExercises
                                    .length,
                                itemBuilder: (BuildContext context, int index) {
                                  return
                                    Column(
                                      children: [
                                        ListTile(
                                          leading: Container(
                                              width: 50.0, // Ширина блока
                                              height: 50.0, // Высота блока
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(listExercises[index].picture),
                                                  fit: BoxFit.cover,
                                                ),
                                              )),
                                          title: Text(
                                              listExercises[index]
                                                  .name),
                                          subtitle: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                5),
                                            child:
                                            // Text(exercises[index].amount == 0 ? '${exercises[index].amount} подходов' : '${exercises[index].time} секунд',
                                            Text(listExercises[index].amount == null
                                                ? '${(listExercises[index]
                                                .time)!*(widget.planModel.intensity.index+1)} секунд'
                                                : '${(listExercises[index]
                                                .amount)!*(widget.planModel.intensity.index+1)} раз',
                                              style: blackTextStyle,),
                                          ),
                                        ),
                                        const Divider(
                                          height: 0,
                                        ),
                                      ],
                                    );
                                },
                              ),
                            ),
                          ),
                          const Divider(
                            height: 0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if(widget.planModel.iFollow){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Exercise(exercises: listExercises, intensity: widget.planModel.intensity, planModel: widget.planModel, trainingModel: trainingModel)),
                                  );
                                }else{
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        surfaceTintColor: whiteColor,
                                        title: Text('Внимание', style: titleBlackTextStyle,),
                                        content: const Text('Чтобы начать заниматься, вам необходимо начать отслеживать план'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Ок'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }

                              },

                              child: Text('Начать'),
                            ),
                          ),

                        ],
                      )
                  );
              }
            }
        )
    );
  }
}

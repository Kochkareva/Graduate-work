import 'package:flutter/material.dart';
import 'package:modile_app/pages/master.dart';

import 'index.dart';

class CompleteTraining extends StatefulWidget {

  late bool isSuccess;
  late int countExercises;

  CompleteTraining({super.key, required this.isSuccess, required this.countExercises});

  @override
  State<CompleteTraining> createState() => _CompleteTrainingState();
}

class _CompleteTrainingState extends State<CompleteTraining> {

  /// Результат тренировки
  late bool isSuccess;

  /// Кол-во выполненных упражнений
  late int countExercises;

  @override
  void initState() {
    isSuccess = widget.isSuccess;
    // isSuccess = false;
    countExercises = widget.countExercises;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 14,
      fontFamily: 'Montserrat',
    );
    final textSubtitleStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 16,
      fontFamily: 'Montserrat',
      // fontWeight: FontWeight.bold,
    );
    final textBoldStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 16,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
    );
    final titleText = theme.textTheme.displayMedium!.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    );
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .onPrimary,
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0, left: 30.0, right: 30.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Вы закончили!', style: titleText,),
            if(isSuccess)
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  'Вы прекрасно справились! Продолжайте в том же духе и вы добьетесь своих целей!',
                  style: textSubtitleStyle.copyWith(height: 1.7),
                  maxLines: 3,
                  textAlign: TextAlign.center,),
              ),
            if(!isSuccess)
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  'Вы хорошо справились, но вам нужно отдохнуть. Возвращайтесь к нам, когда вы будете чувствовать себя хорошо!',
                  style: textSubtitleStyle.copyWith(height: 1.7),
                  maxLines: 5,
                  textAlign: TextAlign.center,),
              ),
            Column(
              children: [
                Text('Результаты:', style: textBoldStyle,),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                            children: [
                              Text('Упражнений', style: textBoldStyle,),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(countExercises.toString(),
                                  style: textSubtitleStyle,),
                              ),
                            ]
                        ),
                        Column(
                          children: [
                            Text('Максимальное ЧСС', style: textBoldStyle,),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text('ЧСС', style: textSubtitleStyle,),
                            ),
                          ],
                        ),
                      ]
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.17,
                          child: Text('Совет:', style: textBoldStyle,)
                      ),
                      SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.65,
                        child: Text(
                          'Не забывайте пить достаточно воды во время тренировки!',
                          style: textStyle.copyWith(height: 1.5),
                          textAlign: TextAlign.justify,
                          maxLines: 5,),
                      ),
                    ]
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                          const Index(),
                          ));
                    },
                    child: const Text('Завершить'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

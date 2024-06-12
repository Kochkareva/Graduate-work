import 'package:flutter/material.dart';

import 'index.dart';

class EmergencyCompletionTraining extends StatefulWidget {
  const EmergencyCompletionTraining({super.key});

  @override
  State<EmergencyCompletionTraining> createState() => _EmergencyCompletionTrainingState();
}

class _EmergencyCompletionTrainingState extends State<EmergencyCompletionTraining> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final whiteColor = Theme
        .of(context)
        .colorScheme
        .onPrimary;
    final textStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 14,
      fontFamily: 'Montserrat',
      color: whiteColor
    );
    final textSubtitleStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 16,
      fontFamily: 'Montserrat',
        color: whiteColor
    );
    final textBoldStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 16,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
        color: whiteColor
    );
    final titleText = theme.textTheme.displayMedium!.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
        color: whiteColor
    );
    final redColor = Color(0xFFB22222);

    return Scaffold(
      backgroundColor: redColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0, left: 30.0, right: 30.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Нам пришлось прервать вашу активность!', style: titleText, textAlign: TextAlign.center,),

              Container(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15, right: 5, left: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: whiteColor, width: 3.0), // Цвет рамки (можно выбрать любой другой цвет)
                  borderRadius: BorderRadius.circular(10.0), // Закругление углов (необязательно)
                ),
                child: Text(
                  'Мы не уверены в вашем самочувствии и советуем обратиться к врачу за консультацией!',
                  style: textSubtitleStyle.copyWith(height: 1.7),
                  maxLines: 3,
                  textAlign: TextAlign.center,),
              ),

            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                'Мы будем ждать вас, когда вам станет лучше!',
                style: textSubtitleStyle.copyWith(height: 1.7),
                maxLines: 3,
                textAlign: TextAlign.center,),
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
                          'На плановый осмотр к врачу нужно ходить хотя бы раз в 6 месяцев!',
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
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, // Цвет фона кнопки
                      onPrimary: Colors.black, // Цвет текста на кнопке
                    ),
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

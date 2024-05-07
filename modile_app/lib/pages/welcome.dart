import 'package:flutter/material.dart';
import 'package:modile_app/pages/entry.dart';
import 'package:modile_app/pages/registration.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onPrimary,
      child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TextBlock(),
                const SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Registration()),
                    );
                  },
                  child: Text('Зарегистрироваться'),
                ),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: FooterBlock(),
                )
              ]
          )
      ),
    );
  }
}

class TextBlock extends StatelessWidget {
  const TextBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStandardStyle = theme.textTheme.displayMedium!.copyWith(
      fontFamily: 'Varta',
      fontWeight: FontWeight.bold,
      fontSize: 20,
    );
    final textSuperStyle = theme.textTheme.displayMedium!.copyWith(
      fontFamily: 'Ultra',
      color: theme.colorScheme.primary,
      fontSize: 20,
    );
    final textSmallStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.secondary,
      fontSize: 15,
    );

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Начните Ваши Тренировки С', style: textStandardStyle),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Traininarium', style: textSuperStyle,),
          ),
          Text('Сегодня', style: textStandardStyle),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 50, right: 50),
            child: Text('Ведите здоровый образ жизни, который позволит вам наслаждаться вашей жизнью', style: textSmallStyle, textAlign: TextAlign.center,),
          )
        ]
    );
  }
}

class FooterBlock extends StatelessWidget {
  const FooterBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textSmallStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.secondary,
      fontSize: 15,
    );

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('У вас уже есть аккаунт?', style: textSmallStyle,),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Entry()),
              );
            },
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),
            ),
            child: Text('Войти'),
          ),
        ]
    );
  }
}


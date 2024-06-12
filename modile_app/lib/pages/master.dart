import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modile_app/api_service/chart_service.dart';
import 'package:modile_app/api_service/dynamic_info_service.dart';
import 'package:modile_app/api_service/plan_service.dart';
import 'package:modile_app/contracts/enums/mood_enum.dart';
import 'package:modile_app/models/data_weight.dart';
import 'package:modile_app/models/dynamic_info_model.dart';
import 'package:modile_app/models/plan_model.dart';
import 'dart:ui' as ui;
import 'package:modile_app/storages/jwt_token_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/avg_data_heart_rate.dart';
import '../models/data_general_health.dart';
import '../models/data_sleep_time.dart';

class Master extends StatefulWidget {
  const Master({super.key});

  @override
  State<Master> createState() => _MasterState();
}

class _MasterState extends State<Master> {

  String userName = '';
  late double riskGroup;
  late Future<bool> isInitDone;
  late DynamicInfoModel dynamicInfoModel;
  bool isExpandedSleep = false;
  bool isExpandedMood = false;

  @override
  void initState() {
    isInitDone = fetchData();
    super.initState();
  }

  Future<bool> fetchData() async {
    try {
      var result = await DynamicInfoService().getDynamicInfo();
      riskGroup = result!.riskGroupKp;
      dynamicInfoModel = result;
      setState(() {
        userName = getJwtToken()!.username;
      });
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (error) {
      dev.log(error.toString());
      throw Exception(error.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  int currentSleepValue = 0;
  double currentMoodValue = 0.0;
  List<IconData> labelsMoodSlider = [
    Icons.mood_bad,   // соответствует значению Mood.poor
    Icons.sentiment_neutral,   // соответствует значению Mood.fair
    Icons.sentiment_satisfied,   // соответствует значению Mood.good
    Icons.sentiment_very_satisfied,   // соответствует значению Mood.veryGood
    Icons.mood,   // соответствует значению Mood.excellent
  ];

  Mood doubleToEnumMood(double value) {
    switch (value) {
      case 0.0:
        return Mood.Poor;
      case 1.0:
        return Mood.Fair;
      case 2.0:
        return Mood.Good;
      case 3.0:
        return Mood.VeryGood;
      case 4.0:
        return Mood.Excellent;
      default:
        return Mood.Poor;
    }
  }

  Future<void> createDynamicInfo() async {
    try {
      await DynamicInfoService().createDynamicInfo(dynamicInfoModel);
    } catch (e) {
      dev.log(e.toString());
      rethrow;
    }
  }

  // Обновление значения слайдера
  void updateSleepSlider(int value) {
    setState(() {
      currentSleepValue = value;
    });
  }

  // Обновление значения слайдера
  void updateMoodSlider(double value) {
    setState(() {
      currentMoodValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blackTitleStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 16,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
    );
    final textStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 20,
      color: theme.colorScheme.primary,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
    );
    final textWhiteStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 14,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
    );
    final textQuestStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 14,
      fontFamily: 'Montserrat',
    );
    final lightBlueColor = Color(0xFF748FFC);
    final lightPinkColor = Color(0xFFF27DA9);
    final textLightBlueStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 14,
      fontFamily: 'Montserrat',
      color: lightBlueColor,
      fontWeight: FontWeight.bold,
    );
    final blueColor = Theme
        .of(context)
        .colorScheme
        .primary;
    final aroundWhite = Color(0xFFF6F6F6);
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .onPrimary,
      body: FutureBuilder<bool>(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 35.0, left: 30.0),
                          child: Text(
                            'Добро пожаловать,', textAlign: TextAlign.left,
                            style: blackTitleStyle),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 30.0),
                          child: Text(
                              '$userName!', textAlign: TextAlign.left,
                              style: textStyle),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0, left: 30.0),
                          child: Text(
                            'Ваше здоровье',
                            textAlign: TextAlign.left,
                            style: blackTitleStyle),
                        ),
                        Container(
                            constraints: const BoxConstraints.expand(
                                height: 380.0),
                            child: BigCard(riskGroup: riskGroup, dynamicInfoModel: dynamicInfoModel,)),
                        SizedBox(
                          height: 180,
                          child: ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(left: 8, right: 8,),
                            children: <Widget>[
                              if (!isExpandedMood)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, right: 15.0, left: 15.0),
                                child: Card(
                                  surfaceTintColor: Theme
                                      .of(context)
                                      .colorScheme
                                      .onPrimary,
                                  elevation: 4.0,
                                  shadowColor: Theme
                                      .of(context)
                                      .colorScheme
                                      .primary,
                                  color: Theme
                                      .of(context)
                                      .colorScheme
                                      .onPrimary,
                                  // decoration: BoxDecoration(color: lightBlueColor), // Заливка цветом
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.nights_stay, color: lightBlueColor,),
                                        title: Text('Сколько часов вы сегодня спали?', style: textWhiteStyle,),
                                        onTap: () {
                                          setState(() {

                                            if(isExpandedSleep){
                                              setState(() {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
                                                      title: Text('Вопрос', style: blackTitleStyle,),
                                                      content: Text('Сохранить ответ?'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context)
                                                                .pop();
                                                          },
                                                          child: const Text('Нет'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            dynamicInfoModel.sleepTime = currentSleepValue;
                                                            createDynamicInfo();
                                                            Navigator.of(context)
                                                                .pop();
                                                          },
                                                          child: const Text('Да'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              });
                                            }
                                            isExpandedSleep = !isExpandedSleep; // Переключение состояния при нажатии
                                          });
                                        },

                                      ),
                                      if (isExpandedSleep)
                                        Container(
                                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                          color: Theme
                                              .of(context)
                                              .colorScheme
                                              .onPrimary,
                                          child: Slider(
                                            value: currentSleepValue.toDouble(),
                                            activeColor: lightBlueColor ,
                                            min: 0.0,
                                            max: 24.0,
                                            divisions: 24,
                                            label: currentSleepValue.toInt().toString(),
                                            onChanged: (double value) {
                                              updateSleepSlider(value.toInt());
                                            },
                                          ),
                                        ),
                                      if (isExpandedSleep)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0, bottom: 20, left: 30),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Время сна ', style: textQuestStyle,),
                                              Text(currentSleepValue.toInt().toString(), style: textLightBlueStyle),
                                              Text(' ч', style: textQuestStyle),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              if (!isExpandedSleep)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, right: 15.0, left: 15.0),
                                child: Card(
                                  surfaceTintColor: Theme
                                      .of(context)
                                      .colorScheme
                                      .onPrimary,
                                  elevation: 4.0,
                                  shadowColor: Theme
                                      .of(context)
                                      .colorScheme
                                      .primary,
                                  color: Theme
                                      .of(context)
                                      .colorScheme
                                      .onPrimary,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.emoji_emotions_outlined, color: lightPinkColor,),
                                        title: Text('Как ваше настроение сегодня?', style: textWhiteStyle,),
                                        // subtitle: Text('Дополнительные настройки'),
                                        onTap: () {
                                          setState(() {

                                            if (isExpandedMood){
                                              setState(() {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
                                                      title: Text('Вопрос', style: blackTitleStyle,),
                                                      content: Text('Сохранить ответ?'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context)
                                                                .pop();
                                                          },
                                                          child: const Text('Нет'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {

                                                            // dynamicInfoModel.generalHealth =doubleToEnumMood(currentMoodValue).name;
                                                            if(doubleToEnumMood(currentMoodValue).index < 1){

                                                              DateTime now = DateTime.now();
                                                              DateTime firstDayOfCurrentMonth = DateTime(now.year, now.month);

                                                              if (dynamicInfoModel.createdAt.isAfter(firstDayOfCurrentMonth)) {
                                                                dynamicInfoModel.mentalHealth++;
                                                              } else if (dynamicInfoModel.createdAt.isBefore(firstDayOfCurrentMonth)) {
                                                                dynamicInfoModel.mentalHealth = 1;
                                                              }

                                                            }

                                                            createDynamicInfo();

                                                            Navigator.of(context)
                                                                .pop();
                                                          },
                                                          child: const Text('Да'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              });
                                            }

                                            isExpandedMood = !isExpandedMood; // Переключение состояния при нажатии
                                          });
                                        },
                                      ),
                                      if (isExpandedMood)
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Icon(labelsMoodSlider[0], color: lightBlueColor,),
                                            Icon(labelsMoodSlider[2], color: lightBlueColor),
                                            Icon(labelsMoodSlider[4], color: lightBlueColor),
                                          ],
                                        ),
                                      if (isExpandedMood)
                                        Container(
                                          padding: const EdgeInsets.only(left: 35.0, right: 30.0),
                                          color: Theme
                                              .of(context)
                                              .colorScheme
                                              .onPrimary,
                                          child: Slider(
                                            value: currentMoodValue,
                                            activeColor: lightPinkColor ,
                                            min: 0.0,
                                            max: 4.0,
                                            divisions: 4,
                                            label: [
                                              'Плохое',
                                              'Нормальное',
                                              'Хорошее',
                                              'Очень хорошее',
                                              'Превосходное',
                                            ][currentMoodValue.toInt()],
                                            onChanged: (double value) {
                                              updateMoodSlider(value);
                                            },
                                          ),
                                        ),
                                      if (isExpandedMood)
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 60.0, bottom: 10, ),
                                              child: Icon(labelsMoodSlider[1], color: lightBlueColor),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 10, right: 50.0),
                                              child: Icon(labelsMoodSlider[3], color: lightBlueColor),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, left: 30.0, bottom: 10),
                          child: Text(
                            'Программы тренировок',
                            textAlign: TextAlign.left,
                            style: blackTitleStyle),
                        ),
                        const ListPlans(),
                      ]
                  ),
                );
            }
          }
      ),
    );
  }
}

class ListPlans extends StatefulWidget {
  const ListPlans({super.key});

  @override
  State<ListPlans> createState() => _ListPlansState();
}

class _ListPlansState extends State<ListPlans> {

  /// Список объектов типа PlanModel для работы с данными.
  List<PlanModel> listPlans = [];

  /// Список объектов типа PlanModel для подгружаемых данных.
  late Future<List<PlanModel>> future;
  /// Флаг, указывающий на то, что виджет все еще монтируется.
  bool _isMounted = false;

  @override
  void initState() {
    _isMounted = true;
    future = _getData();
    super.initState();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  /// Метод для подгрузки данных.
  ///
  /// [page] - текущая странница данных.
  Future<List<PlanModel>> _getData() async {
    try {
      listPlans += (await PlanService().getRecommendedPlans())!;
    } catch (e) {
      rethrow;
    }
    Future.delayed(const Duration(seconds: 1)).then((value) {
      if (_isMounted) {
        setState(() {});
      }
    });
    return listPlans;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme
          .of(context)
          .colorScheme
          .onPrimary,
      child: FutureBuilder<List<PlanModel>>(
          future: future,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.waiting:
                return _buildListViewProduct(listPlans);
              case ConnectionState.done:
                if (snapshot.hasError && !snapshot.error.toString().contains(
                    "Failed host lookup: 'pokeapi.co'")) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Произошла ошибка ${snapshot.error.toString()}'),
                        action: SnackBarAction(
                          label: 'Повторить',
                          onPressed: () {
                            setState(() {
                              future = _getData();
                            });
                          },
                        ),
                      ),
                    );
                  });
                }
                else if (snapshot.data != null) {
                  return _buildListViewProduct(listPlans);
                } else if (listPlans.isEmpty && snapshot.data == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Произошла ошибка ${snapshot.error.toString()}'),
                        action: SnackBarAction(
                          label: 'Повторить',
                          onPressed: () {
                            setState(() {
                              future = _getData();
                            });
                          },
                        ),
                      ),
                    );
                  });
                }
                else if (snapshot.data == null) {
                  return _buildListViewProduct(listPlans);
                }
            }
            return Scaffold(
              backgroundColor: Theme
                  .of(context)
                  .colorScheme
                  .onPrimary,
              body: const Center(),
            );
          }),
    );
  }

  /// Виджет для отрисовки списка данных.
  ///
  /// [listPlans] - список входных данных типа PlanModel для отрисовки.
  Widget _buildListViewProduct(List<PlanModel> listPlans) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 14,
      fontFamily: 'Montserrat',
    );
    final titleText = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    );
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: listPlans.isEmpty ? 0 : listPlans.length,
        itemBuilder: (BuildContext context, int index) {
          PlanModel data = listPlans[index];
          return
            ListTile(
              subtitle: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(listPlans[index].picture),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.4),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(listPlans[index].name, style: titleText.copyWith(height: 1.7), maxLines: 5,
                                overflow: TextOverflow.ellipsis,),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: List.generate(
                                  listPlans[index].intensity.index + 1,
                                      (index) =>  const Icon(Icons.flash_on,
                                      size: 17,
                                      color: Colors.white,
                                    ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 15, bottom: 15),
                        child: Row(
                          children: [
                            Text('Состоит из ${listPlans[index].trainingAmount} тренировок', style: textStyle),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            );
        },
      );
  }
}

class RiskGroupPainter extends CustomPainter{

  final double riskGroup;

  RiskGroupPainter(this.riskGroup);


  @override
  void paint(Canvas canvas, Size size) {
    size = const Size(60.0, 200.0);
    canvas.save();
    Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          // Colors.red,
          // Color(0xFFFF0000),
          // Colors.yellow,
          // Colors.green,
          Colors.white,
          Color(0xFF87CEEB),
          Color(0xFF3b5bdb),
        ],
        stops: [
          0.0, // Red color stop
          0.5, // Yellow color stop
          1.0, // Green color stop
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, 50, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, 50, size.height), paint);
    final Paint grayLinePaint = Paint();
    grayLinePaint.color = Colors.grey;
    grayLinePaint.strokeWidth = 1.0;

    canvas.drawLine(Offset(-10.0, size.height), Offset(size.width + 10, size.height), grayLinePaint);
    canvas.drawLine(Offset(-10.0, size.height), const Offset(-10, -10), grayLinePaint);

    canvas.drawLine(Offset(-10.0, size.height - riskGroup * 100 * 2 + 10), Offset(size.width - 5, size.height - riskGroup * 100 * 2 + 10), grayLinePaint);

    ui.ParagraphBuilder pb = ui.ParagraphBuilder(
        ui.ParagraphStyle(
          textAlign: TextAlign.left,
          fontSize: 12.0,

          // textDirection: TextDirection.ltr,
        ))
      ..pushStyle(ui.TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13,decoration: TextDecoration.underline,
        fontFamily: 'Montserrat',))
      ..addText('${(riskGroup * 100).toStringAsFixed(2)}%');
    ui.ParagraphConstraints pc = ui.ParagraphConstraints(width: size.width);
    ui.Paragraph paragraph = pb.build()..layout(pc);

    canvas.drawParagraph(paragraph, Offset(size.width, size.height - riskGroup * 100 * 2));
    canvas.restore();
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BigCard extends StatefulWidget {
  final double riskGroup;
  final DynamicInfoModel dynamicInfoModel;

  const BigCard({super.key, required this.riskGroup, required this.dynamicInfoModel});
  
  @override
  State<BigCard> createState() => _BigCardState();
}

class _BigCardState extends State<BigCard> with TickerProviderStateMixin{
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;
  late List<AvgDataHeartRate> avgDataHeartRate = [];
  late Future<bool> inittializeData;
  late double riskGroupValue;
  late List<DataSleepTime> dataTimeSleep = [];
  late List<DataWeight> dataWeight = [];
  late List<DataGeneralHealth> dataGeneralHealth = [];
  late DynamicInfoModel dynamicInfoModel;

  @override
  void initState() {
    inittializeData = getData();
    riskGroupValue = widget.riskGroup;
    dynamicInfoModel = widget.dynamicInfoModel;
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 6, vsync: this);
  }

  Future<bool> getData() async {
    try {
      avgDataHeartRate += (await ChartService().getAvgDataHeartRate());
      dataTimeSleep += (await ChartService().getDataSleepTime());
      dataWeight += (await ChartService().getDataWeight());
      dataGeneralHealth += (await ChartService().getDataGeneralHealth());
    } catch (e) {
      dev.log('Ошибка: $e');
      return false;
    }
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 13,
      fontFamily: 'Montserrat',
    );
    final blueTitleStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 16,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
    );
    final chartBottomAxisTitlesStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 12,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.primary,
    );

    final blackTitleStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 16,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
    );
    final blueColor = Theme
        .of(context)
        .colorScheme
        .primary;
    final lightBlueColor = Color(0xFF748FFC);
    final lightPinkColor = Color(0xFFF27DA9);
    List<FlSpot> spotsAvgDataHeartRate = avgDataHeartRate.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.heartRate!.toDouble());
    }).toList();

    List<FlSpot> spotsSleepTime = dataTimeSleep.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.sleepTime!.toDouble());
    }).toList();

    List<FlSpot> spotsWeight = dataWeight.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.weight);
    }).toList();

    List<FlSpot> spotsGeneralHealth = dataGeneralHealth.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.value.index.toDouble());
        }).toList();

    SideTitles _bottomTitlesAvgDataHeartRate() {
      return SideTitles(
        showTitles: true,
        interval: 1,
        getTitlesWidget: (value, meta) {
          var date = value.toInt() < avgDataHeartRate.length
              ? avgDataHeartRate[value.toInt()].date
              : "";
          return SideTitleWidget(axisSide: meta.axisSide, child: Text("$date", style: chartBottomAxisTitlesStyle,));
        },
      );
    }

    SideTitles _bottomTitlesSleepTime() {
      return SideTitles(
        showTitles: true,
        interval: 1,
        getTitlesWidget: (value, meta) {
          var date = value.toInt() < dataTimeSleep.length
              ? dataTimeSleep[value.toInt()].date
              : "";
          return SideTitleWidget(axisSide: meta.axisSide, child: Text("$date", style: chartBottomAxisTitlesStyle,));
        },
      );
    }

    SideTitles _bottomTitlesWeight() {
      return SideTitles(
        showTitles: true,
        interval: 1,
        getTitlesWidget: (value, meta) {
          var date = value.toInt() < dataWeight.length
              ? dataWeight[value.toInt()].date
              : "";
          return SideTitleWidget(axisSide: meta.axisSide, child: Text("$date", style: chartBottomAxisTitlesStyle,));
        },
      );
    }

    String convertValueToString(int value) {
      switch (value) {
        case 0:
          return "Плохое";
        case 1:
          return "Неплохое";
        case 2:
          return "Хорошее";
        case 3:
          return "Очень хорошее";
        case 4:
          return "Превосходное";
        default:
          return "";
      }
    }

    SideTitles _bottomTitlesGeneralHealth(){
      return SideTitles(
        showTitles: true,
        interval: 1,
        getTitlesWidget: (value, meta) {
          return SideTitleWidget(axisSide: meta.axisSide, child: Text("${convertValueToString(dataGeneralHealth[value.toInt()].value.index)}", style: chartBottomAxisTitlesStyle,));
        },
      );
    }

    SideTitles _rightTitlesGeneralHealth(){
      return SideTitles(
        showTitles: true,
        interval: 1,
        getTitlesWidget: (value, meta) {
          if (value % 1 == 0) {
            return SideTitleWidget(axisSide: meta.axisSide, child: Text(value.toInt().toString(), style: chartBottomAxisTitlesStyle,));
          } else {
            return SideTitleWidget(axisSide: meta.axisSide, child: Text("", style: chartBottomAxisTitlesStyle,));
          }
         },
      );
    }

    List<Color> colorsBarChart = [
      Color(0xFF3b5bdb),
      Color(0xFFF27DA9),
      Color(0xFFBAC8FF),
      Color(0xFFFFB2CF),
      Color(0xFF748FFC),
      // Additional colors for each mood
    ];

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
            body: PageView(
              controller: _pageViewController,
              onPageChanged: _handlePageViewChanged,
              children: <Widget>[
                //-------------------- Страница 1 -----------------------
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30.0, left: 30.0, right: 30.0, bottom: 40.0),
                  child: Card(
                    surfaceTintColor: Theme
                        .of(context)
                        .colorScheme
                        .onPrimary,
                    elevation: 4.0,
                    shadowColor: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onPrimary,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Ваша группа риска',
                            textAlign: TextAlign.left,
                            style: blueTitleStyle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0, left: 25.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                height: 200,
                                child: CustomPaint(
                                  painter: RiskGroupPainter(riskGroupValue),
                                  child: Container(
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Ваша группа риска ${(riskGroupValue *
                                            100)
                                            .round()}%, если хотите узнать больше об этом, перейдите на наш сайт.',
                                        textAlign: TextAlign.start,
                                        style: textStyle,
                                        maxLines: 5,
                                        // Set the maximum number of lines
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 8.0),
                                        child: Text(
                                          'Если вы хотите проверить свою группу риска еще раз, '
                                              'можете также зайти на наш сайт и пройти опрос заново.',
                                          textAlign: TextAlign.start,
                                          style: textStyle,
                                          maxLines: 5,
                                          // Set the maximum number of lines
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                      TextButton(
                                        onPressed: () {

                                        },
                                        child: Text('Перейти на сайт',
                                          style: textStyle.copyWith(
                                              color: theme.primaryColor),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //-------------------- Страница 2 -----------------------
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30.0, left: 30.0, right: 30.0, bottom: 40.0),
                  child: Card(
                    surfaceTintColor: Theme
                        .of(context)
                        .colorScheme
                        .onPrimary,
                    elevation: 4.0,
                    shadowColor: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onPrimary,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 17.0, bottom: 12),
                          child: SizedBox(
                            width: 220,
                            child: Text(
                              'Продолжительность сна',
                              textAlign: TextAlign.center,
                              style: blackTitleStyle,
                              maxLines: 2,
                              // Set the maximum number of lines
                              overflow: TextOverflow.ellipsis,),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 250,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            width: double.infinity,
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(show: true),
                                borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: _bottomTitlesSleepTime(),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                lineTouchData: LineTouchData(
                                  touchTooltipData: LineTouchTooltipData(
                                    showOnTopOfTheChartBoxArea: false,
                                    tooltipBgColor: Colors.white,
                                    tooltipBorder: BorderSide(
                                      color: blueColor,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: spotsSleepTime,
                                    isCurved: true,
                                    barWidth: 2,
                                    color: lightPinkColor,
                                    belowBarData: BarAreaData(show: true, color: lightPinkColor.withOpacity(0.2), ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //-------------------- Страница 3 -----------------------
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30.0, left: 30.0, right: 30.0, bottom: 40.0),
                  child: Card(
                    surfaceTintColor: Theme
                        .of(context)
                        .colorScheme
                        .onPrimary,
                    elevation: 4.0,
                    shadowColor: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onPrimary,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              'Среднее значение ЧСС в тренировках',
                              textAlign: TextAlign.center,
                              style: blackTitleStyle,
                              maxLines: 2,
                              // Set the maximum number of lines
                              overflow: TextOverflow.ellipsis,),
                          ),
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 250,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            width: double.infinity,
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(show: true),
                                borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: _bottomTitlesAvgDataHeartRate(),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                lineTouchData: LineTouchData(
                                  touchTooltipData: LineTouchTooltipData(
                                    showOnTopOfTheChartBoxArea: false,
                                    tooltipBgColor: Colors.white,
                                      tooltipBorder: BorderSide(
                                        color: blueColor,
                                        width: 1.0,
                                        style: BorderStyle.solid,
                                        ),
                                  ),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: spotsAvgDataHeartRate,
                                    isCurved: true,
                                    barWidth: 2,
                                    color: blueColor,
                                    belowBarData: BarAreaData(show: true, color: blueColor.withOpacity(0.2), ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //-------------------- Страница 4 -----------------------
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30.0, left: 30.0, right: 30.0, bottom: 40.0),
                  child: Card(
                    surfaceTintColor: Theme
                        .of(context)
                        .colorScheme
                        .onPrimary,
                    elevation: 4.0,
                    shadowColor: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onPrimary,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: SizedBox(
                            width: 220,
                            child: Text(
                              'Настроение в этом месяце',
                              textAlign: TextAlign.center,
                              style: blackTitleStyle,
                              maxLines: 2,
                              // Set the maximum number of lines
                              overflow: TextOverflow.ellipsis,),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 250,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            width: double.infinity,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 5,
                                centerSpaceRadius: 25,
                                sections: [
                                  PieChartSectionData(
                                    color: lightBlueColor.withOpacity(0.8),
                                    value: dynamicInfoModel.mentalHealth.toDouble(),
                                    title: 'Плохое\n    настроение\n${dynamicInfoModel.mentalHealth} д.',
                                    radius: 80,
                                    titleStyle: TextStyle(fontSize: 12,fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimary),
                                  ),
                                  PieChartSectionData(
                                    color: lightPinkColor.withOpacity(0.8),
                                    value: (30-dynamicInfoModel.mentalHealth.toDouble()),
                                    title: 'Хорошее\nнастроение\n${(30-dynamicInfoModel.mentalHealth)} д.',
                                    radius: 80,
                                    titleStyle: TextStyle(fontSize: 12,fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //-------------------- Страница 5 -----------------------
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30.0, left: 30.0, right: 30.0, bottom: 40.0),
                  child: Card(
                    surfaceTintColor: Theme
                        .of(context)
                        .colorScheme
                        .onPrimary,
                    elevation: 4.0,
                    shadowColor: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onPrimary,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 17.0, bottom: 12),
                          child: SizedBox(
                            width: 220,
                            child: Text(
                              'Вес',
                              textAlign: TextAlign.center,
                              style: blackTitleStyle,
                              maxLines: 2,
                              // Set the maximum number of lines
                              overflow: TextOverflow.ellipsis,),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 250,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            width: double.infinity,
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(show: true),
                                borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: _bottomTitlesWeight(),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                lineTouchData: LineTouchData(
                                  touchTooltipData: LineTouchTooltipData(
                                    showOnTopOfTheChartBoxArea: false,
                                    tooltipBgColor: Colors.white,
                                    tooltipBorder: BorderSide(
                                      color: blueColor,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: spotsWeight,
                                    isCurved: true,
                                    barWidth: 2,
                                    color: lightBlueColor,
                                    belowBarData: BarAreaData(show: true, color: lightBlueColor.withOpacity(0.2), ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //-------------------- Страница 6 -----------------------
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30.0, left: 30.0, right: 30.0, bottom: 40.0),
                  child: Card(
                    surfaceTintColor: Theme
                        .of(context)
                        .colorScheme
                        .onPrimary,
                    elevation: 4.0,
                    shadowColor: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onPrimary,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 17.0, bottom: 12),
                          child: SizedBox(
                            width: 220,
                            child: Text(
                              'Общее самочувствие',
                              textAlign: TextAlign.center,
                              style: blackTitleStyle,
                              maxLines: 2,
                              // Set the maximum number of lines
                              overflow: TextOverflow.ellipsis,),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 250,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            width: double.infinity,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                barTouchData: BarTouchData(enabled: false),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: _bottomTitlesGeneralHealth(),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: _rightTitlesGeneralHealth(),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  )
                                ),
                                borderData: FlBorderData(show: false),
                                barGroups: List.generate(spotsGeneralHealth.length, (index) {
                                  return BarChartGroupData(x: spotsGeneralHealth[index].x.toInt(), barRods: [
                                    BarChartRodData(fromY: 0, color: colorsBarChart[spotsGeneralHealth[index].x.toInt()], toY: spotsGeneralHealth[index].y),
                                  ]);
                                }),
                              ),
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

// class AvgDataBaseData {
//   double heartRate;
//   String date;
//
//   AvgDataBaseData({
//     required this.heartRate,
//     required this.date,
//   });
// }

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

    return Row(
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
            if (currentPageIndex == 5) {
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
    );
  }
}


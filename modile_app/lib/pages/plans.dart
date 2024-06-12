import 'package:flutter/material.dart';
import 'package:modile_app/api_service/plan_service.dart';
import 'package:modile_app/models/plan_model.dart';
import 'package:modile_app/pages/training_plan.dart';

class Plans extends StatefulWidget {
  const Plans({super.key});

  @override
  State<Plans> createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTitleStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 20,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
    );
    final textSubtitleStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 16,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .onPrimary,
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 35.0, left: 30.0, bottom: 20.0),
                child: Text(
                    'Планы тренировок', textAlign: TextAlign.left,
                    style: textTitleStyle),
              ),
              const ListPlansView(),
              const ListFollowedPlans(),
              const ListMyPlans(),
            ]
        ),
      ),
    );
  }
}

class ListMyPlans extends StatefulWidget {
  const ListMyPlans({super.key});

  @override
  State<ListMyPlans> createState() => _ListMyPlansState();
}

class _ListMyPlansState extends State<ListMyPlans> {

  /// Список объектов типа PlanModel для работы с данными.
  List<PlanModel> listPlans = [];

  /// Список объектов типа PlanModel для подгружаемых данных.
  late Future<List<PlanModel>> future;

  @override
  void initState() {
    future = getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Метод для подгрузки данных.
  Future<List<PlanModel>> getData() async {
    try {
      listPlans += (await PlanService().getMyPlans())!;
    } catch (e) {
      rethrow;
    }
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
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
                return _buildListFollowedPlan(listPlans);
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
                              future = getData();
                            });
                          },
                        ),
                      ),
                    );
                  });
                }
                else if (snapshot.data != null) {
                  return _buildListFollowedPlan(listPlans);
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
                              future = getData();
                            });
                          },
                        ),
                      ),
                    );
                  });
                }
                else if (snapshot.data == null) {
                  return _buildListFollowedPlan(listPlans);
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
  Widget _buildListFollowedPlan(List<PlanModel> listPlans) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 14,
      fontFamily: 'Montserrat',
    );
    final textSubtitleStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 16,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
    );
    final titleText = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    );
    String searchQuery = '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 30.0),
          child: Text(
              'Мои планы тренировок',
              textAlign: TextAlign.left,
              style: textSubtitleStyle),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          // Необходимо для правильного отображения ListView внутри SingleChildScrollView
          padding: const EdgeInsets.all(8),
          itemCount: listPlans.isEmpty ? 0 : listPlans.length,
          itemBuilder: (BuildContext context, int index) {
            return
              ListTile(
                subtitle: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
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
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(listPlans[index].name,
                                  style: titleText.copyWith(height: 1.7),
                                  maxLines: 5,
                                  // Set the maximum number of lines
                                  overflow: TextOverflow.ellipsis,),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  children: List.generate(
                                    listPlans[index].intensity.index + 1,
                                        (index) =>
                                    const Icon(Icons.flash_on,
                                      // Предполагается, что у ваших иконок есть IconData в списке listIcons
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
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 10),
                          child: Row(
                            children: [
                              Text('Состоит из ${listPlans[index]
                                  .trainingAmount} тренировок',
                                  style: textStyle),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 30, right: 30),
                          child: SizedBox(
                            width: 200, // set the width as needed
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TrainingPlan(
                                              slugPlan: listPlans[index]
                                                  .slug)),
                                );
                              },
                              child: const Text('Начать'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              );
          },
        ),
      ],
    );
  }
}


class ListFollowedPlans extends StatefulWidget {
  const ListFollowedPlans({super.key});

  @override
  State<ListFollowedPlans> createState() => _ListFollowedPlansState();
}

class _ListFollowedPlansState extends State<ListFollowedPlans> {

  /// Список объектов типа PlanModel для работы с данными.
  List<PlanModel> listPlans = [];

  /// Список объектов типа PlanModel для подгружаемых данных.
  late Future<List<PlanModel>> future;

  @override
  void initState() {
    future = getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Метод для подгрузки данных.
  Future<List<PlanModel>> getData() async {
    try {
      listPlans += (await PlanService().getFollowedPlans())!;
    } catch (e) {
      rethrow;
    }
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
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
                return _buildListFollowedPlan(listPlans);
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
                              future = getData();
                            });
                          },
                        ),
                      ),
                    );
                  });
                }
                else if (snapshot.data != null) {
                  return _buildListFollowedPlan(listPlans);
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
                              future = getData();
                            });
                          },
                        ),
                      ),
                    );
                  });
                }
                else if (snapshot.data == null) {
                  return _buildListFollowedPlan(listPlans);
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
  Widget _buildListFollowedPlan(List<PlanModel> listPlans) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 14,
      fontFamily: 'Montserrat',
    );
    final textSubtitleStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 16,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
    );
    final titleText = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    );
    String searchQuery = '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 30.0),
          child: Text(
              'Отслеживаемые планы тренировок',
              textAlign: TextAlign.left,
              style: textSubtitleStyle),
        ),
        ListView.builder(
          // physics: const AlwaysScrollableScrollPhysics(),
          physics: const NeverScrollableScrollPhysics(),
          // Отключаем прокрутку внутри ListView
          shrinkWrap: true,
          // Необходимо для правильного отображения ListView внутри SingleChildScrollView
          padding: const EdgeInsets.all(8),
          itemCount: listPlans.isEmpty ? 0 : listPlans.length,
          itemBuilder: (BuildContext context, int index) {
            return
              ListTile(
                subtitle: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
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
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(listPlans[index].name,
                                  style: titleText.copyWith(height: 1.7),
                                  maxLines: 5,
                                  // Set the maximum number of lines
                                  overflow: TextOverflow.ellipsis,),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  children: List.generate(
                                    listPlans[index].intensity.index + 1,
                                        (index) =>
                                    const Icon(Icons.flash_on,
                                      // Предполагается, что у ваших иконок есть IconData в списке listIcons
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
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 10),
                          child: Row(
                            children: [
                              Text('Состоит из ${listPlans[index]
                                  .trainingAmount} тренировок',
                                  style: textStyle),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 30, right: 30),
                          child: SizedBox(
                            width: 200, // set the width as needed
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TrainingPlan(
                                              slugPlan: listPlans[index]
                                                  .slug)),
                                );
                              },
                              child: const Text('Продолжить'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              );
          },
        ),
      ],
    );
  }
}


class ListPlansView extends StatefulWidget {
  const ListPlansView({super.key});

  @override
  State<ListPlansView> createState() => _ListPlansViewState();
}

class _ListPlansViewState extends State<ListPlansView> {
  /// Список объектов типа PlanModel для работы с данными.
  List<PlanModel> listPlans = [];
  List<PlanModel> savedPlans = [];
  /// Список объектов типа PlanModel для подгружаемых данных.
  late Future<List<PlanModel>> future;

  @override
  void initState() {
    future = _getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Метод для подгрузки данных.
  Future<List<PlanModel>> _getData() async {
    try {
      listPlans += (await PlanService().getRecommendedPlans())!;
      savedPlans.addAll(listPlans);
    } catch (e) {
      rethrow;
    }
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
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
    final textSubtitleStyle = theme.textTheme.displayMedium!.copyWith(
      fontSize: 16,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
    );
    final titleText = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    );
    String searchQuery = '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 30.0),
          child: Text(
              'Рекомендуемые планы тренировок',
              textAlign: TextAlign.left,
              style: textSubtitleStyle),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 20.0, left: 30, right: 30, bottom: 15.0),
          child:
          TextField(
            decoration: InputDecoration(
              labelText: 'Поиск',
              hintText: 'На руки',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0, horizontal: 20.0),
              labelStyle: const TextStyle(fontSize: 14),
              hintStyle: const TextStyle(fontSize: 14),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
                if (searchQuery == '') {
                  listPlans.clear();
                  listPlans.addAll(savedPlans);
                } else {
                  listPlans.clear();
                  listPlans.addAll(savedPlans);
                  List<PlanModel> searchResult = [];
                  searchResult.addAll(listPlans.where((food) =>
                      food.name.toLowerCase().contains(
                          searchQuery.toLowerCase()))
                      .toList());
                  listPlans.clear();
                  listPlans.addAll(searchResult);
                }
              });
            },
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: listPlans.isEmpty ? 0 : listPlans.length,
          itemBuilder: (BuildContext context, int index) {
            return
              ListTile(
                subtitle: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
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
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(listPlans[index].name,
                                  style: titleText.copyWith(height: 1.7),
                                  maxLines: 5,
                                  // Set the maximum number of lines
                                  overflow: TextOverflow.ellipsis,),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  children: List.generate(
                                    listPlans[index].intensity.index + 1,
                                        (index) =>
                                    const Icon(Icons.flash_on,
                                      // Предполагается, что у ваших иконок есть IconData в списке listIcons
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
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 10),
                          child: Row(
                            children: [
                              Text('Состоит из ${listPlans[index]
                                  .trainingAmount} тренировок',
                                  style: textStyle),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 30, right: 30),
                          child: SizedBox(
                            width: 200, // set the width as needed
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TrainingPlan(
                                              slugPlan: listPlans[index]
                                                  .slug)),
                                );
                              },
                              child: const Text('Начать'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              );
          },
        ),
      ],
    );
  }
}



import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:modile_app/api_service/state_info_service.dart';
import 'package:modile_app/models/dynamic_info_model.dart';
import 'package:modile_app/models/state_info_model.dart';

import '../api_service/dynamic_info_service.dart';
import 'index.dart';

class MedicalCard extends StatefulWidget {
  const MedicalCard({super.key});

  @override
  State<MedicalCard> createState() => _MedicalCardState();
}

class _MedicalCardState extends State<MedicalCard> {

  late StateInfoModel stateInfoModel;
  bool? isDiabetic;

  int? diabeticPeriod = 0;
  bool? isDiabeticWithDiseases;

  late Future<bool> isInitDone;
  bool updateMood = false;

  @override
  void initState() {
    isInitDone = fetchData();
    super.initState();
  }

  Future<bool> fetchData() async {
    try {
      var result = await StateInfoService().getStateInfo();
      stateInfoModel = result!;
      isDiabetic = stateInfoModel.isDiabetic;
      diabeticPeriod = stateInfoModel.diabeticPeriod;
      isDiabeticWithDiseases = stateInfoModel.isDiabeticWithDiseases;
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (error) {
      log(error.toString());
      throw Exception(error.toString());
    }
  }

  Future<void> updateStateInfo() async {
    try {
      if(!isDiabetic!){
        isDiabeticWithDiseases = false;
      }
      stateInfoModel = StateInfoModel(id: stateInfoModel.id,
          createdAt: stateInfoModel.createdAt,
          updatedAt: stateInfoModel.updatedAt,
          isHeartDiseased: stateInfoModel.isHeartDiseased,
          isDiabetic: isDiabetic!,
          isDiabeticWithDiseases: isDiabeticWithDiseases!,
          diabeticPeriod: diabeticPeriod!,
          isKidneyDiseased: stateInfoModel.isKidneyDiseased,
          isKidneyDiseaseChronic: stateInfoModel.isKidneyDiseaseChronic,
          isCholesterol: stateInfoModel.isCholesterol,
          isStroked: stateInfoModel.isStroked,
          height: stateInfoModel.height,
          isPhysicalActivity: stateInfoModel.isPhysicalActivity,
          isSmoker: stateInfoModel.isSmoker,
          isAlcoholic: stateInfoModel.isAlcoholic,
          isAsthmatic: stateInfoModel.isAsthmatic,
          isSkinCancer: stateInfoModel.isSkinCancer);
      await StateInfoService().updateDynamicInfo(stateInfoModel);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final whiteColor = Theme
        .of(context)
        .colorScheme
        .onPrimary;
    final blueColor = Theme
        .of(context)
        .colorScheme
        .primary;
    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;
    final lightBlueColor = Color(0xFFBAC8FF);
    final titleText = textTheme.displayMedium!.copyWith(
      // color: theme.colorScheme.onPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    );
    return Scaffold(
        backgroundColor: lightBlueColor,
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
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, top: 25.0),
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back, color: whiteColor,),
                                    iconSize: 40,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Index()),
                                      );
                                    },
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 100),
                                    child: Text(
                                      'Медицинская карта',
                                      style: titleText, softWrap: true, textAlign: TextAlign.center,),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                constraints: BoxConstraints.expand(
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.4),
                                height: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(70.0)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 5.0, top: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      if(!updateMood)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15.0, right: 25.0),
                                          child: Text(
                                              'Сахарный диабет ${stateInfoModel.isDiabetic ? 'есть' : 'отсутствует'}', style: textTheme.displayMedium!
                                              .copyWith(
                                              fontSize: 16
                                          )),
                                        ),
                                      if(updateMood)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0, right: 25.0),
                                        child: Text(
                                            'Сахарный диабет:', style: textTheme.displayMedium!
                                            .copyWith(
                                            fontSize: 14
                                        )),
                                      ),
                                      if(updateMood)
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
                                                                  enabled: updateMood,
                                                                  labelText: 'Количество лет ${stateInfoModel.diabeticPeriod.toString()}',
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
                                                                      'Наличие заболевания из списка ниже:',
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
                                                                      if(updateMood) {
                                                                        setState(() {
                                                                          isDiabeticWithDiseases =
                                                                          value!;
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        });
                                                                      }else{
                                                                        null;
                                                                      }
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
                                                                      if(updateMood) {
                                                                        setState(() {
                                                                          isDiabeticWithDiseases =
                                                                          value!;
                                                                          stateInfoModel.isDiabeticWithDiseases = isDiabeticWithDiseases!;
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        });
                                                                      }else{
                                                                        null;
                                                                      }
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                          ]);
                                                    });
                                                if(updateMood) {
                                                  setState(() {
                                                    isDiabetic = value!;
                                                  });
                                                }else{
                                                  null;
                                                }
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
                                                if(updateMood) {
                                                  setState(() {
                                                    isDiabetic = value!;
                                                    stateInfoModel.isDiabetic = isDiabetic!;
                                                    isDiabeticWithDiseases = null;
                                                    diabeticPeriod = 0;
                                                  });
                                                }else{
                                                  null;
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      if(stateInfoModel.isDiabetic && !updateMood)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 15, left: 15.0, right: 25.0),
                                          child: Text('Длительность сахарного диабета ${stateInfoModel.diabeticPeriod.toString()} лет.', style: textTheme.displayMedium!
                                              .copyWith(
                                              fontSize: 16
                                          )),
                                        ),
                                      if(stateInfoModel.isDiabeticWithDiseases && !updateMood)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 15, left: 15.0, right: 25.0),
                                          child: Text('Имеются заболевания, связанные с сахарным диабетом.', style: textTheme.displayMedium!
                                              .copyWith(
                                              fontSize: 16
                                          )),
                                        ),
                                      if(!updateMood)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 15, left: 15.0, right: 25.0),
                                          child: Text(
                                              'Рост ${stateInfoModel.height} см', style: textTheme.displayMedium!
                                              .copyWith(
                                              fontSize: 16
                                          )),
                                        ),
                                      if(updateMood)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10, left: 15.0, right: 25.0),
                                        child: Text(
                                            'Рост:', style: textTheme.displayMedium!
                                            .copyWith(
                                            fontSize: 14
                                        )),
                                      ),
                                      if(updateMood)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 25.0),
                                        child: TextField(
                                          enabled: updateMood,
                                          decoration: InputDecoration(
                                            labelText: 'Рост ${stateInfoModel.height} см',
                                            hintText: '163',
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

                                            stateInfoModel.height = int.parse(value);
                                          },
                                        ),
                                      ),

                                      if(updateMood)
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                updateMood = false;
                                              });
                                              updateStateInfo().then((result) {

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
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.white, // устанавливаем белый цвет фона
                                              onPrimary: blueColor, // устанавливаем синий цвет текста
                                              side: BorderSide(color: blueColor,
                                                  width: 2), // устанавливаем синюю рамку
                                            ),
                                            child: const Text('Сохранить'),
                                          ),
                                        ),
                                      ),
                                      if(!updateMood)
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 10.0),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  updateMood = true;
                                                });

                                              },
                                              child: const Text('Редактировать'),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]
                      )
                  );
              }
            }
        )
    );
  }
}

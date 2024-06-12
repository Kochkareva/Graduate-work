
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:modile_app/contracts/enums/intensity_enum.dart';
import 'package:modile_app/logic/regulator.dart';
import 'package:modile_app/logic/training_regulation.dart';
import 'package:modile_app/models/dynamic_info_model.dart';
import 'package:modile_app/models/exercise_model.dart';
import 'package:modile_app/models/plan_model.dart';
import 'package:modile_app/models/training_model.dart';
import 'package:modile_app/models/training_performance_model.dart';

void main() {
  group('Test - converts', () {

    test('Test DynamicInfoModel from json', () async {
      String jsonStr = '{"id": 6, "weight": 75.0, "physical_health": 2, "mental_health": 15, "sleep_time": 8, '
          '"created_at": "15.05.2024 15:54:13", "risk_group_kp": 0.42, "is_difficult_to_walk": false, '
          '"is_blood_pressure": false, "general_health": "Very good"}';
      var result = dynamicInfoModelFromJson(jsonStr);
      DynamicInfoModel dynamicInfoModel = DynamicInfoModel(id: 6,
          createdAt: DateTime(2024, 05, 15),
          riskGroupKp: 0.42,
          weight: 75.0,
          physicalHealth: 2,
          mentalHealth: 15,
          isDifficultToWalk: false,
          isBloodPressure: false,
          generalHealth: "Very good",
          sleepTime: 8);
      // bool equal = compareDynamicInfoModels(result, dynamicInfoModel);
      bool equal = result == dynamicInfoModel;
      expect(equal, true);
    });

    test('Test List ExerciseModel from json', () async {
      var jsonStr = ({"exercises": [
        {
          "slug": "prostaya-hodba",
          "name": utf8.encode("Простая ходьба"),
          "description": utf8.encode(""),
          "time": 60,
          "amount": null,
          "rest_time": 30,
          "picture": "http://192.168.68.104:8000/media/exercise/prostaya-hodba.png"
        },
        {
          "slug": "hodba-na-noskah",
          "name": utf8.encode("Ходьба на носках"),
          "description": utf8.encode("1. Начните с правильной постановки ног: Встаньте прямо, поднимите пятки, чтобы они не касались пола, и начните движение, опираясь только на носки ног."),
          "time": 60,
          "amount": null,
          "rest_time": 30,
          "picture": "http://192.168.68.104:8000/media/exercise/hodba-na-noskah.png"
        }
      ]});
      var result = listExerciseModelFromJson(jsonEncode(jsonStr['exercises']));
      List<ExerciseModel> listExercises = [
        ExerciseModel(slug: "prostaya-hodba",
            name: "Простая ходьба",
            description: "",
            time: 60,
            amount: null,
            restTime: 30,
            picture: "http://192.168.68.104:8000/media/exercise/prostaya-hodba.png"),
        ExerciseModel(slug: "hodba-na-noskah",
            name: "Ходьба на носках",
            description: "1. Начните с правильной постановки ног: Встаньте прямо, поднимите пятки, чтобы они не касались пола, и начните движение, опираясь только на носки ног.",
            time: 60,
            amount: null,
            restTime: 30,
            picture: "http://192.168.68.104:8000/media/exercise/hodba-na-noskah.png")
      ];
      bool equal = true;
      if (listExercises.length != result.length) equal = false;
      for (int i = 0; i < listExercises.length; i++) {
        if (listExercises[i] != result[i]) {
          equal = false;
          break;
        }
      }
      expect(equal, true);
    });

    test('Test RecommendedPlanModels from json', () async{
      var jsonStr = {
        "following": [],
        "recommended": [
          {
            "slug": "traininarium-podgotovitelnyij-plan-na-vsyo-telo-uproschyonnyij-i",
            "created_at": "15.05.2024 09:26:58",
            "name": utf8.encode("Подготовительный план на всё тело упрощённый I"),
            "picture": "http://192.168.68.104:8000/media/plan/traininarium-podgotovitelnyij-plan-na-vsyo-telo-uproschyonnyij-i.jpg",
            "intensity": "Low",
            "health_group": 2,
            "training_amount": 28,
            "is_filled": true,
            "equipment": ""
          },
          {
            "slug": "traininarium-podgotovitelnyij-plan-na-vsyo-telo-uproschyonnyij-ii",
            "created_at": "15.05.2024 09:26:58",
            "name": utf8.encode("Подготовительный план на всё тело упрощённый II"),
            "picture": "http://192.168.68.104:8000/media/plan/traininarium-podgotovitelnyij-plan-na-vsyo-telo-uproschyonnyij-ii.jpg",
            "intensity": "Medium",
            "health_group": 2,
            "training_amount": 28,
            "is_filled": true,
            "equipment": ""
          },
          {
            "slug": "traininarium-podgotovitelnyij-plan-na-vsyo-telo-uproschyonnyij-iii",
            "created_at": "15.05.2024 09:26:58",
            "name": utf8.encode("Подготовительный план на всё тело упрощённый III"),
            "picture": "http://192.168.68.104:8000/media/plan/traininarium-podgotovitelnyij-plan-na-vsyo-telo-uproschyonnyij-iii.jpg",
            "intensity": "High",
            "health_group": 2,
            "training_amount": 28,
            "is_filled": true,
            "equipment": ""
          }
        ],
        "my": [],
        "other": [
          {
            "slug": "traininarium-podgotovitelnyij-plan-na-vsyo-telo-i",
            "created_at": "15.05.2024 09:26:58",
            "name": "Подготовительный план на всё тело I",
            "picture": "http://192.168.68.104:8000/media/plan/traininarium-podgotovitelnyij-plan-na-vsyo-telo-i.jpg",
            "intensity": "Low",
            "health_group": 1,
            "training_amount": 28,
            "is_filled": true,
            "equipment": "",
            "enabled": false
          },
          {
            "slug": "traininarium-podgotovitelnyij-plan-na-vsyo-telo-ii",
            "created_at": "15.05.2024 09:26:58",
            "name": "Подготовительный план на всё тело II",
            "picture": "http://192.168.68.104:8000/media/plan/traininarium-podgotovitelnyij-plan-na-vsyo-telo-ii.jpg",
            "intensity": "Medium",
            "health_group": 1,
            "training_amount": 28,
            "is_filled": true,
            "equipment": "",
            "enabled": false
          },
          {
            "slug": "traininarium-podgotovitelnyij-plan-na-vsyo-telo-iii",
            "created_at": "15.05.2024 09:26:58",
            "name": "Подготовительный план на всё тело III",
            "picture": "http://192.168.68.104:8000/media/plan/traininarium-podgotovitelnyij-plan-na-vsyo-telo-iii.jpg",
            "intensity": "High",
            "health_group": 1,
            "training_amount": 28,
            "is_filled": true,
            "equipment": "",
            "enabled": false
          }
        ]
      };
      var result = listRecommendedPlanModelFromJson(jsonEncode(jsonStr));
      List<PlanModel> listRecommendedPlans = [
        PlanModel(slug: "traininarium-podgotovitelnyij-plan-na-vsyo-telo-uproschyonnyij-i",
            name: "Подготовительный план на всё тело упрощённый I",
            picture: "http://192.168.68.104:8000/media/plan/traininarium-podgotovitelnyij-plan-na-vsyo-telo-uproschyonnyij-i.jpg",
            intensity: Intensity.Low,
            healthGroup: 2,
            trainingAmount: 28,
            isFilled: true,
            equipment: "",
            iFollow: true),
        PlanModel(slug: "traininarium-podgotovitelnyij-plan-na-vsyo-telo-uproschyonnyij-ii",
            name: "Подготовительный план на всё тело упрощённый II",
            picture: "http://192.168.68.104:8000/media/plan/traininarium-podgotovitelnyij-plan-na-vsyo-telo-uproschyonnyij-ii.jpg",
            intensity: Intensity.Medium,
            healthGroup: 2,
            trainingAmount: 28,
            isFilled: true, equipment: "",
            iFollow: true),
        PlanModel(slug: "traininarium-podgotovitelnyij-plan-na-vsyo-telo-uproschyonnyij-iii",
            name: "Подготовительный план на всё тело упрощённый III",
            picture: "http://192.168.68.104:8000/media/plan/traininarium-podgotovitelnyij-plan-na-vsyo-telo-uproschyonnyij-iii.jpg",
            intensity: Intensity.High,
            healthGroup: 2,
            trainingAmount: 28,
            isFilled: true,
            equipment: "",
            iFollow: true)
      ];
      bool equal = true;
      if (listRecommendedPlans.length != result.length) equal = false;
      for (int i = 0; i < listRecommendedPlans.length; i++) {
        if (listRecommendedPlans[i] != result[i]) {
          equal = false;
          break;
        }
      }
      expect(equal, true);
    });

    test('Test TrainingModel from json', () async{
      var jsonStr = {
        "name": "Тренировка 2",
        "number": 2,
        "exercises": [
          {
            "slug": "prostaya-hodba",
            "name": utf8.encode("Простая ходьба"),
            "description": utf8.encode(""),
            "time": 60,
            "amount": null,
            "rest_time": 30,
            "picture": "http://192.168.68.104:8000/media/exercise/prostaya-hodba.png"
          },
          {
            "slug": "hodba-na-noskah",
            "name": utf8.encode("Ходьба на носках"),
            "description": utf8.encode("1. Начните с правильной постановки ног: Встаньте прямо, поднимите пятки, чтобы они не касались пола, и начните движение, опираясь только на носки ног."),
            "time": 60,
            "amount": null,
            "rest_time": 30,
            "picture": "http://192.168.68.104:8000/media/exercise/hodba-na-noskah.png"
          }]
      };
      var result = trainingModelFromJson(jsonEncode(jsonStr));
      TrainingModel training = TrainingModel(name: "Тренировка 2", number: 2, slug: 'training-2', exercises: [
        ExerciseModel(slug: "prostaya-hodba",
            name: "Простая ходьба",
            description: "",
            time: 60,
            amount: null,
            restTime: 30,
            picture: "http://192.168.68.104:8000/media/exercise/prostaya-hodba.png"),
        ExerciseModel(slug: "hodba-na-noskah",
            name: "Ходьба на носках",
            description: "1. Начните с правильной постановки ног: Встаньте прямо, поднимите пятки, чтобы они не касались пола, и начните движение, опираясь только на носки ног.",
            time: 60,
            amount: null,
            restTime: 30,
            picture: "http://192.168.68.104:8000/media/exercise/hodba-na-noskah.png")
      ]);
      bool equal = result == training;
      expect(equal, true);
    });

    test('Test TrainingPerformanceModel from json', () async{
      var jsonStr = [
        {
          "id": 7,
          "user_id": 5,
          "training_id": 85,
          "slug": "lizaveta-traininarium-podgotovitelnyij-plan-na-vsyo-telo-uproschyonnyij-i-training-1",
          "created_at": "16.05.2024 08:49:22",
          "pulse": [
            93.0
          ],
          "mid_fatigue": false,
          "short_breath": false,
          "heart_ace": false,
          "training_risk_g": 0.5
        },
        {
          "id": 8,
          "user_id": 5,
          "training_id": 86,
          "slug": "lizaveta-traininarium-podgotovitelnyij-plan-na-vsyo-telo-uproschyonnyij-i-training-2",
          "created_at": "16.05.2024 08:52:27",
          "pulse": [
            76.0
          ],
          "mid_fatigue": false,
          "short_breath": false,
          "heart_ace": false,
          "training_risk_g": 0.5
        }
      ];
      
      var result = trainingPerformanceModelFromJson(jsonEncode(jsonStr));
      List<TrainingPerformanceModel> listTrainingPerformances = [
        TrainingPerformanceModel(slug: "lizaveta-traininarium-podgotovitelnyij-plan-na-vsyo-telo-uproschyonnyij-i-training-1",
            pulse: [
              93.0
            ], midFatigue: false, shortBreath: false, heartAce: false, trainingRiskG: 0.5, createdAt: DateTime.now()),
        TrainingPerformanceModel(slug: "lizaveta-traininarium-podgotovitelnyij-plan-na-vsyo-telo-uproschyonnyij-i-training-2",
            pulse: [
              76.0
            ], midFatigue: false, shortBreath: false, heartAce: false, trainingRiskG: 0.5, createdAt: DateTime.now())
      ];

      bool equal = true;
      if (listTrainingPerformances.length != result.length) equal = false;
      for (int i = 0; i < listTrainingPerformances.length; i++) {
        if (listTrainingPerformances[i] != result[i]) {
          equal = false;
          break;
        }
      }
      expect(equal, true);
    });
  });

  group('Test - regulator', () {

    test('Test Regulartor: riskGroup = 0.1 and rate appeals = 23', () async{
      double riskGroup = 0.1;
      Regulator currentRegulator = Regulator(restTime: 30, intensity: 1, workoutMonitor: 0);
      int countCheckUp = 0;
      while(currentRegulator.intensity != 0 && currentRegulator.restTime != 0){
        currentRegulator = TrainingRegulation(riskGroup: riskGroup).regulator(currentRegulator);
        countCheckUp++;
      }
      print('Для группы риска = $riskGroup, количество проверок: $countCheckUp');
      expect(countCheckUp, 23);
    });

    test('Test Regulartor: riskGroup = 0.2 and rate appeals = 10', () async{
      double riskGroup = 0.2;
      Regulator currentRegulator = Regulator(restTime: 30, intensity: 1, workoutMonitor: 0);
      int countCheckUp = 0;
      while(currentRegulator.intensity != 0 && currentRegulator.restTime != 0){
        currentRegulator = TrainingRegulation(riskGroup: riskGroup).regulator(currentRegulator);
        countCheckUp++;
      }
      print('Для группы риска = $riskGroup, количество проверок: $countCheckUp');
      expect(countCheckUp, 10);
    });

    test('Test Regulartor: riskGroup = 0.4 and rate appeals = 4', () async{
      double riskGroup = 0.4;
      Regulator currentRegulator = Regulator(restTime: 30, intensity: 1, workoutMonitor: 0);
      int countCheckUp = 0;
      while(currentRegulator.intensity != 0 && currentRegulator.restTime != 0){
        currentRegulator = TrainingRegulation(riskGroup: riskGroup).regulator(currentRegulator);
        countCheckUp++;
      }
      print('Для группы риска = $riskGroup, количество проверок: $countCheckUp');
      expect(countCheckUp, 4);
    });

    test('Test Regulartor: riskGroup = 0.6 and rate appeals = 2', () async{
      double riskGroup = 0.6;
      Regulator currentRegulator = Regulator(restTime: 30, intensity: 1, workoutMonitor: 0);
      int countCheckUp = 0;
      while(currentRegulator.intensity != 0 && currentRegulator.restTime != 0){
        currentRegulator = TrainingRegulation(riskGroup: riskGroup).regulator(currentRegulator);
        countCheckUp++;
      }
      print('Для группы риска = $riskGroup, количество проверок: $countCheckUp');
      expect(countCheckUp, 2);
    });

    test('Test Regulartor: riskGroup = 0.8 and rate appeals = 1', () async{
      double riskGroup = 0.8;
      Regulator currentRegulator = Regulator(restTime: 30, intensity: 1, workoutMonitor: 0);
      int countCheckUp = 0;
      while(currentRegulator.intensity != 0 && currentRegulator.restTime != 0){
        currentRegulator = TrainingRegulation(riskGroup: riskGroup).regulator(currentRegulator);
        countCheckUp++;
      }
      print('Для группы риска = $riskGroup, количество проверок: $countCheckUp');
      expect(countCheckUp, 1);
    });

  });
}
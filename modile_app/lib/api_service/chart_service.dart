
import 'package:intl/intl.dart';
import 'package:modile_app/api_service/dynamic_info_service.dart';
import 'package:modile_app/api_service/plan_service.dart';
import 'package:modile_app/api_service/training_service.dart';
import 'package:modile_app/models/data_sleep_time.dart';
import 'package:modile_app/models/dynamic_info_model.dart';

import '../contracts/enums/mood_enum.dart';
import '../models/avg_data_heart_rate.dart';
import '../models/data_general_health.dart';
import '../models/data_weight.dart';
import '../models/plan_model.dart';
import '../models/training_performance_model.dart';

class ChartService {

  Future<List<AvgDataHeartRate>> getAvgDataHeartRate() async {
    List<AvgDataHeartRate> avgData = [];
    List<PlanModel>? listFollowedPlans = await PlanService().getFollowedPlans();
    List<TrainingPerformanceModel>? listTrainingPerformance;
    if (listFollowedPlans != null) {
      for (PlanModel plan in listFollowedPlans) {
        listTrainingPerformance = await TrainingService().getTrainingPerformanceByPlan(plan.slug);
        if (listTrainingPerformance != null) {
          for (TrainingPerformanceModel performance in listTrainingPerformance) {
            avgData.add(AvgDataHeartRate(
                heartRate: performance.pulse.reduce((value, element) => value + element) / performance.pulse.length,
                date: DateFormat("dd.MM").format(performance.createdAt)));
          }
        }
      }
      if(avgData.isNotEmpty && avgData.length > 6){
        avgData = avgData.sublist(avgData.length - 6);
      }else{
        return avgData;
      }
    } else {
      avgData.add(AvgDataHeartRate(heartRate: 0, date: ""));
    }
    return avgData;
  }

  Future<List<DataSleepTime>> getDataSleepTime() async {
    List<DataSleepTime> sleepTimeData = [];
    List<DynamicInfoModel>? listDynamicInfo = await DynamicInfoService().getDynamicInfoList();
    if(listDynamicInfo!=null){
      for(DynamicInfoModel info in listDynamicInfo){
        sleepTimeData.add(DataSleepTime(sleepTime: info.sleepTime, date: DateFormat("dd.MM").format(info.createdAt)));
      }
      sleepTimeData.sort((a, b) =>
          DateFormat("dd.MM").parse(a.date).compareTo(DateFormat("dd.MM").parse(b.date)));
      Set<String> uniqueDates = {};
      sleepTimeData.removeWhere((element) => !uniqueDates.add(element.date));
      if(sleepTimeData.isNotEmpty && sleepTimeData.length > 6){
        sleepTimeData = sleepTimeData.sublist(sleepTimeData.length - 6);
      }else{
        return sleepTimeData;
      }
    }
    return sleepTimeData;
  }

  Future<List<DataWeight>> getDataWeight() async {
    List<DataWeight> weightData = [];
    List<DynamicInfoModel>? listDynamicInfo = await DynamicInfoService().getDynamicInfoList();
    if(listDynamicInfo!=null){
      for(DynamicInfoModel info in listDynamicInfo){
        weightData.add(DataWeight(weight: info.weight, date: DateFormat("dd.MM").format(info.createdAt)));
      }
      weightData.sort((a, b) =>
          DateFormat("dd.MM").parse(a.date).compareTo(DateFormat("dd.MM").parse(b.date)));
      Set<double> uniqueDates = {};
      weightData.removeWhere((element) => !uniqueDates.add(element.weight));
      if(weightData.isNotEmpty && weightData.length > 6){
        weightData = weightData.sublist(weightData.length - 6);
      }else{
        return weightData;
      }
    }
    return weightData;
  }

  Mood moodFromString(String moodString) {
    switch (moodString) {
      case 'Poor':
        return Mood.Poor;
      case 'Fair':
        return Mood.Fair;
      case 'Good':
        return Mood.Good;
      case 'VeryGood':
        return Mood.VeryGood;
      case 'Excellent':
        return Mood.Excellent;
      default:
        throw Exception('Не удалось преобразовать строку в Mood: $moodString');
    }
  }

  Future<List<DataGeneralHealth>> getDataGeneralHealth() async{
    List<DataGeneralHealth> generalHealth = [];
    List<DynamicInfoModel>? listDynamicInfo = await DynamicInfoService().getDynamicInfoList();
    if(listDynamicInfo != null){
      for(DynamicInfoModel info in listDynamicInfo){
        generalHealth.add(DataGeneralHealth(value: moodFromString(info.generalHealth), date:  DateFormat("dd.MM").format(info.createdAt)));
      }
      generalHealth.sort((a, b) =>
          DateFormat("dd.MM").parse(a.date).compareTo(DateFormat("dd.MM").parse(b.date)));
      Set<Mood> uniqueDates = {};
      generalHealth.removeWhere((element) => !uniqueDates.add(element.value));
      if(generalHealth.isNotEmpty && generalHealth.length > 6){
        generalHealth = generalHealth.sublist(generalHealth.length - 6);
      }else{
        return generalHealth;
      }
    }
    return generalHealth;
  }

}
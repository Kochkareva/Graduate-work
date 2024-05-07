class Regulator {
  int restTime;
  double intensity;
  /// Монитор тренировки (А)
  double workoutMonitor;

  Regulator({
    required this.restTime,
    required this.intensity,
    required this.workoutMonitor
  });
}
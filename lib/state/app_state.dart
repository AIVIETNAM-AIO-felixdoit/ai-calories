import 'package:flutter/widgets.dart';

enum Goal { lose, gain, healthy }

class GoalPlan {
  const GoalPlan({
    required this.kcal,
    required this.targetWeight,
    required this.targetDuration,
    required this.goalNote,
    required this.planWeight,
    required this.planDuration,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.planNote,
  });

  final int kcal;
  final String targetWeight;
  final String targetDuration;
  final String goalNote;
  final String planWeight;
  final String planDuration;
  final int protein;
  final int carbs;
  final int fat;
  final String planNote;
}

const goalPlans = <Goal, GoalPlan>{
  Goal.lose: GoalPlan(
    kcal: 2100,
    targetWeight: '68 kg  ·  giảm 4 kg',
    targetDuration: '12 tuần',
    goalNote: 'Khoảng 0,3 kg/tuần • Có thể điều chỉnh sau.',
    planWeight: '72 kg → 68 kg',
    planDuration: '12 tuần',
    protein: 130,
    carbs: 260,
    fat: 60,
    planNote: 'Ước tính ban đầu, không phải cam kết giảm cân. '
        'Điều chỉnh theo tiến độ và hướng dẫn của PT.',
  ),
  Goal.gain: GoalPlan(
    kcal: 2650,
    targetWeight: '76 kg · tăng 4 kg',
    targetDuration: '12 tuần',
    goalNote: 'Theo dõi xu hướng cân nặng mỗi tuần.',
    planWeight: '72 kg → 76 kg',
    planDuration: '12 tuần',
    protein: 150,
    carbs: 310,
    fat: 90,
    planNote: 'Ước tính ban đầu. Điều chỉnh theo tiến độ và hướng dẫn của PT.',
  ),
  Goal.healthy: GoalPlan(
    kcal: 2450,
    targetWeight: '72 kg · duy trì cân nặng',
    targetDuration: '12 tuần',
    goalNote: 'Ưu tiên sự đều đặn và chất lượng bữa ăn.',
    planWeight: 'Duy trì khoảng 72 kg',
    planDuration: '4 tuần thói quen',
    protein: 140,
    carbs: 270,
    fat: 90,
    planNote: 'Ước tính ban đầu. Điều chỉnh theo tiến độ và hướng dẫn của PT.',
  ),
};

class WaterEntry {
  const WaterEntry(this.time, this.ml, {this.justAdded = false});

  final String time;
  final int ml;
  final bool justAdded;
}

class RunRecord {
  const RunRecord(this.label, this.km, this.minutes, this.pace, this.kcal);

  final String label;
  final String km;
  final int minutes;
  final String pace;
  final int kcal;
}

/// Trạng thái demo của cả app, giữ trong bộ nhớ.
class AppState extends ChangeNotifier {
  static const breakfastKcal = 600;
  static const lunchKcal = 650;
  static const waterGoal = 2000;
  static const _otherActivityKcal = 80;

  Goal goal = Goal.lose;
  int currentTab = 0;
  bool lunchSaved = false;
  bool articleSaved = false;
  bool ptInvited = false;

  final List<WaterEntry> waterEntries = [
    const WaterEntry('07:00', 250),
    const WaterEntry('09:30', 500),
    const WaterEntry('12:00', 500),
  ];

  final List<RunRecord> runs = [
    const RunRecord('Hôm nay · 06:30', '3,2 km', 24, '7:30/km', 240),
  ];

  GoalPlan get plan => goalPlans[goal]!;
  int get consumed => breakfastKcal + (lunchSaved ? lunchKcal : 0);
  int get remaining => plan.kcal - consumed;
  int get waterMl => waterEntries.fold(0, (sum, e) => sum + e.ml);
  int get activityKcal =>
      _otherActivityKcal + runs.fold(0, (sum, r) => sum + r.kcal);
  int get activityMinutes => 18 + runs.fold(0, (sum, r) => sum + r.minutes);

  void selectTab(int index) {
    currentTab = index;
    notifyListeners();
  }

  void setGoal(Goal value) {
    goal = value;
    notifyListeners();
  }

  void saveLunch() {
    lunchSaved = true;
    notifyListeners();
  }

  void addWater([int ml = 250]) {
    final now = DateTime.now();
    final time = '${_two(now.hour)}:${_two(now.minute)}';
    for (var i = 0; i < waterEntries.length; i++) {
      final e = waterEntries[i];
      if (e.justAdded) waterEntries[i] = WaterEntry(e.time, e.ml);
    }
    waterEntries.add(WaterEntry(time, ml, justAdded: true));
    notifyListeners();
  }

  void undoLastWater() {
    if (waterEntries.isNotEmpty && waterEntries.last.justAdded) {
      waterEntries.removeLast();
      notifyListeners();
    }
  }

  void addRun(RunRecord run) {
    runs.insert(0, run);
    notifyListeners();
  }

  void setArticleSaved(bool value) {
    articleSaved = value;
    notifyListeners();
  }

  void setPtInvited(bool value) {
    ptInvited = value;
    notifyListeners();
  }

  static String _two(int v) => v.toString().padLeft(2, '0');
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;

  /// Dùng trong callback, không đăng ký rebuild.
  static AppState read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AppScope>()!.notifier!;
}

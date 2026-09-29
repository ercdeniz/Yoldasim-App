import 'package:isar/isar.dart';

part 'activity_record.g.dart';

@collection
class ActivityRecord {
  Id id = Isar.autoIncrement;

  // Hangi aktiviteye (kaza namazına, oruca vs.) ait olduğu
  @Index()
  late int activityId;

  // Hangi güne ait olduğu (Saat ve dakikası 00:00:00 olacak şekilde kaydedeceğiz)
  @Index()
  late DateTime date;

  // O gün o görevden kaç tane yapıldı (Senin aradığın dailyDone)
  int doneCount = 0;
}
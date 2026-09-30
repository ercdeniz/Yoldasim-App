import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yoldasim_app/data/models/activity_model.dart';
import 'package:yoldasim_app/data/models/activity_record.dart';

class IsarService extends GetxService {
  late Isar db;

  Future init() async {
    final dir = await getApplicationDocumentsDirectory();
    db = await Isar.open([
      ActivityModelSchema,
      ActivityRecordSchema,
    ], directory: dir.path);
    return this;
  }

  // --- KAYIT EKLEME / GÜNCELLEME (UPSERT) ---
  Future saveActivity(ActivityModel activity) async {
    activity.updatedAt = DateTime.now();
    await db.writeTxn(() async {
      await db.activityModels.put(activity);
    });
  }

  Future deleteActivity(int activityId) async {
    await db.writeTxn(() async {
      await db.activityModels.delete(activityId);
      await db.activityRecords
          .filter()
          .activityIdEqualTo(activityId)
          .deleteAll();
    });
  }

  // --- LİSTELEME (CANLI AKIŞ) ---
  Stream<List<ActivityModel>> listenToActivities() {
    return db.activityModels.where().watch(fireImmediately: true);
  }
}

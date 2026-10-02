import 'package:isar/isar.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';

part 'activity_model.g.dart';

@collection
class ActivityModel {
  Id id = Isar.autoIncrement;

  late String title;

  @enumerated
  late ActivityType type;

  // HEDEF PERİYODU: Günlük, Haftalık, Aylık
  @enumerated
  ActivityPeriod period = ActivityPeriod.daily;

  @enumerated
  TargetCondition targetCondition = TargetCondition.atLeast;

  // true: Planlı günlerde tamamlanması zorunludur ve genel yüzdeye dahil edilir.
  // false: Planlı günlerde isteğe bağlıdır; yapılmadığında başarısız sayılmaz.
  bool isMandatory = false;

  // Tüm aktivite türleri için hızlı erişilen toplam ilerleme cache'i.
  int totalDone = 0;

  // Her aktivite bir plan taşır; günlük aktivitelerde listeler boş kalır.
  ActivitySchedule schedule = ActivitySchedule();

  // --- ZAMAN DAMGASI ---
  DateTime startDate = DateTime.now();
  DateTime updatedAt = DateTime.now();

  // --- GÖMÜLÜ ÖZEL DETAYLAR ---
  SalahDetails? salahDetails;
  FastingDetails? fastingDetails;
  DhikrDetails? dhikrDetails;
  QuranDetails? quranDetails;
}

// --- EMBEDDED SINIFLAR ---
@embedded
class SalahDetails {
  @enumerated
  SalahTime salahTime = SalahTime.fajr; // fajr, dhuhr, asr, maghrib, isha, witr

  int totalDebt = 0; // Toplam borç (Örn: 300 vakit)
  int dailyTarget = 0; // Günlük eritme hedefi

  @enumerated
  TargetCondition targetCondition = TargetCondition.atLeast; // Hedef koşulu (En az, Tam, En fazla)
}

@embedded
class FastingDetails {
  int totalDebt = 0; // Toplam tutulması gereken gün
}

@embedded
class DhikrDetails {
  int targetCount = 0; // Çekilecek zikir sayısı
  String arabicText = ''; // Arapça metin
  String? turkishText; // Türkçe okunuşu veya anlamı
}

@embedded
class QuranDetails {
  @enumerated
  QuranTargetType targetType = QuranTargetType.page; // page (sayfa), juz (cüz), surah (sure)
  int targetValue = 0; // Örn: 5 (sayfa), 1 (cüz), 1 (sure)
  List<int> selectedJuzNumbers = []; // Seçilen cüzlerin numaraları (1..30)
  int selectedSurahNumber = 0; // Seçilen sure numarası (1..114)
}

@embedded
class ActivitySchedule {
  // Haftanın günleri: Pazartesi 1, Pazar 7.
  List<int> weeklyDays = [];

  // Ayın günleri: 1..31.
  List<int> monthlyDays = [];
}

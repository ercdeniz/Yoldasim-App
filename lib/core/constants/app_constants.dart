class AppConstants {
  AppConstants._();

  // --- MANTIKSAL / MATEMATİKSEL SABİTLER ---
  static const months = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];

  static const daysOfWeek = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];

  // --- ARAYÜZ METİNLERİ (STRINGS) ---
  static const common = _CommonStrings();
  static const activity = _ActivityStrings();
  static const home = _HomeStrings();
}

class _CommonStrings {
  const _CommonStrings();
  final String appName = 'Yoldaşım';
  final String update = 'Güncelle';
  final String cancel = 'İptal';
  final String close = 'Kapat';
  final String delete = 'Sil';
  final String edit = 'Düzenle';
  final String statistics = 'İstatistikler';
  final String mandatory = 'Zorunlu';
  final String optional = 'İsteğe Bağlı';
  final String today = 'Bugün';
  final String yes = 'Evet';
  final String no = 'Hayır';
}

class _HomeStrings {
  const _HomeStrings();
  final String noActivity = 'Bugün için henüz bir görev eklenmedi.';
  final String tasks = 'Görevler';
}

class _ActivityStrings {
  const _ActivityStrings();
  final String activityAddTitle = 'Aktivite Ekle';
  final String mandatory = 'Zorunlu Aktivite';
  final String mandatoryDesc =
      'Planlı günlerde yapılmadığında eksik görünür ve yüzdeye dahil edilir.';
  final String startDate = 'Başlangıç Tarihi';
  final String updateTarget = 'Hedefi Güncelle';
  final String detailTarget = 'Hedef';
  final String detailPeriod = 'Periyot';
  final String detailStartDate = 'Başlangıç tarihi';
  final String detailRequirement = 'Zorunluluk';
  final String detailSelectedJuz = 'Seçilen cüzler';
  final String detailSelectedSurah = 'Seçilen sure';
  final String detailPrayerTime = 'Namaz vakti';
  final String detailDailyTarget = 'Günlük hedef';
  final String detailTotalDebt = 'Toplam borç';
  final String salahTitle = 'Namaz Kazası';
  final String salahDesc = 'Toplam ve günlük namaz borçlarını ekle';
  final String salahTime = 'Namaz Vakti';
  final String salahTotalDebt = 'Toplam Kaza Borcu (Vakit)';
  final String dailyTarget = 'Günlük Kılınacak Hedef';
  final String fastingTitle = 'Oruç Kazası';
  final String fastingDesc = 'Ramazan, adak veya kefaret orucu ekle';
  final String fastingTotalDebt = 'Toplam Oruç Borcu (Gün)';
  final String fastingQuestion = 'Bugün oruç tuttunuz mu?';

  final String quranTitle = 'Kur\'an-ı Kerim';
  final String quranDesc = 'Sayfa, cüz veya sure hedefleri';
  final String quranTargetType = 'Hedef Birimi';
  final String quranPage = 'Sayfa';
  final String quranJuz = 'Cüz';
  final String quranSurah = 'Sure';
  final String selectQuranJuz = 'Cüz seçin';
  final String selectQuranSurah = 'Sure seçin';
  final String searchQuranSurah = 'Sure ara';
  final String noQuranSearchResult = 'Aramanızla eşleşen sure bulunamadı.';
  final String quranTargetValue = 'Hedef Miktarı';
  final String quranTargetHint = 'Örn: 5';
  final String quranPeriod = 'Hedef Periyodu';
  final String periodTitle = 'Hedef Periyodu';
  final String periodDaily = 'Günlük';
  final String periodWeekly = 'Haftalık';
  final String periodMonthly = 'Aylık';
  final String periodYearly = 'Yıllık';
  final String periodAllTime = 'Tüm Zamanlar';
  final String scheduledDays = 'Uygulanacak Günler';
  final String allDays = 'Tüm günleri seç';
  final String clearDays = 'Seçimleri temizle';
  final String apply = 'Uygula';
  final String selectTargetType = 'Hedef birimi seçin';
  final String selectPeriod = 'Periyot seçin';
  final String selectDays = 'Günleri seçin';

  final List<String> quranSurahNames = const [
    'Fatiha',
    'Bakara',
    'Âl-i İmrân',
    'Nisâ',
    'Mâide',
    'En\'âm',
    'A\'râf',
    'Enfâl',
    'Tevbe',
    'Yûnus',
    'Hûd',
    'Yûsuf',
    'Ra\'d',
    'İbrâhîm',
    'Hicr',
    'Nahl',
    'İsrâ',
    'Kehf',
    'Meryem',
    'Tâhâ',
    'Enbiyâ',
    'Hac',
    'Mü\'minûn',
    'Nûr',
    'Furkân',
    'Şuarâ',
    'Neml',
    'Kasas',
    'Ankebût',
    'Rûm',
    'Lokmân',
    'Secde',
    'Ahzâb',
    'Sebe\'',
    'Fâtır',
    'Yâsîn',
    'Sâffât',
    'Sâd',
    'Zümer',
    'Mü\'min',
    'Fussilet',
    'Şûrâ',
    'Zuhruf',
    'Duhân',
    'Câsiye',
    'Ahkâf',
    'Muhammed',
    'Fetih',
    'Hucurât',
    'Kaf',
    'Zâriyât',
    'Tûr',
    'Necm',
    'Kamer',
    'Rahmân',
    'Vâkıa',
    'Hadîd',
    'Mücâdele',
    'Haşr',
    'Mümtehine',
    'Saf',
    'Cum\'a',
    'Münâfikûn',
    'Teğâbün',
    'Talâk',
    'Tahrîm',
    'Mülk',
    'Kalem',
    'Hâkka',
    'Meâric',
    'Nûh',
    'Cin',
    'Müzzemmil',
    'Müddessir',
    'Kıyâmet',
    'İnsân',
    'Mürselât',
    'Nebe',
    'Nâziât',
    'Abese',
    'Tekvîr',
    'İnfitâr',
    'Mutaffifîn',
    'İnşikâk',
    'Bürûc',
    'Târık',
    'A\'lâ',
    'Gâşiye',
    'Fecr',
    'Beled',
    'Şems',
    'Leyl',
    'Duhâ',
    'İnşirâh',
    'Tîn',
    'Alak',
    'Kadr',
    'Beyyine',
    'Zilzâl',
    'Âdiyât',
    'Kâria',
    'Tekâsür',
    'Asr',
    'Hümeze',
    'Fîl',
    'Kureyş',
    'Mâûn',
    'Kevser',
    'Kâfirûn',
    'Nasr',
    'Tebbet',
    'İhlâs',
    'Felak',
    'Nâs',
  ];

  String selectedDaysCount(int count) => '$count gün seçildi';
  String quranSurahNumber(int number) => '$number. sure';
  String selectedQuranJuzCount(int count) => '$count cüz seçildi';
  final String dhikrTitle = 'Zikir / Tesbihat';
  final String dhikrDesc = 'Günlük zikir hedefleri';
  final String dhikrTargetCount = 'Hedef Miktarı';
  final String dhikrTargetHint = 'Örn: 100';
  final String dhikrArabicText = 'Arapça Metin';
  final String dhikrTurkishText = 'Türkçe Okunuşu veya Anlamı';
  final String dhikrArabicHint = 'Arapça zikri buraya yazın';
  final String dhikrTurkishHint = 'İsteğe bağlı olarak ekleyin';
  final String selectTimePlaceholder = 'Vakit Seçin';
  final String selectTimeTitle = 'Namaz Vakti Seçin';
  final String targetConditionTitle = 'Hedef Koşulu';

  final String errSelectTime = '• Lütfen bir namaz vakti seçin.';
  final String errTotalDebtEmpty = '• Toplam kaza borcunu girin.';
  final String errDailyTargetEmpty = '• Günlük hedef miktarını girin.';
  final String errFastingTotalDebtEmpty = '• Toplam oruç borcunu girin.';
  final String errQuranTargetEmpty = '• Hedef miktarını girin.';
  final String errQuranJuzEmpty = '• En az bir cüz seçin.';
  final String errQuranSurahEmpty = '• Bir sure seçin.';
  final String errDhikrTargetEmpty = '• Zikir hedefini girin.';
  final String errDhikrArabicEmpty = '• Arapça metni girin.';
  final String errScheduleWeeklyEmpty = '• En az bir haftalık gün seçin.';
  final String errScheduleMonthlyEmpty = '• En az bir aylık gün seçin.';

  String successCreated(String activityName) =>
      '$activityName kazası başarıyla oluşturuldu.';

  final String deleteTitle = 'Aktiviteyi Sil';
  final String cannotBeUndone = 'Bu işlem geri alınamaz.';
  final String deleteErrorBase = 'Aktivite silinirken bir hata oluştu: ';

  String deleteConfirmQuestion(String title) =>
      '"$title" aktivitesini ve tüm geçmiş kayıtlarını silmek istediğinize emin misiniz?\n\n';
  String successDeleted(String title) =>
      '"$title" aktivitesi ve tüm geçmiş kayıtları silindi.';

  final String updateErrorBase = 'Aktivite güncellenirken bir hata oluştu: ';

  String targetDisplay(String conditionName, int target) =>
      'Hedef: $conditionName $target';
}

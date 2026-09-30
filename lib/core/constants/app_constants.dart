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
}

class _HomeStrings {
  const _HomeStrings();
  final String noActivity = 'Bugün için henüz bir görev eklenmedi.';
  final String tasks = 'Görevler';
}

class _ActivityStrings {
  const _ActivityStrings();
  final String activityAddTitle = 'Aktivite Ekle';
  final String mandatory = 'Her Gün Zorunlu';
  final String mandatoryDesc = 'Yapılmadığı günler eksik (başarısız) görünür.';
  final String startDate = 'Başlangıç Tarihi';
  final String updateTarget = 'Hedefi Güncelle';
  final String salahTitle = 'Namaz Kazası';
  final String salahDesc = 'Toplam ve günlük namaz borçlarını ekle';
  final String salahTime = 'Namaz Vakti';
  final String salahTotalDebt = 'Toplam Kaza Borcu (Vakit)';
  final String dailyTarget = 'Günlük Kılınacak Hedef';
  final String fastingTitle = 'Oruç Kazası';
  final String fastingDesc = 'Ramazan, adak veya kefaret orucu ekle';
  final String quranTitle = 'Kur\'an-ı Kerim';
  final String quranDesc = 'Sayfa veya cüz hedefleri';
  final String dhikrTitle = 'Zikir / Tesbihat';
  final String dhikrDesc = 'Günlük zikir hedefleri';
  final String selectTimePlaceholder = 'Vakit Seçin';
  final String selectTimeTitle = 'Namaz Vakti Seçin';
  final String targetConditionTitle = 'Hedef Koşulu';

  final String errSelectTime = '• Lütfen bir namaz vakti seçin.';
  final String errTotalDebtEmpty = '• Toplam kaza borcunu girin.';
  final String errDailyTargetEmpty = '• Günlük hedef miktarını girin.';

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

  // Dinamik Metot (Koşul ve hedef miktarı ile birleşen şablon)
  String targetDisplay(String conditionName, int target) =>
      'Hedef: $conditionName $target';
}

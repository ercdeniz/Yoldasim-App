class AppConstants {
  // Sınıfın yanlışlıkla üretilmesini (instance alınmasını) engellemek için:
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
  static const validation = _ValidationStrings();
  static const home = _HomeStrings();
}

// ORTAK KELİMELER (Her sayfada kullanılabilenler)
class _CommonStrings {
  const _CommonStrings();

  final String appName = 'Yoldaşım';
  final String save = 'Kaydet';
  final String cancel = 'İptal';
  final String add = 'Ekle';
  final String ok = 'Tamam';
  final String delete = 'Sil';
  final String edit = 'Düzenle';
  final String mandatory = 'Zorunlu';
  final String optional = 'İsteğe Bağlı';
}

// HOMEPAGE İLE İLGİLİ METİNLER
class _HomeStrings {
  const _HomeStrings();

  final String noActivity = 'Bugün için henüz bir görev eklenmedi.';
}

// AKTİVİTE İSİMLERİ VE AÇIKLAMALARI (Menüde, başlıklarda, kartlarda ortak)
class _ActivityStrings {
  const _ActivityStrings();

  final String activityAddTitle = 'Aktivite Ekle';
  final String mandatory = 'Her Gün Zorunlu';
  final String mandatoryDesc = 'Yapılmadığı günler eksik (başarısız) görünür.';
  final String pickStartDate = 'Başlangıç Tarihi';

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
}

// UYARI VE HATA MESAJLARI
class _ValidationStrings {
  const _ValidationStrings();

  // snackbar veya dialoglarda gösterilecek uyarı ve hata mesajları
  final requirementError = const (
    title: 'Eksik Bilgi',
    desc: 'Lütfen tüm zorunlu alanları doldurun.',
  );
}

extension StringTruncateExtension on String {
  String truncate([int maxLength = 6]) {
    if (length <= maxLength) return this;

    final truncatedText = substring(0, maxLength);

    final isRtl = RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
    ).hasMatch(this);

    if (isRtl) {
      return '$truncatedText\u2026\u200F';
    } else {
      return '$truncatedText\u2026\u200E';
    }
  }
}

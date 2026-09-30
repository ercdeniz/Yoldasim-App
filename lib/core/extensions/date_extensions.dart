import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  DateTime get onlyDate => DateTime(year, month, day);
  String get onlyDateString => onlyDate.toString().split(' ')[0];
  String get formattedDate => DateFormat('dd MMMM yyyy', 'tr_TR').format(this);
}

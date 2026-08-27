import 'package:intl/intl.dart';

final _shortDate = DateFormat('d MMM y', 'pt_BR');
final _dateTime = DateFormat('d MMM y, HH:mm', 'pt_BR');

String formatShortDate(DateTime date) => _shortDate.format(date.toLocal());

String formatDateTime(DateTime date) => _dateTime.format(date.toLocal());

abstract class IDateFormatter {
  String getDay(DateTime date);
}

class DateFormatter implements IDateFormatter {
  @override
  String getDay(DateTime date) {
    final dayName = _getDayName(date);
    final monthName = _getMonthName(date);
    return '$dayName d. ${date.day} $monthName';
  }

  String _getDayName(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Mandag';
      case 2:
        return 'Tirsdag';
      case 3:
        return 'Onsdag';
      case 4:
        return 'Torsdag';
      case 5:
        return 'Fredag';
      case 6:
        return 'Lørdag';
      case 7:
        return 'Søndag';
      default:
        return '';
    }
  }

  String _getMonthName(DateTime date) {
    switch (date.month) {
      case 1:
        return 'januar';
      case 2:
        return 'februar';
      case 3:
        return 'marts';
      case 4:
        return 'april';
      case 5:
        return 'maj';
      case 6:
        return 'juni';
      case 7:
        return 'juli';
      case 8:
        return 'august';
      case 9:
        return 'september';
      case 10:
        return 'oktober';
      case 11:
        return 'november';
      case 12:
        return 'december';
      default:
        return '';
    }
  }
}

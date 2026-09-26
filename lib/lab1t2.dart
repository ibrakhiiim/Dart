void main() {
  String dateStr = '05.09.2026';

  List<String> parts = dateStr.split('.');
  int day = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int year = int.parse(parts[2]);

  bool isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);

  List<int> daysInMonths = [31, isLeap ? 29 : 28,
    31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  day++;

  if (day > daysInMonths[month - 1]) {
    day = 1;
    month++;
    if (month > 12) {
      month = 1;
      year++;
    }
  }
  String nextDay = day.toString().padLeft(2, '0');
  String nextMonth = month.toString().padLeft(2, '0');
  print('$dateStr -> $nextDay.$nextMonth.$year');
}
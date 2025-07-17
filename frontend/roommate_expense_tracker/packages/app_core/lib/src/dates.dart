// Helper function to format DateTime to 'YYYY-MM-DD' string for Athena

// Helper to get the start of the day (midnight)
DateTime startOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

// Helper to get the end of the day (just before midnight next day)
DateTime endOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
}

// Helper to get the start of the month
DateTime startOfMonth(DateTime date) {
  return DateTime(date.year, date.month, 1);
}

// Helper to get the end of the month
DateTime endOfMonth(DateTime date) {
  return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
}

// Helper to get the start of the year
DateTime startOfYear(DateTime date) {
  return DateTime(date.year, 1, 1);
}

// Helper to get the end of the year
DateTime endOfYear(DateTime date) {
  return DateTime(date.year, 12, 31, 23, 59, 59, 999);
}

// Helper to get the start of the week (Monday as start of week)
// Adjust if your week starts on Sunday or another day.
DateTime startOfWeek(DateTime date) {
  int daysToSubtract =
      date.weekday - 1; // 0 for Monday, 1 for Tuesday, ..., 6 for Sunday
  DateTime start = date.subtract(Duration(days: daysToSubtract));
  return DateTime(start.year, start.month, start.day); // Trim time component
}

// Helper to get the end of the week
DateTime endOfWeek(DateTime date) {
  DateTime start = startOfWeek(date);
  return DateTime(start.year, start.month, start.day + 6, 23, 59, 59, 999);
}

DateTime get today => DateTime.now().subtract(const Duration(days: 1));

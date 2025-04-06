DateTime normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

bool isPastDate(DateTime date) => normalizeDate(date).isBefore(normalizeDate(DateTime.now()));

bool isCurrentDate(DateTime date) => normalizeDate(date).isAtSameMomentAs(normalizeDate(DateTime.now()));

bool isFutureDate(DateTime date) => normalizeDate(date).isAfter(normalizeDate(DateTime.now()));

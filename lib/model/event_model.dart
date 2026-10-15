class Event {
  final int? id;
  final String title, description, date, time; // date بصيغة yyyy-MM-dd

  const Event({
    this.id,
    required this.title,
    this.description = '',
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'title': title,
    'description': description,
    'date': date,
    'time': time,
  };

  factory Event.fromMap(Map<String, dynamic> m) => Event(
    id: m['id'] as int,
    title: m['title'] as String,
    description: m['description'] as String,
    date: m['date'] as String,
    time: m['time'] as String,
  );
}

String dateKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

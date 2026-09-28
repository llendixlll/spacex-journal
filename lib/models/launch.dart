/// Модель одного космічного запуску.
///
/// Предметна область варіанта 12 — журнал космічних запусків SpaceX.
class Launch {
  final int flightNumber;
  final String name;
  final int year;
  final String rocket;
  final bool success;

  Launch({
    required this.flightNumber,
    required this.name,
    required this.year,
    required this.rocket,
    required this.success,
  });

  /// Перетворює обʼєкт у мапу для запису у файл JSON.
  Map<String, dynamic> toJson() => {
        'flight_number': flightNumber,
        'name': name,
        'year': year,
        'rocket': rocket,
        'success': success,
      };

  /// Відновлює обʼєкт із мапи, зчитаної з JSON.
  factory Launch.fromJson(Map<String, dynamic> json) => Launch(
        flightNumber: json['flight_number'] as int? ?? 0,
        name: json['name'] as String? ?? 'Без назви',
        year: json['year'] as int? ?? 0,
        rocket: json['rocket'] as String? ?? 'Невідома ракета',
        success: json['success'] as bool? ?? false,
      );

  @override
  String toString() => '#$flightNumber  $name ($year), ракета: $rocket — '
      '${success ? 'успішний' : 'невдалий'}';
}

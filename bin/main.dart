import 'dart:convert';
import 'dart:io';

import 'package:spacex_journal/models/launch.dart';

const _dataFile = 'data.json';

Future<void> main() async {
  final launches = await _loadLaunches();

  var running = true;
  while (running) {
    _printMenu();
    stdout.write('Оберіть пункт: ');
    final choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '1':
        _showLaunches(launches);
        break;
      case '2':
        _addLaunch(launches);
        await _saveLaunches(launches);
        break;
      case '3':
        _deleteLaunch(launches);
        await _saveLaunches(launches);
        break;
      case '0':
        running = false;
        break;
      default:
        print('Невідомий пункт меню. Спробуйте ще раз.\n');
    }
  }

  print('До побачення!');
}

void _printMenu() {
  print('=== Журнал космічних запусків SpaceX ===');
  print('1. Показати список запусків');
  print('2. Додати запуск');
  print('3. Видалити запуск');
  print('0. Вихід');
}

void _showLaunches(List<Launch> launches) {
  if (launches.isEmpty) {
    print('\nСписок порожній.\n');
    return;
  }
  print('\nУсього запусків: ${launches.length}');
  for (var i = 0; i < launches.length; i++) {
    print('${i + 1}. ${launches[i]}');
  }
  print('');
}

void _addLaunch(List<Launch> launches) {
  final flightNumber = _readInt('Номер польоту: ');
  if (flightNumber == null) return;

  stdout.write('Назва місії: ');
  final name = stdin.readLineSync()?.trim();
  if (name == null || name.isEmpty) {
    print('Назва не може бути порожньою. Скасовано.\n');
    return;
  }

  final year = _readInt('Рік запуску: ');
  if (year == null) return;

  stdout.write('Ракета: ');
  final rocket = stdin.readLineSync()?.trim();
  if (rocket == null || rocket.isEmpty) {
    print('Назва ракети не може бути порожньою. Скасовано.\n');
    return;
  }

  stdout.write('Успішний? (так/ні): ');
  final answer = stdin.readLineSync()?.trim().toLowerCase();
  final success = answer == 'так' || answer == 'y' || answer == 'yes';

  launches.add(Launch(
    flightNumber: flightNumber,
    name: name,
    year: year,
    rocket: rocket,
    success: success,
  ));
  print('Запуск «$name» додано.\n');
}

void _deleteLaunch(List<Launch> launches) {
  if (launches.isEmpty) {
    print('\nСписок порожній — нема чого видаляти.\n');
    return;
  }
  _showLaunches(launches);
  final index = _readInt('Введіть номер запису для видалення: ');
  if (index == null) return;
  if (index < 1 || index > launches.length) {
    print('Немає запису з таким номером. Скасовано.\n');
    return;
  }
  final removed = launches.removeAt(index - 1);
  print('Видалено: ${removed.name}\n');
}

/// Зчитує ціле число з консолі; повертає null і повідомляє, якщо ввід некоректний.
int? _readInt(String prompt) {
  stdout.write(prompt);
  final value = int.tryParse(stdin.readLineSync()?.trim() ?? '');
  if (value == null) {
    print('Потрібно ввести число. Скасовано.\n');
  }
  return value;
}

/// Зчитує список запусків із файлу data.json під час запуску програми.
Future<List<Launch>> _loadLaunches() async {
  final file = File(_dataFile);
  if (!await file.exists()) {
    return [];
  }
  try {
    final raw = await file.readAsString();
    if (raw.trim().isEmpty) return [];
    final data = jsonDecode(raw) as List<dynamic>;
    return data.map((e) => Launch.fromJson(e as Map<String, dynamic>)).toList();
  } catch (e) {
    print(
        'Не вдалося прочитати $_dataFile ($e). Починаємо з порожнього списку.');
    return [];
  }
}

/// Зберігає список запусків у файл data.json у зручному для читання форматі.
Future<void> _saveLaunches(List<Launch> launches) async {
  final file = File(_dataFile);
  const encoder = JsonEncoder.withIndent('  ');
  await file.writeAsString(encoder.convert(launches));
}

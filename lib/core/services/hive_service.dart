import 'package:hive_flutter/hive_flutter.dart';

/// Centralized local storage service using Hive for offline-first caching.
class HiveService {
  HiveService._();

  static const String settingsBoxName = 'settings_box';
  static const String dictionaryBoxName = 'dictionary_box';
  static const String tasksBoxName = 'tasks_box';
  static const String documentsBoxName = 'documents_box';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Open required boxes
    await Hive.openBox(settingsBoxName);
    final dictBox = await Hive.openBox(dictionaryBoxName);
    final tasksBox = await Hive.openBox(tasksBoxName);
    final docsBox = await Hive.openBox(documentsBoxName);

    // Seed default data if empty
    if (dictBox.isEmpty) {
      await _seedDictionary(dictBox);
    }
    if (tasksBox.isEmpty) {
      await _seedTasks(tasksBox);
    }
    if (docsBox.isEmpty) {
      await _seedDocuments(docsBox);
    }
  }

  static Future<void> _seedDictionary(Box box) async {
    final seedWords = [
      {
        'id': '1',
        'english': 'Ayubowan',
        'sinhala': 'ආයුබෝවන්',
        'transliteration': 'Āyubōvan',
        'category': 'Greetings',
        'definition': 'May you live long! Traditional Sri Lankan greeting used anytime.',
        'isBookmarked': true,
      },
      {
        'id': '2',
        'english': 'Thank You',
        'sinhala': 'ස්තූතියි',
        'transliteration': 'Stutiyi',
        'category': 'Polite Expressions',
        'definition': 'Expression of gratitude.',
        'isBookmarked': true,
      },
      {
        'id': '3',
        'english': 'Please',
        'sinhala': 'කරුණාකර',
        'transliteration': 'Karunākara',
        'category': 'Polite Expressions',
        'definition': 'Polite request modifier.',
        'isBookmarked': false,
      },
      {
        'id': '4',
        'english': 'Hospital',
        'sinhala': 'රෝහල',
        'transliteration': 'Rōhala',
        'category': 'Medical',
        'definition': 'An institution providing medical and surgical treatment.',
        'isBookmarked': true,
      },
      {
        'id': '5',
        'english': 'Emergency',
        'sinhala': 'හදිසි අවස්ථාව',
        'transliteration': 'Hadisi Avasthāva',
        'category': 'Emergency',
        'definition': 'A serious, unexpected situation requiring immediate action.',
        'isBookmarked': false,
      },
      {
        'id': '6',
        'english': 'Job / Employment',
        'sinhala': 'රකියාව',
        'transliteration': 'Rakiyāva',
        'category': 'Career',
        'definition': 'Paid position of regular employment.',
        'isBookmarked': false,
      },
      {
        'id': '7',
        'english': 'Beautiful',
        'sinhala': 'ලස්සනයි',
        'transliteration': 'Lassanayi',
        'category': 'Adjectives',
        'definition': 'Pleasing the senses or mind aesthetically.',
        'isBookmarked': false,
      },
      {
        'id': '8',
        'english': 'Water',
        'sinhala': 'වතුර',
        'transliteration': 'Vathura',
        'category': 'Daily Essentials',
        'definition': 'Essential liquid for life.',
        'isBookmarked': false,
      },
      {
        'id': '9',
        'english': 'Friend',
        'sinhala': 'යහළුවා',
        'transliteration': 'Yahaluwā',
        'category': 'Social',
        'definition': 'A person with whom one has a bond of mutual affection.',
        'isBookmarked': false,
      },
      {
        'id': '10',
        'english': 'Welcome',
        'sinhala': 'සාදරයෙන් පිළිගනිමු',
        'transliteration': 'Sādarayen Piḷiganimu',
        'category': 'Greetings',
        'definition': 'Warm gesture of welcoming someone.',
        'isBookmarked': true,
      }
    ];

    for (var word in seedWords) {
      await box.put(word['id'], word);
    }
  }

  static Future<void> _seedTasks(Box box) async {
    final seedTasks = [
      {
        'id': 'task_1',
        'title': 'Renew Driving License at DMT Werahera',
        'description': 'Gather NIC, medical certificate, and current license copy.',
        'priority': 'High',
        'isCompleted': false,
        'dueDate': '2026-09-20',
      },
      {
        'id': 'task_2',
        'title': 'Pay Utility Electricity Bill (CEB)',
        'description': 'Use online portal or nearest bank branch before due date.',
        'priority': 'Medium',
        'isCompleted': true,
        'dueDate': '2026-09-18',
      },
      {
        'id': 'task_3',
        'title': 'Prepare CV for Flutter Developer Role',
        'description': 'Update portfolio links and LankaPulse super-app project details.',
        'priority': 'High',
        'isCompleted': false,
        'dueDate': '2026-09-22',
      },
      {
        'id': 'task_4',
        'title': 'Check Vesak Poya Volunteer Schedule',
        'description': 'Coordinate with local community centre for Dansala setup.',
        'priority': 'Low',
        'isCompleted': false,
        'dueDate': '2026-09-25',
      },
    ];

    for (var task in seedTasks) {
      await box.put(task['id'], task);
    }
  }

  static Future<void> _seedDocuments(Box box) async {
    final seedDocs = [
      {
        'id': 'doc_1',
        'title': 'National Identity Card (NIC)',
        'category': 'Identification',
        'fileSize': '1.2 MB',
        'dateAdded': '2026-08-10',
        'isEncrypted': true,
      },
      {
        'id': 'doc_2',
        'title': 'Driving License Copy',
        'category': 'Licenses',
        'fileSize': '2.4 MB',
        'dateAdded': '2026-08-14',
        'isEncrypted': true,
      },
      {
        'id': 'doc_3',
        'title': 'Vehicle Revenue License 2026',
        'category': 'Vehicle',
        'fileSize': '850 KB',
        'dateAdded': '2026-09-01',
        'isEncrypted': false,
      },
    ];

    for (var doc in seedDocs) {
      await box.put(doc['id'], doc);
    }
  }
}

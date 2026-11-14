import 'package:equatable/equatable.dart';

class DictionaryWord extends Equatable {
  final String id;
  final String english;
  final String sinhala;
  final String transliteration;
  final String category;
  final String definition;
  final bool isBookmarked;

  const DictionaryWord({
    required this.id,
    required this.english,
    required this.sinhala,
    required this.transliteration,
    required this.category,
    required this.definition,
    this.isBookmarked = false,
  });

  factory DictionaryWord.fromMap(Map<dynamic, dynamic> map) {
    return DictionaryWord(
      id: map['id'] ?? '',
      english: map['english'] ?? '',
      sinhala: map['sinhala'] ?? '',
      transliteration: map['transliteration'] ?? '',
      category: map['category'] ?? 'General',
      definition: map['definition'] ?? '',
      isBookmarked: map['isBookmarked'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'english': english,
      'sinhala': sinhala,
      'transliteration': transliteration,
      'category': category,
      'definition': definition,
      'isBookmarked': isBookmarked,
    };
  }

  DictionaryWord copyWith({
    bool? isBookmarked,
  }) {
    return DictionaryWord(
      id: id,
      english: english,
      sinhala: sinhala,
      transliteration: transliteration,
      category: category,
      definition: definition,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  List<Object?> get props => [id, english, sinhala, isBookmarked];
}

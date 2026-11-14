import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/services/hive_service.dart';
import '../../data/models/dictionary_word.dart';

abstract class DictionaryState extends Equatable {
  const DictionaryState();
  @override
  List<Object?> get props => [];
}

class DictionaryInitial extends DictionaryState {}
class DictionaryLoading extends DictionaryState {}
class DictionaryLoaded extends DictionaryState {
  final List<DictionaryWord> words;
  final String searchQuery;
  final bool showOnlyBookmarked;
  final String activeCategory;

  const DictionaryLoaded({
    required this.words,
    this.searchQuery = '',
    this.showOnlyBookmarked = false,
    this.activeCategory = 'All',
  });

  List<DictionaryWord> get filteredWords {
    return words.where((w) {
      final matchesBookmark = !showOnlyBookmarked || w.isBookmarked;
      final matchesCategory = activeCategory == 'All' ||
          w.category.toLowerCase() == activeCategory.toLowerCase();
      final query = searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          w.english.toLowerCase().contains(query) ||
          w.sinhala.toLowerCase().contains(query) ||
          w.transliteration.toLowerCase().contains(query);

      return matchesBookmark && matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  List<Object?> get props => [words, searchQuery, showOnlyBookmarked, activeCategory];
}

class DictionaryCubit extends Cubit<DictionaryState> {
  DictionaryCubit() : super(DictionaryInitial()) {
    loadWords();
  }

  Future<void> loadWords() async {
    emit(DictionaryLoading());
    try {
      if (Hive.isBoxOpen(HiveService.dictionaryBoxName)) {
        final box = Hive.box(HiveService.dictionaryBoxName);
        final words = box.values
            .map((e) => DictionaryWord.fromMap(Map<dynamic, dynamic>.from(e as Map)))
            .toList();
        emit(DictionaryLoaded(words: words));
      } else {
        _loadFallback();
      }
    } catch (_) {
      _loadFallback();
    }
  }

  void _loadFallback() {
    const fallback = [
      DictionaryWord(
        id: '1',
        english: 'Ayubowan',
        sinhala: 'ආයුබෝවන්',
        transliteration: 'Āyubōvan',
        category: 'Greetings',
        definition: 'May you live long! Traditional Sri Lankan greeting.',
        isBookmarked: true,
      ),
      DictionaryWord(
        id: '2',
        english: 'Thank You',
        sinhala: 'ස්තූතියි',
        transliteration: 'Stutiyi',
        category: 'Polite Expressions',
        definition: 'Expression of gratitude.',
        isBookmarked: true,
      ),
    ];
    emit(const DictionaryLoaded(words: fallback));
  }

  void setSearchQuery(String query) {
    if (state is DictionaryLoaded) {
      final current = state as DictionaryLoaded;
      emit(DictionaryLoaded(
        words: current.words,
        searchQuery: query,
        showOnlyBookmarked: current.showOnlyBookmarked,
        activeCategory: current.activeCategory,
      ));
    }
  }

  void toggleBookmarkFilter() {
    if (state is DictionaryLoaded) {
      final current = state as DictionaryLoaded;
      emit(DictionaryLoaded(
        words: current.words,
        searchQuery: current.searchQuery,
        showOnlyBookmarked: !current.showOnlyBookmarked,
        activeCategory: current.activeCategory,
      ));
    }
  }

  Future<void> toggleBookmarkWord(String id) async {
    if (state is DictionaryLoaded) {
      final current = state as DictionaryLoaded;
      final updatedWords = current.words.map((w) {
        if (w.id == id) {
          final updated = w.copyWith(isBookmarked: !w.isBookmarked);
          if (Hive.isBoxOpen(HiveService.dictionaryBoxName)) {
            Hive.box(HiveService.dictionaryBoxName).put(id, updated.toMap());
          }
          return updated;
        }
        return w;
      }).toList();

      emit(DictionaryLoaded(
        words: updatedWords,
        searchQuery: current.searchQuery,
        showOnlyBookmarked: current.showOnlyBookmarked,
        activeCategory: current.activeCategory,
      ));
    }
  }
}

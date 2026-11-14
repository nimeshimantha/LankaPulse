import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/news_article_model.dart';

abstract class NewsState extends Equatable {
  const NewsState();
  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}
class NewsLoading extends NewsState {}
class NewsLoaded extends NewsState {
  final List<NewsArticle> articles;
  final String activeCategory;
  final String searchQuery;

  const NewsLoaded({
    required this.articles,
    this.activeCategory = 'All',
    this.searchQuery = '',
  });

  List<NewsArticle> get filteredArticles {
    return articles.where((article) {
      final matchesCategory = activeCategory == 'All' ||
          article.category.toLowerCase() == activeCategory.toLowerCase();
      final matchesSearch = searchQuery.isEmpty ||
          article.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          article.summary.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  List<Object?> get props => [articles, activeCategory, searchQuery];
}

class NewsError extends NewsState {
  final String message;
  const NewsError(this.message);
  @override
  List<Object?> get props => [message];
}

class NewsCubit extends Cubit<NewsState> {
  final FirebaseFirestore? _firestore;

  NewsCubit({FirebaseFirestore? firestore})
      : _firestore = firestore,
        super(NewsInitial()) {
    loadNews();
  }

  Future<void> loadNews() async {
    emit(NewsLoading());
    try {
      if (_firestore != null) {
        _listenToFirestoreNews();
      } else {
        _loadMockNews();
      }
    } catch (_) {
      _loadMockNews();
    }
  }

  void _listenToFirestoreNews() {
    try {
      _firestore!.collection('news').snapshots().listen((snapshot) {
        final articles = snapshot.docs
            .map((doc) => NewsArticle.fromMap(doc.data(), doc.id))
            .toList();
        if (articles.isEmpty) {
          _loadMockNews();
        } else {
          emit(NewsLoaded(articles: articles));
        }
      }, onError: (_) => _loadMockNews());
    } catch (_) {
      _loadMockNews();
    }
  }

  void _loadMockNews() {
    final mockArticles = [
      const NewsArticle(
        id: '1',
        title: 'Lotus Tower Light Show & Cultural Festival Announced for Colombo',
        summary: 'A 3-day grand pop culture & tech expo featuring Sri Lankan artists, musical performances, and drone light shows.',
        content: 'Colombo Lotus Tower is set to host the largest multi-cultural event of 2026. Organizers promise interactive digital art galleries, gaming zones, and live concerts by top local artists.',
        category: 'Culture',
        imageUrl: 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62',
        publishedAt: '2 hours ago',
        source: 'LankaPulse Cultural Desk',
        isBreaking: true,
      ),
      const NewsArticle(
        id: '2',
        title: 'New Expressway Interchange Opened to Ease Kandy-Colombo Commute',
        summary: 'The Central Expressway extension opens to the public today, reducing travel time to under 2 hours.',
        content: 'Commuters between Colombo and Kandy can now enjoy faster travel as the Ministry of Highways officially declared open the newest section of the Central Expressway.',
        category: 'Tech',
        imageUrl: 'https://images.unsplash.com/photo-1519003722824-194d4455a60c',
        publishedAt: '4 hours ago',
        source: 'Daily News LK',
        isBreaking: false,
      ),
      const NewsArticle(
        id: '3',
        title: 'Sri Lanka Cricket Announces Squad for T20 Asia Cup 2026',
        summary: 'Young talents selected alongside seasoned veterans as team prepares for the opening match in Dambulla.',
        content: 'Sri Lanka Cricket selectors have finalized the 15-member squad. The team is scheduled to fly to Dambulla International Stadium for intense pre-tournament training camps.',
        category: 'Sports',
        imageUrl: 'https://images.unsplash.com/photo-1531415074968-036ba1b575da',
        publishedAt: '6 hours ago',
        source: 'Pulse Sports',
        isBreaking: false,
      ),
      const NewsArticle(
        id: '4',
        title: 'IT & AI Innovation Summit 2026 Kicks Off in Port City Colombo',
        summary: 'Global tech leaders gather to explore Sri Lanka\'s emerging role as a South Asian software & AI hub.',
        content: 'Over 500 tech delegates, startup founders, and venture capitalists have registered for the Port City AI Summit aiming to boost local software exports.',
        category: 'Tech',
        imageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475',
        publishedAt: '1 day ago',
        source: 'TechPulse LK',
        isBreaking: false,
      ),
    ];

    emit(NewsLoaded(articles: mockArticles));
  }

  void selectCategory(String category) {
    if (state is NewsLoaded) {
      final current = state as NewsLoaded;
      emit(NewsLoaded(
        articles: current.articles,
        activeCategory: category,
        searchQuery: current.searchQuery,
      ));
    }
  }

  void updateSearchQuery(String query) {
    if (state is NewsLoaded) {
      final current = state as NewsLoaded;
      emit(NewsLoaded(
        articles: current.articles,
        activeCategory: current.activeCategory,
        searchQuery: query,
      ));
    }
  }
}

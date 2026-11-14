import 'package:equatable/equatable.dart';

class NewsArticle extends Equatable {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String category;
  final String imageUrl;
  final String publishedAt;
  final String source;
  final bool isBreaking;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.category,
    required this.imageUrl,
    required this.publishedAt,
    required this.source,
    this.isBreaking = false,
  });

  factory NewsArticle.fromMap(Map<String, dynamic> map, String id) {
    return NewsArticle(
      id: id,
      title: map['title'] ?? '',
      summary: map['summary'] ?? '',
      content: map['content'] ?? '',
      category: map['category'] ?? 'General',
      imageUrl: map['imageUrl'] ?? '',
      publishedAt: map['publishedAt'] ?? '',
      source: map['source'] ?? 'LankaPulse News',
      isBreaking: map['isBreaking'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'summary': summary,
      'content': content,
      'category': category,
      'imageUrl': imageUrl,
      'publishedAt': publishedAt,
      'source': source,
      'isBreaking': isBreaking,
    };
  }

  @override
  List<Object?> get props => [id, title, category, publishedAt, isBreaking];
}

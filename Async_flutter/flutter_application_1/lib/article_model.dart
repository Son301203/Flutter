// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Article {
  final String title;
  final String urlToImage;
  final String author;
  final String content;
  final String publishedAt;
  Article({
    required this.title,
    required this.urlToImage,
    required this.author,
    required this.content,
    required this.publishedAt,
  });
}

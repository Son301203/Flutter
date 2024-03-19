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

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json["title"],
      urlToImage: json["urlToImage"],
      author: json["author"],
      content: json["content"],
      publishedAt: json["publishedAt"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['urlToImage'] = urlToImage;
    data['author'] = author;
    data['content'] = content;
    data['publishedAt'] = publishedAt;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': this.title,
      'urlToImage': this.urlToImage,
      'author': this.author,
      'content': this.content,
      'publishedAt': this.publishedAt,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      title: map['title'] as String,
      urlToImage: map['urlToImage'] as String,
      author: map['author'] as String,
      content: map['content'] as String,
      publishedAt: map['publishedAt'] as String,
    );
  }
//
}
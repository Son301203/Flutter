import 'article_detail.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'article_model.dart';


class SavedArticlesScreen extends StatefulWidget {
  const SavedArticlesScreen({Key? key, required List<Article> savedArticles})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SavedArticlesScreenState createState() => _SavedArticlesScreenState();
}

class _SavedArticlesScreenState extends State<SavedArticlesScreen> {
  List<Article> _savedArticles = [];

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    final db = Localstore.instance;
    final likedArticles =
        await db.collection('users').doc('likedArticles').get();

    if (likedArticles != null) {
      final Map<String, dynamic>? savedArticles =
          // ignore: unnecessary_cast
          likedArticles as Map<String, dynamic>?;

      if (savedArticles != null) {
        setState(() {
          _savedArticles = savedArticles.values
              .map((article) => Article.fromMap(article))
              .toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Save',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _savedArticles.isEmpty
          ? const Center(child: Text('There are no articles saved yet'))
          : ListView.builder(
              itemCount: _savedArticles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ArticleDetail(article: _savedArticles[index]),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 0.0,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          _savedArticles[index].urlToImage,
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        _savedArticles[index].title,
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> saveArticles(List<Article> articles) async {
    final db = Localstore.instance;
    final likedArticles =
        await db.collection('users').doc('likedArticles').get();

    // Kiểm tra nếu likedArticles không null và có dữ liệu, sử dụng dữ liệu từ nó, nếu không, sử dụng một map rỗng
    // ignore: prefer_if_null_operators
    final savedArticles = likedArticles != null ? likedArticles : {};

    // Lưu các bài viết mới
    for (final article in articles) {
      if (!savedArticles.containsKey(article.title)) {
        savedArticles[article.title] = article.toMap();
      }
    }

    // Chuyển đổi kiểu dữ liệu của savedArticles sang Map<String, dynamic>
    final Map<String, dynamic> savedArticlesMap =
        Map<String, dynamic>.from(savedArticles);

    await db.collection('users').doc('likedArticles').set(savedArticlesMap);
  }

  Future<void> deleteArticle(Article article) async {
    final db = Localstore.instance;
    final likedArticles =
        await db.collection('users').doc('likedArticles').get();

    if (likedArticles != null) {
      final Map<String, dynamic>? savedArticles =
          // ignore: unnecessary_cast
          likedArticles as Map<String, dynamic>?;

      if (savedArticles != null && savedArticles.containsKey(article.title)) {
        savedArticles.remove(article.title);
        await db.collection('users').doc('likedArticles').set(savedArticles);
      }
    }
  }
}
import 'package:flutter/material.dart';
import 'article_model.dart';
import 'package:localstore/localstore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'saved_article.dart';

class ArticleDetail extends StatefulWidget {
  final Article article;

  const ArticleDetail({super.key, required this.article});

  @override
  State<ArticleDetail> createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  bool isLiked = false;
  final List<Article> _savedArticles = []; // Danh sách các bài viết đã thích
  String? articleContent;

  @override
  void initState() {
    super.initState();
    _loadLikedStatus();
  }

  Future<void> _loadLikedStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLiked = prefs.getBool(widget.article.title) ?? false;
    });
  }

  Future<void> _toggleLike() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool updatedIsLiked = !isLiked;

    // Lưu trạng thái đã thích mới vào SharedPreferences
    await prefs.setBool(widget.article.title, updatedIsLiked);

    // Cập nhật trạng thái đã thích của bài viết
    setState(() {
      isLiked = updatedIsLiked;
    });

    // Hiển thị thông báo Snackbar
    final snackBar = SnackBar(
      content: Text(updatedIsLiked ? 'Article saved' : 'Article deleted'),
    );
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Cập nhật danh sách bài viết đã lưu
    if (updatedIsLiked) {
      setState(() {
        _savedArticles.add(widget.article);
      });
    } else {
      setState(() {
        _savedArticles.remove(widget.article);
      });
    }

    // Gọi hàm lưu bài viết đã thích hoặc xóa bài viết đã thích
    if (updatedIsLiked) {
      await saveArticles([widget.article]);
    } else {
      await deleteArticle(widget.article);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon:
                Icon(isLiked ? Icons.favorite : Icons.favorite_border_rounded),
            onPressed: _toggleLike,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200.0,
              width: double.infinity,
              decoration: BoxDecoration(
                //let's add the height

                image: DecorationImage(
                    image: NetworkImage(widget.article.urlToImage),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(widget.article.publishedAt,
                    style: const TextStyle(
                      color: Color.fromARGB(130, 50, 50, 50),
                      fontSize: 11,
                    )),
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              widget.article.title,
              style: const TextStyle(
                fontSize: 18, // Kích thước của font chữ
                fontWeight: FontWeight
                    .bold, // Độ đậm của font chữ (có thể là normal, bold, ...)
                fontStyle:
                    FontStyle.normal, // Kiểu font chữ (normal hoặc italic)
                color: Colors.black, // Màu của font chữ
                letterSpacing: 1.5, // Khoảng cách giữa các ký tự
                wordSpacing: 2.0, // Khoảng cách giữa các từ
                fontFamily: 'Arial', // Font chữ cụ thể (nếu có)
              ),
            ),
            Text("By ${widget.article.author}",
                style: const TextStyle(
                  color: Color.fromARGB(130, 50, 50, 50),
                  fontSize: 11,
                )),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.article.content,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SavedArticlesScreen(savedArticles: _savedArticles),
            ),
          );
        },
        child: const Icon(Icons.favorite),
      ),
    );
  }

  Future<void> saveArticles(List<Article> articles) async {
    final db = Localstore.instance;
    final likedArticles =
        await db.collection('users').doc('likedArticles').get();

    final savedArticles = likedArticles ?? {};

    for (final article in articles) {
      if (!savedArticles.containsKey(article.title)) {
        savedArticles[article.title] = article.toMap();
      }
    }

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
          likedArticles as Map<String, dynamic>?;

      if (savedArticles != null && savedArticles.containsKey(article.title)) {
        savedArticles.remove(article.title);
        await db.collection('users').doc('likedArticles').set(savedArticles);
      }
    }
  }
}
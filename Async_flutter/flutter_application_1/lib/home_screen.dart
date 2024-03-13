import 'dart:convert';

import 'package:flutter/material.dart';
import 'article_model.dart';
import 'article_detail.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
          children: [
            Row(
              children: [
                Text(
                  DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),
                  style: const TextStyle(color: Colors.grey, fontSize: 14.0),
                ),
              ],
            ),
            const Row(
              children: [
                Text(
                  'Explore',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        ),
        body: FutureBuilder(
          future: getArticles(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                final data = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final articleData = data[index];
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ArticleDetail(article: articleData))
                        );
                      },
                      title: articleData.title != '[Removed]'
                          ? Text(articleData.title,
                              style: TextStyle(fontWeight: FontWeight.bold))
                          : null,
                      subtitle: Text("By " + articleData.author),
                      leading: Image.network(
                        articleData.urlToImage,
                        width: 100,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                      trailing: Icon(Icons.more_vert),
                    );
                  },
                );
            }
          },
        ));
  }

  Future<List<Article>> getArticles() async {
    const url =
        'https://newsapi.org/v2/everything?q=apple&from=2024-03-11&to=2024-03-11&sortBy=popularity&apiKey=edd7fb40fef348c48966ec58a4dce779'; //apikey is private
    final res = await http.get(Uri.parse(url));
    final body = json.decode(res.body) as Map<String, dynamic>;
    final List<Article> result = [];
    for (final article in body['articles']) {
      if (article['title'] != '[Removed]') {
        result.add(Article(
          title: article['title'],
          author: article['author'] ?? 'Unknown',
          urlToImage: article['urlToImage'] ??
              "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png",
          content: article['content'] ?? '',
          publishedAt: article['publishedAt'] ?? '',
        ));
      }
    }

    return result;
  }

}
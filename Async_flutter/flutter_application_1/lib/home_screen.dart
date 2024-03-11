import 'dart:convert';

import 'package:flutter/material.dart';
import 'article_model.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: FutureBuilder(
        future: getArticles(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
            case ConnectionState.done:
              final data = snapshot.data ?? [];
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final articleData = data[index];
                  return ListTile(
                    title: articleData.title != '[Removed]'?  Text(articleData.title) : null,
                    subtitle: Text("By " + articleData.author),
                    leading:
                      Image.network(
                        articleData.urlToImage,
                        width: 100,
                        height: 100,
                      ),
                    trailing: Icon(Icons.more_vert),
                  );
                },
              );
          }
        }
      ),
    );
  }

  Future<List<Article>> getArticles() async {
    const url =
        "https://newsapi.org/v2/everything?q=tesla&from=2024-02-11&sortBy=publishedAt&apiKey=edd7fb40fef348c48966ec58a4dce779";
    final res = await http.get(Uri.parse(url));
    final body = json.decode(res.body) as Map<String, dynamic>;
    final List<Article> result = [];

    for (final article in body['articles']) {
      result.add(
        Article(
          title: article['title'], 
          author: article['author'] ?? '',
          urlToImage: article['urlToImage'] ?? '',
          content: article['content'] ?? '',
          publishedAt: article['publishedAt'] ?? '',
        )
      );
    }
    return result;
  }
}

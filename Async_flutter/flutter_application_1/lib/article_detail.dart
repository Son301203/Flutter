import 'dart:convert';

import 'package:flutter/material.dart';
import 'article_model.dart';
import 'package:http/http.dart' as http;

class ArticleDetail extends StatelessWidget {
  const ArticleDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        title: const Text('Details'),
        centerTitle: true,
        actions: [
          Icon(Icons.favorite_border),
        ],
      ),
      body: FutureBuilder(
          future: getArticles(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                final data = snapshot.data ?? [];
                return MaterialApp(
                    home: Scaffold(
                      body: ListView(children: [
                        SizedBox(height: 16),
                        Image.network(
                          data.first.urlToImage,
                          width: MediaQuery.of(context).size.width,
                          height: 270,
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: Text(
                            data.first.title,
                            style: const TextStyle(
                              fontSize: 18, // Kích thước của font chữ
                              fontWeight: FontWeight
                                  .bold, // Độ đậm của font chữ (có thể là normal, bold, ...)
                              fontStyle: FontStyle
                                  .normal, // Kiểu font chữ (normal hoặc italic)
                              color: Colors.black, // Màu của font chữ
                              letterSpacing: 1.5, // Khoảng cách giữa các ký tự
                              wordSpacing: 2.0, // Khoảng cách giữa các từ
                              fontFamily: 'Arial', // Font chữ cụ thể (nếu có)
                            ),
                          )
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "By " + data.first.author, 
                              style: const TextStyle(
                                color: Color.fromARGB(130, 50, 50, 50), 
                                fontSize: 12,
                              )
                            ),
                            Text(
                              data.first.publishedAt, 
                              style: const TextStyle(
                                color: Color.fromARGB(130, 50, 50, 50), 
                                fontSize: 12,
                              )
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          data.first.content
                        ),
                      ]
                    ),
                  )
                );
            }
          }),
    );
  }

  Future<List<Article>> getArticles() async {
    const url =
        "https://newsapi.org/v2/everything?q=tesla&from=2024-02-11&sortBy=publishedAt&apiKey=edd7fb40fef348c48966ec58a4dce779";
    final res = await http.get(Uri.parse(url));
    final body = json.decode(res.body) as Map<String, dynamic>;
    final List<Article> result = [];

    for (final article in body['articles']) {
      result.add(Article(
        title: article['title'],
        author: article['author'] ?? '',
        urlToImage: article['urlToImage'] ?? '',
        content: article['content'] ?? '',
        publishedAt: article['publishedAt'] ?? '',
      ));
    }
    return result;
  }
}

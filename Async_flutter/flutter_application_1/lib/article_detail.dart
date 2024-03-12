import 'dart:convert';

import 'package:flutter/material.dart';
import 'article_model.dart';
import 'package:http/http.dart' as http;

class ArticleDetail extends StatelessWidget {
  final Article article;

  ArticleDetail({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        centerTitle: true,
        actions: [
          Icon(Icons.favorite_border),
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
                    image: NetworkImage(article.urlToImage), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              padding: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("By " + article.author,
                    style: const TextStyle(
                      color: Color.fromARGB(130, 50, 50, 50),
                      fontSize: 12,
                    )),
                Text(article.publishedAt,
                    style: const TextStyle(
                      color: Color.fromARGB(130, 50, 50, 50),
                      fontSize: 12,
                    )),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              article.title,
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
            SizedBox(
              height: 15,
            ),
            Text(
              article.content,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'article_model.dart';
import 'article_detail.dart';
import 'saved_article.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  
}


class _HomeScreenState extends State<HomeScreen> {
  String searchText = ''; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEE, dd\'th\' MMMM yyyy').format(DateTime.now()),
                style: GoogleFonts.tinos(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Explore',
                style: GoogleFonts.tinos(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 24),

              Container(
                margin: const EdgeInsets.only(right: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search for article',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const SizedBox(
                height: 40,
                child: CategoriesBar(),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ArticleList(searchText: searchText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesBar extends StatefulWidget {
  const CategoriesBar({super.key});

  @override
  State<CategoriesBar> createState() => _CategoriesBarState();
}

class _CategoriesBarState extends State<CategoriesBar> {
  List<String> categories = const [
    'All',
    'Politics',
    'Sports',
    'Health',
    'Music',
    'Tech'
  ];

  int currentCategory = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            currentCategory = index;
            setState(() {});
          },
          child: Container(
            margin: const EdgeInsets.only(right: 8.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            decoration: BoxDecoration(
              color: currentCategory == index ? Colors.black : Colors.white,
              border: Border.all(),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Center(
              child: Text(
                categories.elementAt(index),
                style: TextStyle(
                  color: currentCategory == index ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ArticleList extends StatelessWidget {
  const ArticleList({Key? key, required this.searchText});
  static const List<Article> _savedArticles = [];
  final String searchText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getArticles(searchText),
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
                padding: const EdgeInsets.only(right: 16.0),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ArticleTile(
                    article: data.elementAt(index),
                  );
                },
              );
          }
        },
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

  Future<List<Article>> getArticles( String searchText) async {
    const url =
        'https://newsapi.org/v2/top-headlines?country=us&category=sports&apiKey=edd7fb40fef348c48966ec58a4dce779'; 
    final res = await http.get(Uri.parse(url));
    final body = json.decode(res.body) as Map<String, dynamic>;
    final List<Article> result = [];
    for (final article in body['articles']) {
      if (article['title'] != '[Removed]' && 
        article['title'].toLowerCase().contains(searchText.toLowerCase())) {
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

class ArticleTile extends StatelessWidget {
  const ArticleTile({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticleDetail(article: article)));
        },
        child: Container(
          height: 128,
          margin: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  article.urlToImage ?? '',
                  fit: BoxFit.cover,
                  height: 128,
                  width: 128,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 128,
                      width: 128,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png")),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                  child: ListTile(
                    title: Text(article.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 15),
                    ),
                    subtitle: Text("By " + article.author,
                    style: TextStyle(fontSize: 10),),
                    dense: true,
              )),
            ],
          ),
        ));
  }
}

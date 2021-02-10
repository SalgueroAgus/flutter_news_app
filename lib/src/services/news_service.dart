import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/src/models/category_model.dart';
import 'package:news_app/src/models/news_models.dart';
import 'package:http/http.dart' as http;

final _urlNews = 'https://newsapi.org/v2';
final _apiKey = 'fd98e60c27da49ba80529474c46b5c6f';

class NewsService with ChangeNotifier {
  List<Article> headlines = [];
  String _selectedCategories = 'business';

  List<Category> categories = [
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.footballBall, 'sports'),
    Category(FontAwesomeIcons.microchip, 'technology'),
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    this.getTopHeadlines();
    categories.forEach((item) {
      this.categoryArticles[item.name] = new List.empty(growable: true);
    });
  }

  get selectedCategories => this._selectedCategories;
  set selectedCategories(String valor) {
    this._selectedCategories = valor;
    this.getArticlesByCategory(valor);
    notifyListeners();
  }

  getTopHeadlines() async {
    final url = '$_urlNews/top-headlines?apiKey=$_apiKey&country=ar';
    final resp = await http.get(url);
    final newsResponse = newsResponseFromJson(resp.body);

    this.headlines.addAll(newsResponse.articles);

    notifyListeners();
  }

  getArticlesByCategory(String category) async {
    if (this.categoryArticles[category].length > 0) {
      return this.categoryArticles[category];
    }

    final url =
        '$_urlNews/top-headlines?apiKey=$_apiKey&country=ar&category=$category';
    final resp = await http.get(url);
    final newsResponse = newsResponseFromJson(resp.body);

    this.categoryArticles[category].addAll(newsResponse.articles);

    notifyListeners();
  }

  List<Article> get getArticulosCategoriaSeleccionada =>
      this.categoryArticles[this.selectedCategories];
}

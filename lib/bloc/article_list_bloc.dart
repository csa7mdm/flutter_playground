import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../data/article.dart';
import '../data/rw_client.dart';
import 'bloc.dart';

class ArticleListBloc implements Bloc {
  // 1
  final _client = RWClient();
  // 2
  //The code gives a private StreamController declaration. It will manage the input sink for this BLoC. StreamControllers use generics to tell the type system what kind of object the stream will emit.
  final _searchQueryController = StreamController<String?>();
  // 3
  //public sink interface for your input controller _searchQueryController. You’ll use this sink to send events to the BLoC.
  Sink<String?> get searchQuery => _searchQueryController.sink;
  // 4
  //articlesStream stream acts as a bridge between ArticleListScreen and ArticleListBloc. Basically, the BLoC will stream a list of articles onto the screen. You’ll see late syntax here. It means you have to initialize the variable in the future before you first use it. The late keyword helps you avoid making these variables as null type.
  late Stream<List<Article>?> articlesStream;

  ArticleListBloc() {
    articlesStream = _searchQueryController.stream
        .startWith(null) // 1
        .debounceTime(const Duration(milliseconds: 100)) // 2
        .switchMap( // 3
          (query) => _client.fetchArticles(query)
          .asStream() // 4
          .startWith(null), // 5
    );
  }

  // 6
  @override
  void dispose() {
    _searchQueryController.close();
  }
}
import 'package:flutter/material.dart';
import 'package:moviedb/views/movie_list.dart';
import 'package:moviedb/controllers/movie_list.dart';
import 'package:moviedb/theme/custom_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieListController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(CTheme.primaryColor),
        scaffoldBackgroundColor: Color(CTheme.primaryColor),
      ),
      home: MovieListPage(),
    );
  }
}

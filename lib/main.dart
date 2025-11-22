import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Recipe {
  final int id;
  final String title;
  final String description;
  final int calories;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.calories,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      calories: json['calories'],
    );
  }
}

Future<List<Recipe>> loadRecipes() async {
  final String response = await rootBundle.loadString('assets/recipes.json');
  final List data = json.decode(response);
  return data.map((item) => Recipe.fromJson(item)).toList();
}

class RecipeListPage extends StatefulWidget {
  @override
  _RecipeListPageState createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  late Future<List<Recipe>> recipes;

  @override
  void initState() {
    super.initState();
    recipes = loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Food Recipes")),
      body: FutureBuilder<List<Recipe>>(
        future: recipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data ?? [];

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(items[index].title),
                subtitle: Text("Calories: ${items[index].calories}"),
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: RecipeListPage()));
}

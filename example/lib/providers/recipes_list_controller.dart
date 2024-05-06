import 'package:flutter/material.dart';
import 'package:ultralytics_yolo_example/widgets/recipe_view.dart';

class ListRecipes {
  static Future<void> buildListRecipes(BuildContext context, dynamic jsonResponse) async {
    final List<dynamic> recipes = jsonResponse['hits'].take(5).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recipes', style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: recipes.sublist(1).map<Widget>((recipeData) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showRecipeDetails(context, recipeData);
                      },
                      child: _buildRecipeWidget(recipeData),
                    ),
                    _buildDivider(),
                  ],
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Chiudi'),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildRecipeWidget(dynamic recipeData) {
    final recipe = recipeData['recipe'];

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              recipe['label'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Image.network(
              recipe['image'],
              height: 145,
              width: 145,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            //_buildRecipeDetail('Ingredients', recipe['ingredientLines'].join(", ")),
            //_buildRecipeDetail('Calories', '${recipe['calories']}'),
            //_buildRecipeDetail('Dish Type', '${recipe['dishType']}'),
          ],
        ),
      ),
    );
  }

  static Widget _buildRecipeDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  static Widget _buildDivider() {
    return const Divider(
      color: Colors.grey,
      height: 2,
      thickness: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  static void _showRecipeDetails(BuildContext context, dynamic recipeData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailsPage(recipeData: recipeData),
      ),
    );
  }
}
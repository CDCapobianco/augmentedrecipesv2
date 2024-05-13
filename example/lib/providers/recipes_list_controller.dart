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
            _buildRecipeDetail('place', checkHealtyness(recipe['totalNutrients'], recipe['totalWeight'])),
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
  
  static String checkHealtyness(Map<String, dynamic> nutrients, double totalWeigth){
  double carbo = nutrients['CHOCDF']['quantity']*100/totalWeigth;
  double protein = nutrients['PROCNT']['quantity']*100/totalWeigth;
  double sugar = nutrients['SUGAR']['quantity']*100/totalWeigth;
  //double kcal = nutrients['ENERC_KCAL']['quantity']*100/totalWeigth;
  double fat = nutrients['FAT']['quantity']*100/totalWeigth;
  totalWeigth = 100;
  double calorieProteine = protein * 4;
  double calorieCarboidrati = carbo * 4;
  double calorieGrassi = fat * 9;
  double calorieTotali = calorieProteine + calorieCarboidrati + calorieGrassi;
  double percentualeProteine = (calorieProteine / calorieTotali) * 100;
  double percentualeCarboidrati = (calorieCarboidrati / calorieTotali) * 100;
  double percentualeGrassi = (calorieGrassi / calorieTotali) * 100;

  // Calcola la percentuale di zuccheri rispetto al peso totale
  double percentualeZuccheri = (sugar / totalWeigth) * 100;

  // Calcola uno score basato sui valori percentuali
  if (percentualeProteine >= 20 && percentualeCarboidrati >= 45 && percentualeGrassi <= 35 && percentualeZuccheri <= 10) {
    return "4"; // Molto salutare
  } else if (percentualeProteine >= 15 && percentualeCarboidrati >= 40 && percentualeGrassi <= 40 && percentualeZuccheri <= 15) {
    return "3"; // Piuttosto salutare
  } else if (percentualeProteine >= 10 && percentualeCarboidrati >= 35 && percentualeGrassi <= 45 && percentualeZuccheri <= 20) {
    return "2"; // Moderatamente salutare
  } else {
    return "1"; // Poco salutare
  }
 }
}
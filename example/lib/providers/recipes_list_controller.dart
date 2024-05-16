import 'package:flutter/material.dart';
import 'package:ultralytics_yolo_example/widgets/recipe_view.dart';

class ListRecipes {
  static Future<void> buildListRecipes(BuildContext context, dynamic jsonResponse) async {
    final List<dynamic> recipes = jsonResponse['hits'].take(5).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Stack(
  children: [
    Text(
      'Delightful Selections',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
    ),
    Positioned(
      right: 0,
      top: -4,
      child: Icon(Icons.star, color: Colors.orange, size: 30),
    ),
  ],
),

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
                      child: buildRecipeWidget(recipeData),
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
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
              ),
              child: Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget buildRecipeWidget(dynamic recipeData) {
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
            _buildRecipeDetail('Health Score', checkHealtiness(recipe['totalNutrients'], recipe['totalWeight'])),
          ],
        ),
      ),
    );
  }

  static Widget _buildRecipeDetail(String label, String value) {
    // Aggiunta di icone emoji per migliorare l'aspetto del punteggio di salute
    Widget emojiIcon;
    if (value == 'Bad') {
      emojiIcon = Text('Bad 😞', style: TextStyle(fontSize: 20));
    } else if (value == 'Quite Bad') {
      emojiIcon = Text('Quite Bad 😕', style: TextStyle(fontSize: 20));
    } else if (value == 'Balanced') {
      emojiIcon = Text('Balanced 😐', style: TextStyle(fontSize: 20));
    } else if (value == 'Good') {
      emojiIcon = Text('Good 😊', style: TextStyle(fontSize: 20));
    } else if (value == 'Quite Good') {
      emojiIcon = Text('Quite Good 😄', style: TextStyle(fontSize: 20));
    } else if (value == 'Excellent') {
      emojiIcon = Text('Excellent 😃', style: TextStyle(fontSize: 20));
    } else {
      emojiIcon = Text('');
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$label:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          SizedBox(width: 10),
          emojiIcon, // Emoji icon per l'health score
        ],
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
  static String checkHealtiness(Map<String, dynamic> nutrients, double totalWeigth){
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
  double percProt = (calorieProteine / calorieTotali) * 100;
  double percCarb = (calorieCarboidrati / calorieTotali) * 100;
  double percFat = (calorieGrassi / calorieTotali) * 100;

  // Calcola la percentuale di zuccheri rispetto al peso totale
  double percSug = (sugar / totalWeigth) * 100;
  double score = 0;
  bool p=false, c=false, f=false, s= false, v = false;
  if(percProt >= 20)
  {
    score = score + 20;
    p=true;
  }
  if(percCarb >= 45)
  {
    score = score + 20;
    c=true;
  }
  if(percFat <= 35){
    score = score + 20;
    f=true;
  }
  if(percSug <= 10){
    score = score + 20;
    s=true;
  }
  if(nutrients['VITA_RAE']['quantity'] != 0 && nutrients['VITC']['quantity'] != 0 && nutrients['THIA']['quantity'] != 0 && nutrients['NIA']['quantity'] != 0 && nutrients['VITB6A']['quantity'] != 0){
    score = score + 20;
    v=true;
  }
  if(score == 0){
    return "Bad";
  }
  if(score == 20){
    return "Quite Bad";
  }
  if(score == 40){
    return "Balanced";
  }
  if(score == 60){
    return "Good";
  }
  if(score == 80){
    return "Quite Good";
  }
  if(score == 100){
    return "Excellent";
  }
  return "";
  
 }
}
import 'package:flutter/material.dart';
import 'package:ultralytics_yolo_example/providers/query_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeDetailsPage extends StatelessWidget {
  final dynamic recipeData;

  const RecipeDetailsPage({Key? key, required this.recipeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipe = recipeData['recipe'];
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['label']),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage('assets/backgroundImageRecipeView.jpg'),
          fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRecipeImage(recipe['image']),
                    SizedBox(height: 16),
                    _buildNutrientsSection(recipe['totalNutrients'], recipe['totalWeight']),
                    SizedBox(height: 16),
                    checkHealtyness(recipe['totalNutrients'], recipe['totalWeight']),
                    SizedBox(height: 16),
                    _buildCO2EmissionsBox(recipe['totalCO2Emissions'], recipe['totalWeight']),
                    SizedBox(height: 16),
                    _buildButtons(recipe['url'], recipe['label']),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
  
  Widget _buildRecipeImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildCO2EmissionsBox(double totalCO2Emissions, double totalWeight) {
    double emissionsPer100g = (totalCO2Emissions * 100 / totalWeight).round().toDouble();
    bool isHighEmission = emissionsPer100g >= 1000;
    bool isModerateEmission = emissionsPer100g >= 500 && emissionsPer100g < 1000;
    IconData iconData;
    Color iconColor;
    Color textColor;
    if(isHighEmission){
      iconData = Icons.sentiment_dissatisfied_outlined;
      iconColor = Colors.red;
      textColor = Colors.red;
    }
    else if(isModerateEmission){
      iconData = Icons.sentiment_neutral_rounded;
      iconColor = Colors.orange;
      textColor = Colors.orange;
    }
    else{
      iconData = Icons.sentiment_satisfied_rounded;
      iconColor = Colors.green;
      textColor = Colors.green;
    }
    

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            iconData,
            color: iconColor,
            size: 40,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CO2 Emissions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$emissionsPer100g g CO2 per 100g',
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              PopupMenuButton(
                icon: Icon(Icons.help_outline, size: 15),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text('Cooking with care,\nreducing our carbon fare'),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientsSection(Map<String, dynamic> nutrients, double totalWeigth) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 3,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    padding: EdgeInsets.all(16),
    child: ExpansionTile(
      title: const Text(
        'Nutrients per 100 g',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [
        _buildNutrientItem(nutrients['ENERC_KCAL']['label'], nutrients['ENERC_KCAL']['quantity']*100/totalWeigth, nutrients['ENERC_KCAL']['unit']),
        _buildNutrientItem(nutrients['PROCNT']['label'], nutrients['PROCNT']['quantity']*100/totalWeigth, nutrients['PROCNT']['unit']),
        _buildNutrientItem(nutrients['FAT']['label'], nutrients['FAT']['quantity']*100/totalWeigth, nutrients['FAT']['unit']),
        _buildNutrientItem(nutrients['CHOCDF']['label'], nutrients['CHOCDF']['quantity']*100/totalWeigth, nutrients['CHOCDF']['unit']),
        _buildNutrientItem('          Whose sugars', nutrients['SUGAR']['quantity']*100/totalWeigth, nutrients['SUGAR']['unit']),
        ExpansionTile(
          title: const Text(
            'Vitamine',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          children: [
            if (nutrients['VITA_RAE']['quantity'] != 0) _buildNutrientItem(nutrients['VITA_RAE']['label'], nutrients['VITA_RAE']['quantity']*100/totalWeigth, nutrients['VITA_RAE']['unit']),
            if (nutrients['VITC']['quantity'] != 0) _buildNutrientItem(nutrients['VITC']['label'], nutrients['VITC']['quantity']*100/totalWeigth, nutrients['VITC']['unit']),
            if (nutrients['THIA']['quantity'] != 0) _buildNutrientItem(nutrients['THIA']['label'], nutrients['THIA']['quantity']*100/totalWeigth, nutrients['THIA']['unit']),
            if (nutrients['RIBF']['quantity'] != 0) _buildNutrientItem(nutrients['RIBF']['label'], nutrients['RIBF']['quantity']*100/totalWeigth, nutrients['RIBF']['unit']),
            if (nutrients['NIA']['quantity'] != 0) _buildNutrientItem(nutrients['NIA']['label'], nutrients['NIA']['quantity']*100/totalWeigth, nutrients['NIA']['unit']),
            if (nutrients['VITB6A']['quantity'] != 0) _buildNutrientItem(nutrients['VITB6A']['label'], nutrients['VITB6A']['quantity']*100/totalWeigth, nutrients['VITB6A']['unit']),
          ],
        ),
      ],
    ),
  );
}


  Widget checkHealtyness(Map<String, dynamic> nutrients, double totalWeigth){
  double carbo = nutrients['CHOCDF']['quantity']*100/totalWeigth;
  double protein = nutrients['PROCNT']['quantity']*100/totalWeigth;
  double sugar = nutrients['SUGAR']['quantity']*100/totalWeigth;
  double fat = nutrients['FAT']['quantity']*100/totalWeigth;
  totalWeigth = 100;
  double calorieProteine = protein * 4;
  double calorieCarboidrati = carbo * 4;
  double calorieGrassi = fat * 9;
  double calorieTotali = calorieProteine + calorieCarboidrati + calorieGrassi;
  double percProt = (calorieProteine / calorieTotali) * 100;
  double percCarb = (calorieCarboidrati / calorieTotali) * 100;
  double percFat = (calorieGrassi / calorieTotali) * 100;
  double percSug = (sugar / totalWeigth) * 100;
  double score = 0;
  bool p=false, c=false, f=false, s= false, v = false;
  if(percProt >= 20) { score = score + 20; p=true; }
  if(percCarb >= 45) { score = score + 20; c=true; }
  if(percFat <= 35) { score = score + 20; f=true; }
  if(percSug <= 10) { score = score + 20; s=true; }
  if(nutrients['VITA_RAE']['quantity'] != 0 && nutrients['VITC']['quantity'] != 0 && nutrients['THIA']['quantity'] != 0 && nutrients['NIA']['quantity'] != 0 && nutrients['VITB6A']['quantity'] != 0){
    score = score + 20; v=true;
  }
  
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 3,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    padding: EdgeInsets.all(16),
    child: HealthBar(
      score: score,
      proteinGood: p,
      carbGood: c,
      fatGood: f,
      sugarGood: s,
      vitaminsGood: v,
    ),
  );
}

  Widget _buildNutrientItem(String label, double quantity, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            '${quantity.round()} $unit',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
Widget _buildButtons(String url, String label) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      CustomButton(
        text: 'View Recipe Info',
        onPressed: () {
          _launchURL(url);
        },
      ),
      SizedBox(height: 16),
      CustomButton(
        text: 'Search on Giallo Zafferano',
        onPressed: () {
          _launchURL('https://www.giallozafferano.it/ricerca-ricette/'+Uri.encodeComponent(label));
        },
      ),
    ],
  );
}
  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    await launchUrl(uri);
  }
}


class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
class HealthBar extends StatelessWidget {
  final double score;
  final bool proteinGood;
  final bool carbGood;
  final bool fatGood;
  final bool sugarGood;
  final bool vitaminsGood;

  HealthBar({
    required this.score,
    required this.proteinGood,
    required this.carbGood,
    required this.fatGood,
    required this.sugarGood,
    required this.vitaminsGood,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Healthyness Score',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 24, // Imposta l'altezza desiderata per la barra
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              LinearProgressIndicator(
                value: score / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                minHeight: 24, // Imposta l'altezza della barra
              ),
              Text(
                '${score.toStringAsFixed(0)}%', // Visualizza la percentuale dello score
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (proteinGood) _buildNutrientCheck('Proteine', true),
            if (carbGood) _buildNutrientCheck('Carboidrati', true),
            if (fatGood) _buildNutrientCheck('Grassi', true),
            if (sugarGood) _buildNutrientCheck('Zuccheri', true),
            if (vitaminsGood) _buildNutrientCheck('Vitamine', true),
            if (!proteinGood) _buildNutrientCheck('Proteine', false),
            if (!carbGood) _buildNutrientCheck('Carboidrati', false),
            if (!fatGood) _buildNutrientCheck('Grassi', false),
            if (!sugarGood) _buildNutrientCheck('Zuccheri', false),
            if (!vitaminsGood) _buildNutrientCheck('Vitamine', false),
          ],
        ),
      ],
    );
  }

  Widget _buildNutrientCheck(String nutrient, bool isGood) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            isGood ? Icons.check_circle : Icons.error,
            color: isGood ? Colors.green : Colors.red,
          ),
          SizedBox(height: 4),
          Text(
            nutrient,
            style: TextStyle(
              color: isGood ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

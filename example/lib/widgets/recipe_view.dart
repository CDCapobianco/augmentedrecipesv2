
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package

class RecipeDetailsPage extends StatelessWidget {
  final dynamic recipeData;

  const RecipeDetailsPage({Key? key, required this.recipeData}) : super(key: key);

@override
Widget build(BuildContext context) {
  final recipe = recipeData['recipe'];

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.blue, // Set background color to blue
      leading: IconButton(
        icon: Icon(Icons.arrow_back), // Add back button
        color: Colors.white,
        onPressed: () {
          Navigator.of(context).pop(); // Navigate back when button is pressed
        },
      ),
      title: Text('Details', style: GoogleFonts.poppins( // Applying Poppins font
        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
      )), // Add 'Details' title in the top center
      centerTitle: true,
      toolbarHeight: 80,
      elevation: 0.0,
      scrolledUnderElevation: 0.0,
    ),
    body: Container(
      color: Colors.blue, // Set the background color of the entire body to blue
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: kToolbarHeight), // Space for top bar
              SizedBox(height: 16), // Additional space
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildRecipeInfoBox(context, recipe),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width / 4, // Position image in the center horizontally
            child: SizedBox(
              height: MediaQuery.of(context).size.width / 2, // Set image height to half of screen width
              width: MediaQuery.of(context).size.width / 2, // Set image width to half of screen width
              child: _buildRecipeImage(recipe['image']),
            ),
          ),
        ],
      ),
    ),
  );
}


Widget _buildRecipeImage(String imageUrl) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 15,
          offset: Offset(3, 3),
        ),
      ],
    ),
    child: ClipOval(
      child: Image.network(
        imageUrl,
        height: 250,
        width: 250,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget _buildRecipeInfoBox(BuildContext context,dynamic recipe) {
  return Container(
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 255, 255, 255),
      borderRadius: BorderRadius.circular(40),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 3,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    padding: EdgeInsets.fromLTRB(16, 32 + MediaQuery.of(context).size.width / 4, 16, 16),
    child: ListView(
      children: [
        Text(
          recipe['label'],
          style: GoogleFonts.poppins( // Applying Poppins font
            textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32), // Add some space here
        _buildHealthiness(recipe['totalNutrients'], recipe['totalWeight']),
        SizedBox(height: 32), // Add some space here
        _buildNutrients(recipe['totalNutrients'], recipe['totalWeight']),
        SizedBox(height: 32), // Add some space here
        _buildCO2Emissions(recipe['totalCO2Emissions'], recipe['totalWeight']),
        SizedBox(height: 32), // Add some space here
        _buildButtons(recipe['url'], recipe['label']),
        SizedBox(height: 32), // Add some space here

      ],
    ),
  );
}

  Widget _buildCO2Emissions(double totalCO2Emissions, double totalWeight) {
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

    return Row(
      children: [
        Icon(
          iconData,
          color: iconColor,
          size: 40,
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CO2 Emissions',
              style: GoogleFonts.poppins( // Applying Poppins font
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              '$emissionsPer100g g CO2 per 100g',
              style: GoogleFonts.poppins( // Applying Poppins font
                textStyle: TextStyle(fontSize: 16, color: textColor),
              ),
            ),
          ],
        ),
      ],
    );
  }

 Widget _buildNutrients(Map<String, dynamic> nutrients, double totalWeight) {
  return ExpansionTile(
    title: Text(
      'Nutrients per 100 g',
      style: GoogleFonts.poppins( // Applying Poppins font
        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    ),
    children: [
      SizedBox(height: 8),
      ..._buildNutrientItems(nutrients, totalWeight),
    ],
  );
}

List<Widget> _buildNutrientItems(Map<String, dynamic> nutrients, double totalWeight) {
  return [
    _buildNutrientItem(nutrients['ENERC_KCAL']['label'], nutrients['ENERC_KCAL']['quantity']*100/totalWeight, nutrients['ENERC_KCAL']['unit']),
    _buildNutrientItem(nutrients['PROCNT']['label'], nutrients['PROCNT']['quantity']*100/totalWeight, nutrients['PROCNT']['unit']),
    _buildNutrientItem(nutrients['FAT']['label'], nutrients['FAT']['quantity']*100/totalWeight, nutrients['FAT']['unit']),
    _buildNutrientItem(nutrients['CHOCDF']['label'], nutrients['CHOCDF']['quantity']*100/totalWeight, nutrients['CHOCDF']['unit']),
    _buildNutrientItem('Whose sugars', nutrients['SUGAR']['quantity']*100/totalWeight, nutrients['SUGAR']['unit']),
    if (nutrients['VITA_RAE']['quantity'] != 0) _buildNutrientItem(nutrients['VITA_RAE']['label'], nutrients['VITA_RAE']['quantity']*100/totalWeight, nutrients['VITA_RAE']['unit']),
    if (nutrients['VITC']['quantity'] != 0) _buildNutrientItem(nutrients['VITC']['label'], nutrients['VITC']['quantity']*100/totalWeight, nutrients['VITC']['unit']),
    if (nutrients['THIA']['quantity'] != 0) _buildNutrientItem(nutrients['THIA']['label'], nutrients['THIA']['quantity']*100/totalWeight, nutrients['THIA']['unit']),
    if (nutrients['RIBF']['quantity'] != 0) _buildNutrientItem(nutrients['RIBF']['label'], nutrients['RIBF']['quantity']*100/totalWeight, nutrients['RIBF']['unit']),
    if (nutrients['NIA']['quantity'] != 0) _buildNutrientItem(nutrients['NIA']['label'], nutrients['NIA']['quantity']*100/totalWeight, nutrients['NIA']['unit']),
    if (nutrients['VITB6A']['quantity'] != 0) _buildNutrientItem(nutrients['VITB6A']['label'], nutrients['VITB6A']['quantity']*100/totalWeight, nutrients['VITB6A']['unit']),
  ];
}

Widget _buildNutrientItem(String label, double quantity, String unit) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Text(
      '$label: ${quantity.round()} $unit',
      style: GoogleFonts.poppins( // Applying Poppins font
        textStyle: TextStyle(fontSize: 16),
      ),
    ),
  );
}

Widget _buildHealthiness(Map<String, dynamic> nutrients, double totalWeight) {
  double carbo = nutrients['CHOCDF']['quantity']*100/totalWeight;
  double protein = nutrients['PROCNT']['quantity']*100/totalWeight;
  double sugar = nutrients['SUGAR']['quantity']*100/totalWeight;
  double fat = nutrients['FAT']['quantity']*100/totalWeight;
  totalWeight = 100;
  double calorieProteine = protein * 4;
  double calorieCarboidrati = carbo * 4;
  double calorieGrassi = fat * 9;
  double calorieTotali = calorieProteine + calorieCarboidrati + calorieGrassi;
  double percProt = (calorieProteine / calorieTotali) * 100;
  double percCarb = (calorieCarboidrati / calorieTotali) * 100;
  double percFat = (calorieGrassi / calorieTotali) * 100;
  double percSug = (sugar / totalWeight) * 100;
  double score = 0;
  bool p=false, c=false, f=false, s= false, v = false;
  if(percProt >= 20) { score = score + 20; p=true; }
  if(percCarb >= 45) { score = score + 20; c=true; }
  if(percFat <= 35) { score = score + 20; f=true; }
  if(percSug <= 10) { score = score + 20; s=true; }
  if(nutrients['VITA_RAE']['quantity'] != 0 && nutrients['VITC']['quantity'] != 0 && nutrients['THIA']['quantity'] != 0 && nutrients['NIA']['quantity'] != 0 && nutrients['VITB6A']['quantity'] != 0){
    score = score + 20; v=true;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Healthiness Score',
        style: GoogleFonts.poppins( // Applying Poppins font
          textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
      ),
      SizedBox(height: 8),
      SizedBox(height: 8),
      HealthBar(
        score: score,
        proteinGood: p,
        carbGood: c,
        fatGood: f,
        sugarGood: s,
        vitaminsGood: v,
      ),
    ],
  );
}

  Widget _buildHealthinessItem(String nutrient, double percentage, bool isGood) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nutrient,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '${percentage.toStringAsFixed(0)}%',
          style: TextStyle(
            color: isGood ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(String url, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomButton(
          text: 'Get the Recipe',
          onPressed: () {
            _launchURL(url);
          },
        ),
        SizedBox(height: 16),
        CustomButton(
          text: 'Search on GialloZafferano',
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
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.poppins( // Applying Poppins font
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
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
            if (proteinGood) _buildNutrientCheck('Protein', true),
            if (carbGood) _buildNutrientCheck('Carbs', true),
            if (fatGood) _buildNutrientCheck('Fat', true),
            if (sugarGood) _buildNutrientCheck('Sugar', true),
            if (vitaminsGood) _buildNutrientCheck('Vitamin', true),
            if (!proteinGood) _buildNutrientCheck('Protein', false),
            if (!carbGood) _buildNutrientCheck('Carbs', false),
            if (!fatGood) _buildNutrientCheck('Fat', false),
            if (!sugarGood) _buildNutrientCheck('Sugar', false),
            if (!vitaminsGood) _buildNutrientCheck('Vitamin', false),
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

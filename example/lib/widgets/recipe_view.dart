
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package

class RecipeDetailsPage extends StatelessWidget {
  final dynamic recipeData;

  const RecipeDetailsPage({Key? key, required this.recipeData}) : super(key: key);

@override
Widget build(BuildContext context) {
  final recipe = recipeData['recipe'];
  Color backgroundColor = Color.fromARGB(255, 9, 24, 0);

  return Scaffold(
    backgroundColor: Color.fromARGB(0, 0, 0, 0), // Set Scaffold background to transparent
    extendBodyBehindAppBar: true, // Extend the body behind the AppBar
    body: Container(
      color: Colors.transparent, // Set Container background to transparent
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: kToolbarHeight), // Space for top bar
              Expanded(
                child: _buildRecipeInfoBox(context, recipe), // Removed padding to make it full width
              ),
            ],
          ),
          
          Positioned(
            top: MediaQuery.of(context).size.height / 6,
            left: (MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width / 1.5)) / 2, // Center the image horizontally
            child: SizedBox(
              height: MediaQuery.of(context).size.width / 1.5, // Set image height
              width: MediaQuery.of(context).size.width / 1.5, // Set image width
              child: _buildRecipeImage(recipe['image']),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 4) + (MediaQuery.of(context).size.width / 1.5) - 50,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                recipe['label'],
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


Widget _buildRecipeInfoBox(BuildContext context, dynamic recipe) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  return Container(
    width: screenWidth,
    margin: EdgeInsets.only(top: 32 + screenWidth / 4), // Top margin to align with image
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 255, 255, 255),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 3,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Container(
      margin: EdgeInsets.only(
        top: screenHeight / 6 + screenWidth / 1.5 - 110, // Margin set just below the title
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16), // Padding inside the inner container
      child: ListView(
        padding: EdgeInsets.zero, // Remove ListView padding
        children: [
          _buildHealthiness(recipe['totalNutrients'], recipe['totalWeight']),
          const SizedBox(height: 32),
          _buildNutrients(recipe['totalNutrients'], recipe['totalWeight']),
          const SizedBox(height: 32),
          _buildCO2Emissions(recipe['totalCO2Emissions'], recipe['totalWeight']),
          const SizedBox(height: 32),
          _buildButtons(recipe['url'], recipe['label']),
          const SizedBox(height: 32),
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
          offset: const Offset(3, 3),
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
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CO2 Emissions',
              style: GoogleFonts.poppins( // Applying Poppins font
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    ),
    children: [
      const SizedBox(height: 8),
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
        textStyle: const TextStyle(fontSize: 16),
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
          textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
      ),
      const SizedBox(height: 8),
      const SizedBox(height: 8),
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
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
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
        const SizedBox(height: 16),
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
          color: const Color.fromARGB(255, 0, 0, 0),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.poppins( // Applying Poppins font
            textStyle: const TextStyle(
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
        const SizedBox(height: 8),
        SizedBox(
          height: 24, // Imposta l'altezza desiderata per la barra
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              LinearProgressIndicator(
                value: score / 100,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                minHeight: 24, // Imposta l'altezza della barra
              ),
              Text(
                '${score.toStringAsFixed(0)}%', // Visualizza la percentuale dello score
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
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
          const SizedBox(height: 4),
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

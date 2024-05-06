import 'package:flutter/material.dart';
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRecipeImage(recipe['image']),
            SizedBox(height: 16),
            _buildNutrientsSection(recipe['totalNutrients']), // Sezione per i nutrienti
            SizedBox(height: 16),
            _buildRecipeInfo('CO2 Emissions', '${recipe['totalCO2Emissions'].round()} g'), // Arrotondiamo e aggiungiamo la stringa "g" per le emissioni di CO2
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _launchURL(recipe['url']); // Passo l'URL del ricetta al metodo _launchURL
              },
              child: Text('View Recipe Info'), // Testo del bottone
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _launchURL('https://www.giallozafferano.it/ricerca-ricette/'+Uri.encodeComponent(recipe['label'])); // Passo l'URL del ricetta al metodo _launchURL
              },
              child: Text('Search on Giallo Zafferano'), // Testo del bottone
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

  Widget _buildRecipeInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

 Widget _buildNutrientsSection(Map<String, dynamic> nutrients) {
  return ExpansionTile(
    title: const Text(
      'Nutrienti',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    children: [
      _buildNutrientItem(nutrients['ENERC_KCAL']['label'], nutrients['ENERC_KCAL']['quantity'], nutrients['ENERC_KCAL']['unit']),
      _buildNutrientItem(nutrients['PROCNT']['label'], nutrients['PROCNT']['quantity'], nutrients['PROCNT']['unit']),
      _buildNutrientItem(nutrients['FAT']['label'], nutrients['FAT']['quantity'], nutrients['FAT']['unit']),
      _buildNutrientItem(nutrients['CHOCDF']['label'], nutrients['CHOCDF']['quantity'], nutrients['CHOCDF']['unit']),
      _buildNutrientItem('          Whose sugars', nutrients['SUGAR']['quantity'], nutrients['SUGAR']['unit']),
      ExpansionTile(
        title: const Text(
          'Vitamine',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          if (nutrients['VITA_RAE']['quantity'] != 0) _buildNutrientItem(nutrients['VITA_RAE']['label'], nutrients['VITA_RAE']['quantity'], nutrients['VITA_RAE']['unit']),
          if (nutrients['VITC']['quantity'] != 0) _buildNutrientItem(nutrients['VITC']['label'], nutrients['VITC']['quantity'], nutrients['VITC']['unit']),
          if (nutrients['THIA']['quantity'] != 0) _buildNutrientItem(nutrients['THIA']['label'], nutrients['THIA']['quantity'], nutrients['THIA']['unit']),
          if (nutrients['RIBF']['quantity'] != 0) _buildNutrientItem(nutrients['RIBF']['label'], nutrients['RIBF']['quantity'], nutrients['RIBF']['unit']),
          if (nutrients['NIA']['quantity'] != 0) _buildNutrientItem(nutrients['NIA']['label'], nutrients['NIA']['quantity'], nutrients['NIA']['unit']),
          if (nutrients['VITB6A']['quantity'] != 0) _buildNutrientItem(nutrients['VITB6A']['label'], nutrients['VITB6A']['quantity'], nutrients['VITB6A']['unit']),
      
        ],
      ),
    ],
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


  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    await launchUrl(uri);
    /*if (await canLaunchUrl(uri)) {
      
    } else {
      throw 'Could not launch $url';
    }*/
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ultralytics_yolo_example/widgets/recipe_view.dart';

class ListRecipes extends StatefulWidget {
  final dynamic jsonResponse;

  const ListRecipes({Key? key, required this.jsonResponse}) : super(key: key);

  @override
  _ListRecipesState createState() => _ListRecipesState();

  static Future<void> buildListRecipes(BuildContext context, dynamic jsonResponse) async {
    final List<dynamic> recipes = jsonResponse['hits'].take(5).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListRecipes(jsonResponse: jsonResponse),
      ),
    );
  }
}

class _ListRecipesState extends State<ListRecipes> {
  late PageController _pageController;
  int _currentPageIndex = 0; // Add _currentPageIndex variable

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose the PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> recipes = widget.jsonResponse['hits'].take(5).toList();
    final double dotsTopPosition = MediaQuery.of(context).size.height / 4 * 0.8; // Adjust as needed

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discover',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Set the color to match your theme
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 100), // Adjust as needed
            Expanded(
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recipes.length,
                controller: _pageController, // Pass the PageController
                onPageChanged: (index) {
                  setState(() {
                    _currentPageIndex = index; // Update _currentPageIndex when page changes
                  });
                },
                itemBuilder: (context, index) {
                  return Center(
                    child: _buildRecipeWidget(recipes[index], context),
                  );
                },
              ),
            ),
            SizedBox(
              height: dotsTopPosition, // Adjust the height of the SizedBox to move the dots
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  recipes.length,
                  (index) => _buildDot(index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    final bool isActive = _currentPageIndex == index; // Use _currentPageIndex to determine active dot
    final double dotSize = isActive ? 10.0 : 8.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.black.withOpacity(1.0) : const Color.fromARGB(255, 255, 246, 246).withOpacity(1.0), // Darker color for active dot
      ),
    );
  }



Widget _buildRecipeWidget(dynamic recipeData, BuildContext context) {
  final recipe = recipeData['recipe'];
  final whiteBoxWidth = MediaQuery.of(context).size.width / 1.55;
  final whiteBoxHeight = MediaQuery.of(context).size.height / 3;
  final circleImageSize = MediaQuery.of(context).size.width / 2;

  final circleImageTop = (circleImageSize / 2 - whiteBoxHeight / 2);
  final circleImageLeft = (whiteBoxWidth - circleImageSize) / 2;

  return GestureDetector(
    onTap: () {
      _showRecipeDetails(context, recipeData);
    },
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: whiteBoxWidth,
          height: whiteBoxHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: circleImageSize/1.5), // Add space between title and details
              Text(
                capitalizeInitials(recipe['label']),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8), // Add space between title and details
              _buildRecipeDetail("", checkHealtiness(recipe['totalNutrients'], recipe['totalWeight'])),

            ],
          ),
        ),
        Positioned(
          top: circleImageTop,
          left: circleImageLeft,
          child: Container(
            width: circleImageSize,
            height: circleImageSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                recipe['image'],
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    ),
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

  Widget _buildRecipeDetail(String label, String value) {
  Color? healthScoreColor;
  String emojiLabel;

  // Assigning color and label based on health score value
  if (value == 'Bad') {
    healthScoreColor = Colors.red;
    emojiLabel = 'Very Unhealthy';
  } else if (value == 'Quite Bad') {
    healthScoreColor = Colors.orange;
    emojiLabel = 'Unhealthy';
  } else if (value == 'Balanced') {
    healthScoreColor = Colors.yellow;
    emojiLabel = 'Balanced';
  } else if (value == 'Good') {
    healthScoreColor = Colors.lightGreen;
    emojiLabel = 'Healthy';
  } else if (value == 'Quite Good') {
    healthScoreColor = Colors.green;
    emojiLabel = 'Very Healthy';
  } else if (value == 'Excellent') {
    healthScoreColor = Colors.green[800];
    emojiLabel = 'Extremely Healthy';
  } else {
    healthScoreColor = Colors.white; // Default color
    emojiLabel = '';
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emojiLabel,
            style: GoogleFonts.poppins( // Applying Poppins font
              textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: healthScoreColor),
            ),
          ),
        ],
      ),
    ],
  );
}

  static String checkHealtiness(Map<String, dynamic> nutrients, double totalWeigth) {
    double carbo = nutrients['CHOCDF']['quantity'] * 100 / totalWeigth;
    double protein = nutrients['PROCNT']['quantity'] * 100 / totalWeigth;
    double sugar = nutrients['SUGAR']['quantity'] * 100 / totalWeigth;
    double fat = nutrients['FAT']['quantity'] * 100 / totalWeigth;
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
    bool p = false, c = false, f = false, s = false, v = false;
    if (percProt >= 20) {
      score = score + 20;
      p = true;
    }
    if (percCarb >= 45) {
      score = score + 20;
      c = true;
    }
    if (percFat <= 35) {
      score = score + 20;
      f = true;
    }
    if (percSug <= 10) {
      score = score + 20;
      s = true;
    }
    if (nutrients['VITA_RAE']['quantity'] != 0 &&
        nutrients['VITC']['quantity'] != 0 &&
        nutrients['THIA']['quantity'] != 0 &&
        nutrients['NIA']['quantity'] != 0 &&
        nutrients['VITB6A']['quantity'] != 0) {
      score = score + 20;
      v = true;
    }
    if (score == 0) {
      return "Bad";
    }
    if (score == 20) {
      return "Quite Bad";
    }
    if (score == 40) {
      return "Balanced";
    }
    if (score == 60) {
      return "Good";
    }
    if (score == 80) {
      return "Quite Good";
    }
    if (score == 100) {
      return "Excellent";
    }
    return "";
  }


  String capitalizeInitials(String text) {
    List<String> words = text.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      } else {
        return '';
      }
    }).toList();
    return capitalizedWords.join(' ');
  }

}

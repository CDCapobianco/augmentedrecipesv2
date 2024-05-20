import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ultralytics_yolo_example/view/recipe_view.dart';

class ListRecipes extends StatefulWidget {
  final dynamic jsonResponse;

  const ListRecipes({Key? key, required this.jsonResponse}) : super(key: key);

  @override
  _ListRecipesState createState() => _ListRecipesState();

}

class _ListRecipesState extends State<ListRecipes> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
    _preloadImages();
  }

  Future<void> _preloadImages() async {
    final List<dynamic> recipes = widget.jsonResponse['hits'].take(5).toList();
    final List<String> imageUrls = recipes.map((recipe) => recipe['recipe']['image'] as String).toList();

    await Future.wait(imageUrls.map((imageUrl) => _loadImage(imageUrl)));
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadImage(String url) {
    final completer = Completer<void>();
    final image = Image.network(url);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          completer.complete();
        },
        onError: (dynamic error, StackTrace? stackTrace) {
          completer.completeError(error);
        },
      ),
    );
    return completer.future;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

Widget build(BuildContext context) {
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.of(context).pop(); 
        },
      ),
    ),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _buildRecipeContent(context),
  );
}


  Widget _buildRecipeContent(BuildContext context) {
    final List<dynamic> recipes = widget.jsonResponse['hits'].take(5).toList();
    final double dotsTopPosition = MediaQuery.of(context).size.height / 4 * 0.8;

    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Column(
        children: [
          const SizedBox(height: 100),
          Expanded(
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recipes.length,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
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
            height: dotsTopPosition,
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
    );
  }

  Widget _buildDot(int index) {
    final bool isActive = _currentPageIndex == index;
    final double dotSize = isActive ? 10.0 : 8.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.black.withOpacity(1.0) : const Color.fromARGB(255, 255, 246, 246).withOpacity(1.0),
      ),
    );
  }

  Widget _buildRecipeWidget(dynamic recipeData, BuildContext context) {
    final recipe = recipeData['recipe'];
    final imageBoxWidth = MediaQuery.of(context).size.width / 1.35;
    final imageBoxHeight = MediaQuery.of(context).size.height / 2.2;

    return GestureDetector(
      onTap: () {
        _showRecipeDetails(context, recipeData);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: imageBoxWidth,
            height: imageBoxHeight,
            decoration: BoxDecoration(
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    recipe['image'],
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AutoSizeText(
                          capitalizeInitials(recipe['label']),
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          minFontSize: 8,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        _buildRecipeDetail("", checkHealthiness(recipe['totalNutrients'], recipe['totalWeight'])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRecipeDetails(BuildContext context, dynamic recipeData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.easeInOut,
            reverseCurve: Curves.easeOut,
          )),
          child: _buildDialogContainer(context, recipeData),
        );
      },
    );
  }

  Widget _buildDialogContainer(BuildContext context, dynamic recipeData) {
    return RecipeDetailsPage(recipeData: recipeData);
  }

  Widget _buildRecipeDetail(String label, String value) {
    Color? healthScoreColor;
    String emojiLabel;

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
      healthScoreColor = Colors.white;
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
              style: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: healthScoreColor),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static String checkHealthiness(Map<String, dynamic> nutrients, double totalWeight) {
    double carbo = nutrients['CHOCDF']['quantity'] * 100 / totalWeight;
    double protein = nutrients['PROCNT']['quantity'] * 100 / totalWeight;
    double sugar = nutrients['SUGAR']['quantity'] * 100 / totalWeight;
    double fat = nutrients['FAT']['quantity'] * 100 / totalWeight;
    totalWeight = 100;
    double calorieProtein = protein * 4;
    double calorieCarbohydrates = carbo * 4;
    double calorieFat = fat * 9;
    double totalCalories = calorieProtein + calorieCarbohydrates + calorieFat;
    double percProt = (calorieProtein / totalCalories) * 100;
    double percCarb = (calorieCarbohydrates / totalCalories) * 100;
    double percFat = (calorieFat / totalCalories) * 100;

    double percSug = (sugar / totalWeight) * 100;
    double score = 0;

    if (percProt >= 20) {
      score = score + 20;
    }
    if (percCarb >= 45) {
      score = score + 20;
    }
    if (percFat <= 35) {
      score = score + 20;
    }
    if (percSug <= 10) {
      score = score + 20;
    }
    if (nutrients['VITA_RAE']['quantity'] != 0 &&
        nutrients['VITC']['quantity'] != 0 &&
        nutrients['THIA']['quantity'] != 0 &&
        nutrients['NIA']['quantity'] != 0 &&
        nutrients['VITB6A']['quantity'] != 0) {
      score = score + 20;
    }

    if (score == 0) {
      return "Bad";
    } else if (score == 20) {
      return "Quite Bad";
    } else if (score == 40) {
      return "Balanced";
    } else if (score == 60) {
      return "Good";
    } else if (score == 80) {
      return "Quite Good";
    } else if (score == 100) {
      return "Excellent";
    } else {
      return "";
    }
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

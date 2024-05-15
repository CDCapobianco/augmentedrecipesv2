import 'package:flutter/material.dart';
import 'package:ultralytics_yolo_example/app.dart';
import 'package:ultralytics_yolo_example/providers/query_provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calcola l'altezza del contenitore rosso in base al numero di elementi
    double containerHeight = MediaQuery.of(context).size.width * 0.8;

    // Se il numero di elementi supera 3, mantieni l'altezza fissa
    if (GlobalVariables.pickedList.length > 3) {
      //containerHeight = double.infinity;
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgroundImageRecipeView.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // ListView at the center
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: containerHeight, // Altezza dinamica del contenitore rosso
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                        'Your Last Pick',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 5.0,
                              color: Colors.black,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Lista degli elementi
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: GlobalVariables.pickedList.length,
                      itemBuilder: (context, index) {
                        final recipe = GlobalVariables.pickedList[index]['recipe'];
                        final label = recipe['label'];
                        final image = recipe['image'];
                        return GestureDetector(
                          onTap: () {
                            // Handle tap event as desired
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(label),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  image,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Button at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // Set text color to white
                  backgroundColor: Colors.red, // Set button color to red
                ),
                child: Text('Start Cooking'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

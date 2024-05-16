import 'package:flutter_test/flutter_test.dart';
import 'package:ultralytics_yolo_example/providers/recipes_list_controller.dart';
void main() {
  test('Test checkHealtiness method', () {
    final nutrients = {
      'CHOCDF': {'quantity': 10},
      'PROCNT': {'quantity': 20},
      'SUGAR': {'quantity': 5},
      'FAT': {'quantity': 15},
      'VITA_RAE': {'quantity': 100},
      'VITC': {'quantity': 10},
      'THIA': {'quantity': 5},
      'NIA': {'quantity': 15},
      'VITB6A': {'quantity': 20},
    };
    final totalWeight = 100.0;

    final healthScore = ListRecipes.checkHealtiness(nutrients, totalWeight);

    expect(healthScore, 'Good');
  });
}
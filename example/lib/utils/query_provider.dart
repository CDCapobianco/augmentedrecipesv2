import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlobalVariables {
  static ValueNotifier<String> listaNotifier = ValueNotifier<String>("");
  static dynamic pickedList = [];
}



class LabelNotifier extends StateNotifier<String> {
  LabelNotifier() : super('');

  void updateLabels(String newLabels) {
    state = newLabels;
  }
}

final labelProvider = StateNotifierProvider<LabelNotifier, String>((ref) {
  return LabelNotifier();
});

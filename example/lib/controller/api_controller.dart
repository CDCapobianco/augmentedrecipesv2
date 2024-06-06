import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ultralytics_yolo_example/view/camera_view.dart';

class ApiManager {
  static http.Client client = http.Client();
  static bool test = false;

  static Future<void> makeApiRequest(BuildContext context, String queryLabel) async {
    try {
      print('RICHIESTA API');
      final response = await client.get(Uri.parse(
        'https://api.edamam.com/api/recipes/v2?type=public&q=$queryLabel&app_id=c5fdcbaf&app_key=79089b3e02ca51e14bb5801915134401'));
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        //await file.writeAsString(response.body);
        CameraView.buildListRecipes(context, jsonResponse, test);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore durante la richiesta all\'API: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(key:Key('api_controller_json_error'),'Errore durante la verifica del file JSON: $e'),
        ),
      );
    }
  }
}

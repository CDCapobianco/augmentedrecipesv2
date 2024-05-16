import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:ultralytics_yolo_example/providers/recipes_list_controller.dart';

class ApiManager {
  
  ///_makeApiRequest permette di fare la chiamata remota all'api
  ///andrà modificata inserendo una query di request contenente
  ///gli ingredienti da ricercare separati dal''operatore '+'  di concatenazione
  static Future<void> makeApiRequest(BuildContext context, String queryLabel ) async {
    print(queryLabel);
    try {
      print('RICHIESTA API');
      final response = await http.get(Uri.parse(
          'https://api.edamam.com/api/recipes/v2?type=public&q=$queryLabel&app_id=c5fdcbaf&app_key=79089b3e02ca51e14bb5801915134401'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        //await file.writeAsString(response.body);
        ListRecipes.buildListRecipes(context, jsonResponse);
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
          content: Text('Errore durante la verifica del file JSON: $e'),
        ),
      );
    }
  }
}


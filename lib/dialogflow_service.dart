import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class DialogflowService {
  static const _dialogflowProjectId = 'chemistrychatbot-yegs'; // project ID
  static const _dialogflowLanguageCode = 'en'; // for english

  static Future<String> getDialogflowResponse(String query) async {
    try {
      final serviceAccount = ServiceAccountCredentials.fromJson(
        await rootBundle.loadString('assets/dialogflow_service_account.json'),
      );

      final client = await clientViaServiceAccount(
        serviceAccount,
        ['https://www.googleapis.com/auth/cloud-platform'],
      );

      final sessionId = DateTime.now().millisecondsSinceEpoch.toString();

      final url = Uri.parse(
        'https://dialogflow.googleapis.com/v2/projects/$_dialogflowProjectId/agent/sessions/$sessionId:detectIntent',
      );

      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "queryInput": {
            "text": {
              "text": query,
              "languageCode": _dialogflowLanguageCode,
            }
          }
        }),
      );

      client.close();

      if (response.statusCode != 200) {
        print('❌ Dialogflow Error: ${response.statusCode} ${response.body}');
        return 'Error: Unable to fetch response from Dialogflow.';
      }

      final data = json.decode(response.body);
      final message = data['queryResult']?['fulfillmentText'] ?? 'No response';

      return message;
    } catch (e) {
      print('❌ Exception occurred: $e');
      return 'Error: Something went wrong while connecting to Dialogflow.';
    }
  }
}


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

enum EmailCategory {
  companyBusinessStrategy,
  purelyPersonal,
  personalButProfessional,
  logisticArrangements,
  employmentArrangements,
  documentEditingCheckingCollaboration,
  emptyMessageDueToMissingAttachment,
  emptyMessage,
}

class EmailSorter {
  final String _apiUrl =
      "https://api-inference.huggingface.co/models/emarron/JARVIS-email-sorter";
  final String _apiToken;
  final Logger _logger = Logger('EmailSorter');
  final int minimumDelay = 100;
  final int adjustmentAmount = 100;

  EmailSorter({required String apiToken}) : _apiToken = apiToken {
    _initializeLogger();
  }

  void _initializeLogger() {
    Logger.root.level = Level.ALL; // Set this level as needed
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  EmailCategory _mapLabelToCategory(String label) {
    switch (label) {
      case 'LABEL_0':
        return EmailCategory.companyBusinessStrategy;
      case 'LABEL_1':
        return EmailCategory.purelyPersonal;
      case 'LABEL_2':
        return EmailCategory.personalButProfessional;
      case 'LABEL_3':
        return EmailCategory.logisticArrangements;
      case 'LABEL_4':
        return EmailCategory.employmentArrangements;
      case 'LABEL_5':
        return EmailCategory.documentEditingCheckingCollaboration;
      case 'LABEL_6':
        return EmailCategory.emptyMessageDueToMissingAttachment;
      case 'LABEL_7':
        return EmailCategory.emptyMessage;
      default:
        throw Exception('Unknown label: $label');
    }
  }

  String truncateText(String text, int maxLength) {
    return text.length > maxLength ? text.substring(0, maxLength) : text;
  }

  Future<EmailCategory?> getBestCategory(String emailText) async {
    var headers = {
      'Authorization': 'Bearer $_apiToken',
      'Content-Type': 'application/json',
    };

    bool requestSuccessful = false;
    int delayMilliseconds = 1000;

    while (!requestSuccessful) {
      var response = await http.post(
        Uri.parse(_apiUrl),
        headers: headers,
        body: json.encode({"inputs": emailText}),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var predictions = jsonResponse[0];
        var bestCategory = _selectBestCategory(predictions);
        requestSuccessful = true;
        return bestCategory;
      } else if (response.statusCode == 503) {
        var responseBody = json.decode(response.body);
        var estimatedWaitTime = responseBody['estimated_time'] ?? 10.0;
        _logger.info(
            'Model loading, waiting for $estimatedWaitTime seconds before retrying...');
        await Future.delayed(Duration(seconds: estimatedWaitTime.round()));
      } else {
        _logger.warning('Request failed with status: ${response.statusCode}.');
        _logger.warning('Response body: ${response.body}');
        requestSuccessful = true;
        return null;
      }

      await Future.delayed(Duration(milliseconds: delayMilliseconds));
      if (delayMilliseconds > minimumDelay) {
        delayMilliseconds -= adjustmentAmount;
      }
    }
  }

  EmailCategory? _selectBestCategory(List<dynamic> predictions) {
    EmailCategory? bestCategory;
    double highestProbability = 0.0;

    for (var prediction in predictions) {
      var category = _mapLabelToCategory(prediction['label']);

      if (category == EmailCategory.companyBusinessStrategy ||
          category == EmailCategory.purelyPersonal ||
          category == EmailCategory.logisticArrangements ||
          category == EmailCategory.documentEditingCheckingCollaboration ||
          category == EmailCategory.emptyMessage) {
        var probability = prediction['score'];

        if (probability > highestProbability) {
          highestProbability = probability;
          bestCategory = category;
        }
      } else if (category == EmailCategory.personalButProfessional) {
        var probability = prediction['score'];

        if (probability > highestProbability) {
          highestProbability = probability;
          bestCategory = EmailCategory.purelyPersonal;
        }
      }
    }

    return bestCategory;
  }
}

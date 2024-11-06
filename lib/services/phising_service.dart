import 'dart:convert';
import 'package:http/http.dart' as http;

class PhishingAnalysisResult {
  final bool isPhishing;
  final double probability;
  final String message;
  final String confidenceLevel;
  final Map<String, double> modelPredictions;

  PhishingAnalysisResult({
    required this.isPhishing,
    required this.probability,
    required this.message,
    required this.confidenceLevel,
    required this.modelPredictions,
  });

  factory PhishingAnalysisResult.fromJson(Map<String, dynamic> json) {
    Map<String, double> predictions = {};
    if (json['model_predictions'] != null) {
      json['model_predictions'].forEach((key, value) {
        if (value != null) {
          predictions[key] = value.toDouble();
        }
      });
    }

    return PhishingAnalysisResult(
      isPhishing: json['is_phishing'],
      probability: json['probability'].toDouble(),
      message: json['message'],
      confidenceLevel: json['confidence_level'],
      modelPredictions: predictions,
    );
  }
}

class PhishingService {
  static const String baseUrl =
      'http://192.168.0.106:5000'; // Use your host machine's IP address
  // Use 'http://localhost:5000' for iOS simulator

  static Future<bool> checkServerHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Server health check failed: $e');
      return false;
    }
  }

  static Future<PhishingAnalysisResult> analyzeEmail(
      String emailContent) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email_content': emailContent}),
      );

      if (response.statusCode == 200) {
        return PhishingAnalysisResult.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to analyze email: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }
}

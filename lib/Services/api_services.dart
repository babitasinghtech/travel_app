import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place.dart';

class ApiService {
  static const String baseUrl = "http://localhost:3000";

  // Fetch all places
  static Future<List<Place>> fetchPlaces() async {
    final response = await http.get(Uri.parse("$baseUrl/places"));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((place) => Place.fromJson(place)).toList();
    } else {
      throw Exception("Failed to load places");
    }
  }

  // Add a new place
  static Future<Place> addPlace(Place place) async {
    final response = await http.post(
      Uri.parse("$baseUrl/places"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(place.toJson()),
    );

    if (response.statusCode == 200) {
      return Place.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to add place");
    }
  }

  // Delete a place
  static Future<void> deletePlace(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/places/$id"));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete place");
    }
  }
}

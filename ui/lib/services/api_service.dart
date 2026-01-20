import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country_data.dart';
import '../models/policy_data.dart';

class ApiService {
  // static const String baseUrl =
  //     'https://verbose-waddle-v6pwj595p99r3wx6j-5000.app.github.dev/api'; // tanpa emu
  static const String baseUrl =
      'https://bayleigh-noncannibalistic-luciano.ngrok-free.dev/api'; // dengan emu(pakai ngrok)

  // Register
  static Future<Map<String, dynamic>> register(
    String username,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    return json.decode(response.body);
  }

  // Login
  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    return json.decode(response.body);
  }

  // Save country data
  static Future<Map<String, dynamic>> saveCountryData(
    CountryData countryData,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/country-data'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(countryData.toJson()),
    );

    return json.decode(response.body);
  }

  // Run simulation
  static Future<Map<String, dynamic>> runSimulation(
    int userId,
    int countryDataId,
    PolicyData policyData,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/simulate'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': userId,
        'country_data_id': countryDataId,
        ...policyData.toJson(),
      }),
    );

    return json.decode(response.body);
  }

  // Get history
  static Future<Map<String, dynamic>> getHistory(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/history/$userId'));

    return json.decode(response.body);
  }

  // Get user's country data
  static Future<Map<String, dynamic>> getUserCountryData(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/country-data/user/$userId'),
    );

    return json.decode(response.body);
  }
}

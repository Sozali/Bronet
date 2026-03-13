import 'dart:convert';
import 'package:http/http.dart' as http;

const _base = 'http://localhost:8080';

class BookingApi {
  static Future<Map<String, dynamic>?> createBooking({
    required String clientName,
    required String service,
    required String provider,
    required String specialist,
    required String date,
    required String time,
    required String price,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/bookings'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'clientName': clientName,
          'service': service,
          'provider': provider,
          'specialist': specialist,
          'date': date,
          'time': time,
          'price': price,
        }),
      ).timeout(const Duration(seconds: 5));

      if (res.statusCode == 201) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
    } catch (_) {
      // Server not running — silent fail, app still works offline
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> fetchBookings() async {
    try {
      final res = await http
          .get(Uri.parse('$_base/bookings'))
          .timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List<dynamic>;
        return list.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }

  static Future<int> getPoints(String client) async {
    try {
      final res = await http
          .get(Uri.parse('$_base/points?client=${Uri.encodeComponent(client)}'))
          .timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        return (data['points'] as num?)?.toInt() ?? 2840;
      }
    } catch (_) {}
    return 2840;
  }

  static Future<bool> addPoints(String client, int amount) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/points'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'client': client, 'amount': amount}),
      ).timeout(const Duration(seconds: 3));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<bool?> getBusinessOpen() async {
    try {
      final res = await http
          .get(Uri.parse('$_base/status'))
          .timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        return data['isOpen'] as bool?;
      }
    } catch (_) {}
    return null;
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';

class BookingApi {
  static final _db = Supabase.instance.client;

  // ─── BOOKINGS ──────────────────────────────────────────────

  static Future<Map<String, dynamic>?> createBooking({
    required String businessId,
    required String serviceId,
    required String date,
    required String time,
    required double price,
    String? notes,
  }) async {
    try {
      final uid = AuthService.currentUser?.id;
      if (uid == null) return null;
      final res = await _db.from('bookings').insert({
        'consumer_id': uid,
        'business_id': businessId,
        'service_id': serviceId,
        'booking_date': date,
        'booking_time': time,
        'price': price,
        'notes': notes,
        'status': 'pending',
        'points_earned': (price * 0.1).round(),
      }).select().single();
      return res;
    } catch (_) {
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchBookings() async {
    try {
      final uid = AuthService.currentUser?.id;
      if (uid == null) return [];
      final res = await _db
          .from('bookings')
          .select('*, businesses(name, address, avatar_url), services(name, duration_minutes)')
          .eq('consumer_id', uid)
          .order('booking_date', ascending: false);
      return List<Map<String, dynamic>>.from(res);
    } catch (_) {
      return [];
    }
  }

  static Future<bool> updateBookingStatus(String id, String status) async {
    try {
      await _db.from('bookings').update({'status': status}).eq('id', id);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> rescheduleBooking(String id, String date, String time) async {
    try {
      await _db.from('bookings').update({
        'status': 'rescheduled',
        'booking_date': date,
        'booking_time': time,
      }).eq('id', id);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ─── LOYALTY POINTS ────────────────────────────────────────

  static Future<int> getPoints() async {
    try {
      final uid = AuthService.currentUser?.id;
      if (uid == null) return 0;
      final res = await _db
          .from('profiles')
          .select('loyalty_points')
          .eq('id', uid)
          .single();
      return (res['loyalty_points'] as num?)?.toInt() ?? 0;
    } catch (_) {
      return 2840; // demo fallback
    }
  }

  static Future<bool> addPoints(int amount) async {
    try {
      final uid = AuthService.currentUser?.id;
      if (uid == null) return false;
      final current = await getPoints();
      await _db
          .from('profiles')
          .update({'loyalty_points': current + amount})
          .eq('id', uid);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ─── BUSINESSES ────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> fetchBusinesses({
    String? category,
    String? search,
  }) async {
    try {
      var query = _db
          .from('businesses')
          .select()
          .eq('is_active', true);
      if (category != null) query = query.eq('category', category);
      final res = await query.order('rating', ascending: false);
      final list = List<Map<String, dynamic>>.from(res);
      if (search != null && search.isNotEmpty) {
        final q = search.toLowerCase();
        return list
            .where((b) =>
                (b['name'] as String? ?? '').toLowerCase().contains(q) ||
                (b['category'] as String? ?? '').toLowerCase().contains(q))
            .toList();
      }
      return list;
    } catch (_) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> fetchServicesForBusiness(
      String businessId) async {
    try {
      final res = await _db
          .from('services')
          .select()
          .eq('business_id', businessId)
          .eq('is_active', true)
          .order('category');
      return List<Map<String, dynamic>>.from(res);
    } catch (_) {
      return [];
    }
  }

  // ─── DEALS ─────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> fetchDeals() async {
    try {
      final res = await _db
          .from('deals')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(res);
    } catch (_) {
      return [];
    }
  }

  // ─── REVIEWS ───────────────────────────────────────────────

  static Future<bool> submitReview({
    required String businessId,
    required String bookingId,
    required int rating,
    String? comment,
  }) async {
    try {
      final uid = AuthService.currentUser?.id;
      if (uid == null) return false;
      await _db.from('reviews').insert({
        'consumer_id': uid,
        'business_id': businessId,
        'booking_id': bookingId,
        'rating': rating,
        'comment': comment,
      });
      return true;
    } catch (_) {
      return false;
    }
  }
}

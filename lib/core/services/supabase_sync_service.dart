import 'package:supabase_flutter/supabase_flutter.dart';

/// Service für Cloud-Sync von Favoriten
class SupabaseSyncService {
  SupabaseSyncService._();
  static final SupabaseSyncService _instance = SupabaseSyncService._();

  factory SupabaseSyncService() => _instance;

  SupabaseClient get _client => Supabase.instance.client;

  /// Füge Favorit zur Cloud hinzu
  Future<void> addFavoriteToCloud(String userId, int quoteId) async {
    try {
      await _client.from('user_favorites').insert({
        'user_id': userId,
        'quote_id': quoteId,
      });
    } catch (e) {
      throw Exception('Fehler beim Speichern des Favoriten: $e');
    }
  }

  /// Entferne Favorit aus Cloud
  Future<void> removeFavoriteFromCloud(String userId, int quoteId) async {
    try {
      await _client
          .from('user_favorites')
          .delete()
          .eq('user_id', userId)
          .eq('quote_id', quoteId);
    } catch (e) {
      throw Exception('Fehler beim Löschen des Favoriten: $e');
    }
  }

  /// Hole alle Favoriten aus Cloud
  Future<List<int>> fetchFavoritesFromCloud(String userId) async {
    try {
      final response = await _client
          .from('user_favorites')
          .select('quote_id')
          .eq('user_id', userId);

      return List<int>.from(
        (response as List).map((item) => item['quote_id'] as int),
      );
    } catch (e) {
      throw Exception('Fehler beim Laden der Favoriten: $e');
    }
  }

  /// Synchronisiere lokale Favoriten zur Cloud (Merge)
  Future<void> syncLocalFavoritesToCloud({
    required String userId,
    required List<int> localFavoriteIds,
  }) async {
    try {
      // Hole bereits cloud-gespeicherte Favoriten
      final cloudFavorites = await fetchFavoritesFromCloud(userId);

      // Finde neue Favoriten (lokal aber nicht in Cloud)
      final newFavorites = localFavoriteIds
          .where((id) => !cloudFavorites.contains(id))
          .toList();

      // Füge neue Favoriten zur Cloud hinzu
      if (newFavorites.isNotEmpty) {
        final inserts = newFavorites.map((quoteId) {
          return {'user_id': userId, 'quote_id': quoteId};
        }).toList();

        await _client.from('user_favorites').insert(inserts);
      }

      // Optional: Entferne Favoriten die lokal gelöscht wurden
      // (Vorsicht: könnte User verwirren wenn auf mehreren Geräten)
      // final toDelete = cloudFavorites
      //     .where((id) => !localFavoriteIds.contains(id))
      //     .toList();
      // for (final quoteId in toDelete) {
      //   await removeFavoriteFromCloud(userId, quoteId);
      // }
    } catch (e) {
      throw Exception('Fehler beim Sync der Favoriten: $e');
    }
  }

  /// Stream für Favoriten (Realtime Updates von Cloud)
  Stream<List<int>> favoritesStream(String userId) {
    return _client
        .from('user_favorites')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) {
          return List<int>.from(data.map((item) => item['quote_id'] as int));
        });
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_factory_base/data/models/feature_item.dart';
import 'package:flutter_app_factory_base/data/models/profile_work.dart';
import 'package:flutter_app_factory_base/data/models/template_item.dart';
import 'package:flutter_app_factory_base/data/models/vip_plan.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// Top-level function so compute() can use it (must not be a closure or instance method).
Map<String, dynamic> _parseJsonIsolate(String raw) {
  final cleaned = raw.replaceAllMapped(
    RegExp(r'\\+u\{([0-9a-fA-F]+)\}'),
    (m) {
      final code = int.parse(m.group(1)!, radix: 16);
      return String.fromCharCode(code);
    },
  );
  return jsonDecode(cleaned) as Map<String, dynamic>;
}

class BabyDataLocalService {
  // Static cache: shared across all instances, persists for app session.
  static final Map<String, Map<String, dynamic>> _cache = {};

  /// Warm the cache for the given asset paths in parallel.
  /// Call during bootstrap so data is ready before HomeScreen opens.
  static Future<void> preload(List<String> paths) async {
    await Future.wait(paths.map(_preloadOne));
  }

  static Future<void> _preloadOne(String path) async {
    if (_cache.containsKey(path)) return;
    final raw = await rootBundle.loadString(path);
    final parsed = await compute(_parseJsonIsolate, raw);
    _cache[path] = parsed;
  }

  /// Fire-and-forget: downloads the first visible home images into disk cache
  /// so CachedNetworkImage serves them instantly when HomeScreen renders.
  static void warmImageCache() {
    const homeKey = 'assets/data/home_recommends.json';
    final cached = _cache[homeKey];
    if (cached == null) return;

    final cats = cached['data']['category_list'] as List<dynamic>? ?? [];
    final urls = <String>[];

    for (final cat in cats.take(3)) {
      final templates =
          (cat as Map<String, dynamic>)['templates'] as List<dynamic>? ?? [];
      for (final t in templates.take(6)) {
        final item = t as Map<String, dynamic>;
        // Prefer WebP (smallest), fall back to cover JPEG
        final url = (item['preview_webp_url'] as String? ?? '').isNotEmpty
            ? item['preview_webp_url'] as String
            : (item['cover_url'] as String? ?? '');
        if (url.isNotEmpty) urls.add(url);
      }
    }

    final manager = DefaultCacheManager();
    for (final url in urls.take(18)) {
      // ignore errors — this is best-effort prefetch only
      manager.downloadFile(url).ignore();
    }
  }

  Future<List<FeatureItem>> getHomeFunctions() async {
    final json = await _loadJson('assets/data/home_functions.json');
    final functions = json['data']['functions'] as List<dynamic>? ?? [];
    return functions.map((e) => FeatureItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<CategoryItem>> getHomeRecommends() async {
    final json = await _loadJson('assets/data/home_recommends.json');
    final list = json['data']['category_list'] as List<dynamic>? ?? [];
    return list.mapIndexed((i, e) => CategoryItem.fromJson(e as Map<String, dynamic>, isGrid: i == 0)).toList();
  }

  Future<List<CategoryItem>> getDanceTemplates() async {
    final json = await _loadJson('assets/data/dance_templates.json');
    final list = json['data']['category_list'] as List<dynamic>? ?? [];
    return list.mapIndexed((i, e) => CategoryItem.fromJson(e as Map<String, dynamic>, isGrid: false)).toList();
  }

  Future<List<CategoryItem>> getPhotoTemplates() async {
    final json = await _loadJson('assets/data/photo_templates.json');
    final list = json['data']['category_list'] as List<dynamic>? ?? [];
    return list.mapIndexed((i, e) => CategoryItem.fromJson(e as Map<String, dynamic>, isGrid: i == 0)).toList();
  }

  Future<List<ProfileWork>> getProfileWorks() async {
    final json = await _loadJson('assets/data/profile_works.json');
    final works = json['data']['works'] as List<dynamic>? ?? [];
    return works.map((e) => ProfileWork.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<(String headline, List<String> benefits, List<VipPlan> plans)> getVipPlans() async {
    final json = await _loadJson('assets/data/vip_plans.json');
    final data = json['data'] as Map<String, dynamic>;
    final headline = data['headline'] as String? ?? 'Unlock all features';
    final benefits = (data['benefits'] as List<dynamic>?)?.cast<String>() ?? [];
    final plans = (data['plans'] as List<dynamic>? ?? [])
        .map((e) => VipPlan.fromJson(e as Map<String, dynamic>))
        .toList();
    return (headline, benefits, plans);
  }

  Future<Map<String, dynamic>> _loadJson(String assetPath) async {
    if (_cache.containsKey(assetPath)) return _cache[assetPath]!;
    final raw = await rootBundle.loadString(assetPath);
    // Parse off the main thread for large files.
    final parsed = await compute(_parseJsonIsolate, raw);
    _cache[assetPath] = parsed;
    return parsed;
  }
}

extension _ListMapIndexed<T> on List<T> {
  List<R> mapIndexed<R>(R Function(int index, T item) f) {
    return [for (var i = 0; i < length; i++) f(i, this[i])];
  }
}

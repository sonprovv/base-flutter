import 'dart:convert';

import 'package:flutter_app_factory_base/data/models/profile_work.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileWorkDao {
  static const _key = 'profile_works_v1';

  Future<List<ProfileWork>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null) return [];
    final list = jsonDecode(jsonStr) as List<dynamic>;
    return list
        .map((e) => ProfileWork.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> add(ProfileWork work) async {
    final current = await getAll();
    final updated = [work, ...current];
    await _save(updated);
  }

  Future<void> update(ProfileWork updated) async {
    final current = await getAll();
    await _save(current.map((w) => w.id == updated.id ? updated : w).toList());
  }

  Future<void> remove(int id) async {
    final current = await getAll();
    await _save(current.where((w) => w.id != id).toList());
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<void> _save(List<ProfileWork> works) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(works.map((w) => w.toJson()).toList()));
  }
}

final profileWorkDaoProvider = Provider<ProfileWorkDao>((ref) => ProfileWorkDao());

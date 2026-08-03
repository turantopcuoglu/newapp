import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../models/recipe.dart';

/// Loads recipe content, preferring a downloaded bundle over the one shipped
/// in the app.
///
/// Content lives in JSON so it can be corrected and extended without a store
/// release: the app ships a bundle as a floor, and — when
/// `RECIPE_BUNDLE_URL` is configured — refreshes it from a versioned remote
/// bundle in the background. With no URL configured the app runs entirely on
/// bundled assets, so this is a no-op rather than a hard dependency.
class RecipeRepository {
  static const List<String> bundleFiles = [
    'assets/recipes/breakfast.json',
    'assets/recipes/lunch.json',
    'assets/recipes/dinner.json',
    'assets/recipes/snack.json',
  ];

  /// Remote bundle root configured at build time, e.g.
  /// `--dart-define=RECIPE_BUNDLE_URL=https://cdn.example.com/recipes`
  static const String configuredBaseUrl =
      String.fromEnvironment('RECIPE_BUNDLE_URL');

  static const String _cacheDirName = 'recipe_bundle';
  static const String _versionFileName = 'version.txt';

  final http.Client _client;
  final Future<Directory> Function() _cacheDirProvider;

  /// Bundle root this instance talks to. Empty disables remote refresh.
  final String baseUrl;

  RecipeRepository({
    http.Client? client,
    Future<Directory> Function()? cacheDirProvider,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _cacheDirProvider = cacheDirProvider ?? getApplicationSupportDirectory,
        baseUrl = baseUrl ?? configuredBaseUrl;

  bool get hasRemote => baseUrl.isNotEmpty;

  // ── Loading ────────────────────────────────────────────────────────────

  /// Recipes to run with: the cached remote bundle when a complete, valid one
  /// exists, otherwise the bundled assets.
  Future<List<Recipe>> loadLatest() async {
    final cached = await _loadFromCache();
    if (cached != null) return cached;
    return loadBundled();
  }

  /// Recipes shipped inside the app.
  static Future<List<Recipe>> loadBundled() async {
    final recipes = <Recipe>[];
    for (final path in bundleFiles) {
      final raw = await rootBundle.loadString(path);
      recipes.addAll(decodeRecipeList(raw));
    }
    return recipes;
  }

  /// Decodes a JSON array of recipe objects.
  static List<Recipe> decodeRecipeList(String raw) {
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Recipe>?> _loadFromCache() async {
    try {
      final dir = await _bundleDir();
      final recipes = <Recipe>[];
      for (final path in bundleFiles) {
        final file = File('${dir.path}/${_basename(path)}');
        if (!await file.exists()) return null; // partial cache: ignore it
        recipes.addAll(decodeRecipeList(await file.readAsString()));
      }
      return recipes.isEmpty ? null : recipes;
    } catch (e) {
      // A corrupt cache must never keep the app from starting.
      debugPrint('RecipeRepository: unusable cache ($e), using bundled assets');
      return null;
    }
  }

  /// Version string of the cached bundle, null when nothing is cached.
  Future<String?> cachedVersion() async {
    try {
      final file = File('${(await _bundleDir()).path}/$_versionFileName');
      return await file.exists() ? (await file.readAsString()).trim() : null;
    } catch (_) {
      return null;
    }
  }

  // ── Remote refresh ─────────────────────────────────────────────────────

  /// Downloads a newer bundle if the remote manifest advertises one.
  ///
  /// Returns true when a new bundle was stored. Never throws: a failed
  /// refresh leaves the previous content untouched — the app keeps working
  /// offline and simply retries next launch. The new content is picked up on
  /// the next start, so recipes never change under the user mid-session.
  Future<bool> refreshFromRemote() async {
    if (!hasRemote) return false;
    try {
      final manifestResponse =
          await _client.get(Uri.parse('$baseUrl/manifest.json'));
      if (manifestResponse.statusCode != 200) return false;

      final manifest =
          jsonDecode(manifestResponse.body) as Map<String, dynamic>;
      final remoteVersion = manifest['version']?.toString();
      if (remoteVersion == null || remoteVersion.isEmpty) return false;
      if (remoteVersion == await cachedVersion()) return false;

      // Download and validate everything before touching the cache, so a
      // half-broken release can't replace working content.
      final payloads = <String, String>{};
      for (final path in bundleFiles) {
        final name = _basename(path);
        final response =
            await _client.get(Uri.parse('$baseUrl/$name'));
        if (response.statusCode != 200) return false;
        final body = utf8.decode(response.bodyBytes);
        final parsed = decodeRecipeList(body); // throws on malformed JSON
        if (parsed.isEmpty) return false;
        payloads[name] = body;
      }

      final dir = await _bundleDir();
      if (!await dir.exists()) await dir.create(recursive: true);
      for (final entry in payloads.entries) {
        await File('${dir.path}/${entry.key}').writeAsString(entry.value);
      }
      await File('${dir.path}/$_versionFileName')
          .writeAsString(remoteVersion);
      return true;
    } catch (e) {
      debugPrint('RecipeRepository: bundle refresh failed ($e)');
      return false;
    }
  }

  Future<Directory> _bundleDir() async =>
      Directory('${(await _cacheDirProvider()).path}/$_cacheDirName');

  static String _basename(String path) => path.split('/').last;
}

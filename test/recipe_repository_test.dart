import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nutri_guide/data/recipe_repository.dart';

const testBaseUrl = 'https://example.test/recipes';

/// Minimal valid recipe payload for one bundle file.
String bundleJson(String id) => jsonEncode([
      {
        'id': id,
        'name': {'en': 'Test $id', 'tr': 'Test $id'},
        'description': {'en': 'd', 'tr': 'd'},
        'mealType': 'lunch',
        'cuisineIds': ['turkish'],
        'ingredientIds': ['tomato'],
        'macros': {'calories': 400},
        'steps': {
          'en': ['s'],
          'tr': ['s'],
        },
        'quantities': {
          'tomato': {'amount': 100, 'unit': 'g'},
        },
      }
    ]);

void main() {
  late Directory tempRoot;

  setUp(() async {
    tempRoot = await Directory.systemTemp.createTemp('recipe_repo_test');
  });

  tearDown(() async {
    if (await tempRoot.exists()) await tempRoot.delete(recursive: true);
  });

  Directory bundleDir() => Directory('${tempRoot.path}/recipe_bundle');

  Future<void> writeCache({
    required String version,
    required String marker,
  }) async {
    final dir = bundleDir();
    await dir.create(recursive: true);
    for (final path in RecipeRepository.bundleFiles) {
      await File('${dir.path}/${path.split('/').last}')
          .writeAsString(bundleJson(marker));
    }
    await File('${dir.path}/version.txt').writeAsString(version);
  }

  /// Repository pointed at a fake CDN unless [baseUrl] says otherwise.
  RecipeRepository repo(http.Client client, {String? baseUrl}) =>
      RecipeRepository(
        client: client,
        cacheDirProvider: () async => tempRoot,
        baseUrl: baseUrl ?? testBaseUrl,
      );

  /// Serves a manifest at [version] and valid bundles marked with [marker].
  http.Client goodCdn(String version, String marker) =>
      MockClient((request) async {
        if (request.url.path.endsWith('manifest.json')) {
          return http.Response(jsonEncode({'version': version}), 200);
        }
        return http.Response(bundleJson(marker), 200);
      });

  http.Client failingClient() =>
      MockClient((_) async => http.Response('boom', 500));

  group('cache preference', () {
    test('a complete cache is used instead of bundled assets', () async {
      await writeCache(version: '1', marker: 'cached1');

      final recipes = await repo(failingClient()).loadLatest();

      expect(recipes, hasLength(RecipeRepository.bundleFiles.length));
      expect(recipes.first.id, 'cached1');
    });

    test('a partial cache is ignored', () async {
      // Only one of the four files present: must not be treated as usable.
      final dir = bundleDir();
      await dir.create(recursive: true);
      await File('${dir.path}/breakfast.json')
          .writeAsString(bundleJson('partial'));

      expect(await repo(failingClient()).cachedVersion(), isNull);
    });
  });

  group('remote refresh', () {
    test('downloads and stores a newer bundle', () async {
      final r = repo(goodCdn('2', 'fresh'));

      expect(await r.refreshFromRemote(), isTrue);
      expect(await r.cachedVersion(), '2');
      expect((await r.loadLatest()).first.id, 'fresh');
    });

    test('skips the download when the version is unchanged', () async {
      await writeCache(version: '5', marker: 'existing');
      var bundleRequests = 0;
      final client = MockClient((request) async {
        if (request.url.path.endsWith('manifest.json')) {
          return http.Response(jsonEncode({'version': '5'}), 200);
        }
        bundleRequests++;
        return http.Response(bundleJson('should-not-happen'), 200);
      });

      expect(await repo(client).refreshFromRemote(), isFalse);
      expect(bundleRequests, 0);
      expect((await repo(client).loadLatest()).first.id, 'existing');
    });

    test('a corrupt payload leaves the existing cache untouched', () async {
      await writeCache(version: '1', marker: 'good');
      final client = MockClient((request) async {
        if (request.url.path.endsWith('manifest.json')) {
          return http.Response(jsonEncode({'version': '2'}), 200);
        }
        return http.Response('this is not json', 200);
      });

      expect(await repo(client).refreshFromRemote(), isFalse);
      expect(await repo(client).cachedVersion(), '1');
      expect((await repo(client).loadLatest()).first.id, 'good');
    });

    test('a partial download never half-replaces the cache', () async {
      await writeCache(version: '1', marker: 'good');
      // First bundle file succeeds, the next one 404s.
      var served = 0;
      final client = MockClient((request) async {
        if (request.url.path.endsWith('manifest.json')) {
          return http.Response(jsonEncode({'version': '2'}), 200);
        }
        served++;
        return served == 1
            ? http.Response(bundleJson('new'), 200)
            : http.Response('missing', 404);
      });

      expect(await repo(client).refreshFromRemote(), isFalse);
      expect(await repo(client).cachedVersion(), '1');
      // Every file must still be the old content, not a mix of both.
      final recipes = await repo(client).loadLatest();
      expect(recipes.every((r) => r.id == 'good'), isTrue);
    });

    test('a network failure leaves the existing cache untouched', () async {
      await writeCache(version: '1', marker: 'good');

      expect(await repo(failingClient()).refreshFromRemote(), isFalse);
      expect(await repo(failingClient()).cachedVersion(), '1');
    });

    test('a manifest without a version is rejected', () async {
      final client = MockClient((request) async =>
          http.Response(jsonEncode({'note': 'no version here'}), 200));

      expect(await repo(client).refreshFromRemote(), isFalse);
      expect(await repo(client).cachedVersion(), isNull);
    });

    test('does nothing when no bundle URL is configured', () async {
      var called = false;
      final client = MockClient((_) async {
        called = true;
        return http.Response('{}', 200);
      });

      final r = repo(client, baseUrl: '');
      expect(r.hasRemote, isFalse);
      expect(await r.refreshFromRemote(), isFalse);
      expect(called, isFalse);
    });
  });

  group('decodeRecipeList', () {
    test('parses a well-formed payload', () {
      final recipes = RecipeRepository.decodeRecipeList(bundleJson('ok'));
      expect(recipes.single.id, 'ok');
      expect(recipes.single.macros.calories, 400);
    });

    test('throws on malformed JSON so callers can reject the payload', () {
      expect(() => RecipeRepository.decodeRecipeList('not json'),
          throwsFormatException);
    });
  });
}

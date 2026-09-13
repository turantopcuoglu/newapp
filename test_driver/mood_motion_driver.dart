import 'dart:convert';
import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  final output = Directory('output/motion-refinement')
    ..createSync(recursive: true);
  await integrationDriver(
    onScreenshot: (name, bytes, [args]) async {
      await File('${output.path}/$name.png').writeAsBytes(bytes);
      return bytes.isNotEmpty;
    },
    responseDataCallback: (data) async {
      if (data == null) return;
      final concise = Map<String, dynamic>.from(data)..remove('screenshots');
      // Timeline events are large; retain the measured summaries for review.
      for (final value in concise.values) {
        if (value is Map) value.remove('timeline');
      }
      await File(
        '${output.path}/android-validation.json',
      ).writeAsString(const JsonEncoder.withIndent('  ').convert(concise));
    },
    writeResponseOnFailure: true,
  );
}

// load sample.html and run findTopSteamSellers, expect list of top steam sellers
import 'dart:io';
import 'package:test/test.dart';
import "package:dart_off_server/core.dart" as core;
import "package:path/path.dart" as p;

void main() {
  test('calculate', () {
      var rawHTMLPath = p.join(p.current, 'test', 'sample.html');
      // load rawHTML from rawHTMLPath
      File file = File(rawHTMLPath);
      var rawHTML = file.readAsStringSync();
      var steamSellers = core.parseSteamTopSellers(rawHTML);
      // greater than 5
      expect(steamSellers.length, greaterThan(5));
  });
}

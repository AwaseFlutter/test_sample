// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('AwaseAppの起動テスト', () {
    final searchFinder = find.byValueKey('search');
    final pageFinder = find.byValueKey('page');

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('検索ページを開くテスト', () async {
      await driver.tap(searchFinder);

      expect(await driver.getText(pageFinder), "1");
    });
  });
}
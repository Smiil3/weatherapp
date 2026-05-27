import 'package:flutter_test/flutter_test.dart';
import 'package:weatherapp/main.dart';

void main() {
  testWidgets('WeatherApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WeatherApp());
    expect(find.byType(WeatherApp), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:sephsuu_care/main.dart';

void main() {
  testWidgets('Landing screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Login'), findsOneWidget);
    expect(find.text("Don't have an account? Signup"), findsOneWidget);
  });
}

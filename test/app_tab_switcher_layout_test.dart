import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sephsuu_care/core/widgets/app_tab_switcher.dart';

void main() {
  for (final direction in Axis.values) {
    testWidgets('Equal-width $direction tabs work inside a scrolling screen', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 276,
                child: SingleChildScrollView(
                  child: AppTabSwitcher<String>(
                    value: 'what',
                    width: double.infinity,
                    expandItems: true,
                    itemDirection: direction,
                    height: direction == Axis.vertical ? 80 : 52,
                    itemPadding: const EdgeInsets.all(4),
                    options: const [
                      AppTabOption(
                        value: 'what',
                        label: 'What',
                        icon: Icon(Icons.lightbulb_outline),
                      ),
                      AppTabOption(
                        value: 'why',
                        label: 'Why',
                        icon: Icon(Icons.help_outline),
                      ),
                    ],
                    onChanged: (value) => selected = value,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final tabs = find.byType(InkWell);
      expect(
        tester.getSize(tabs.at(0)).width,
        tester.getSize(tabs.at(1)).width,
      );
      final icon = tester.getCenter(find.byIcon(Icons.lightbulb_outline));
      final label = tester.getCenter(find.text('What'));
      if (direction == Axis.vertical) {
        expect(icon.dy, lessThan(label.dy));
        expect(icon.dx, closeTo(label.dx, 0.1));
      } else {
        expect(icon.dx, lessThan(label.dx));
        expect(icon.dy, closeTo(label.dy, 0.1));
      }
      await tester.tap(find.text('Why'));
      expect(selected, 'why');
    });
  }
}

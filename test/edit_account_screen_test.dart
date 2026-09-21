import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sephsuu_care/core/widgets/app_date_picker.dart';
import 'package:sephsuu_care/core/widgets/app_input.dart';
import 'package:sephsuu_care/core/widgets/app_radio_group.dart';
import 'package:sephsuu_care/features/account/account_detail.dart';
import 'package:sephsuu_care/features/account/edit_account_screen.dart';

void main() {
  for (final detail in AccountDetail.values) {
    testWidgets('${detail.label} opens only its prefilled field', (
      tester,
    ) async {
      final value = switch (detail) {
        AccountDetail.fullName => 'Test User',
        AccountDetail.contactNumber => '09123456789',
        AccountDetail.dateOfBirth => '2000-02-15',
        AccountDetail.gender => 'female',
      };
      await tester.pumpWidget(
        MaterialApp(
          home: EditAccountScreen(detail: detail, initialValue: value),
        ),
      );
      expect(find.text('Edit Your ${detail.label}'), findsOneWidget);
      expect(
        find.textContaining('60 days', findRichText: true),
        detail == AccountDetail.fullName ? findsOneWidget : findsNothing,
      );
      if (detail == AccountDetail.fullName ||
          detail == AccountDetail.contactNumber) {
        expect(find.byType(AppInput), findsOneWidget);
        expect(find.text(value), findsOneWidget);
        expect(find.byType(AppDatePicker), findsNothing);
        expect(find.byType(AppRadioGroup<String>), findsNothing);
      } else if (detail == AccountDetail.dateOfBirth) {
        expect(find.byType(AppInput), findsNothing);
        expect(
          tester.widget<AppDatePicker>(find.byType(AppDatePicker)).value,
          DateTime(2000, 2, 15),
        );
      } else {
        expect(find.byType(AppInput), findsNothing);
        expect(
          tester
              .widget<AppRadioGroup<String>>(find.byType(AppRadioGroup<String>))
              .value,
          'female',
        );
        await tester.ensureVisible(find.text('Male'));
        await tester.tap(find.text('Male'));
        await tester.pump();
        expect(
          tester
              .widget<AppRadioGroup<String>>(find.byType(AppRadioGroup<String>))
              .value,
          'male',
        );
      }
      expect(tester.takeException(), isNull);
    });
  }
}

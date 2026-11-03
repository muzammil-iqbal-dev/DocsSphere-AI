import 'dart:ui' show Size;

import 'package:flutter_test/flutter_test.dart';
import 'package:docsphere_ai/main.dart';

void main() {
  testWidgets(
      'Owner demo opens the private workspace and can unhide a document',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1440, 960));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const DocSphereApp());
    await tester.tap(find.text('Open Owner demo'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Good '), findsOneWidget);

    await tester.tap(find.text('Hidden Documents'));
    await tester.pumpAndSettle();
    expect(find.text('Conference Notes'), findsOneWidget);
    await tester.tap(find.byTooltip('Unhide').first);
    await tester.pumpAndSettle();
    expect(find.text('Document Library'), findsWidgets);
    expect(find.text('Conference Notes'), findsOneWidget);
  });

  testWidgets('Admin demo has no route to private document content',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1440, 960));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const DocSphereApp());
    await tester.tap(find.text('Open Admin demo'));
    await tester.pumpAndSettle();
    expect(find.text('Admin Overview'), findsWidgets);
    expect(find.text('Manage Accounts'), findsOneWidget);
    expect(find.text('Academic Transcript'), findsNothing);
    expect(find.text('Passport'), findsNothing);
    expect(find.text('Document Library'), findsNothing);
  });

  testWidgets('Permanent document deletion requires two confirmations',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1440, 960));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const DocSphereApp());
    await tester.tap(find.text('Open Owner demo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Deleted Documents'));
    await tester.pumpAndSettle();
    expect(find.text('Old Membership Card'), findsOneWidget);

    await tester.tap(find.byTooltip('Deleted document actions').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete permanently').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('Confirmation 1 of 2'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Confirm permanent deletion'), findsOneWidget);
    await tester.tap(find.text('Delete permanently').last);
    await tester.pumpAndSettle();
    expect(find.text('Old Membership Card'), findsNothing);
  });
}

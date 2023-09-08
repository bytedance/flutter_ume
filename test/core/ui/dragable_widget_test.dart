import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ume/core/ui/dragable_widget.dart';

void main() {
  group('DragableWidget', () {
    testWidgets('constructor, drag widget, longpress and up', (tester) async {
      int moveCount = 0;

      final redDot = DragableGridView(
        ['TestA', 'TestB'],
        childAspectRatio: 0.85,
        canAccept: (oldIndex, newIndex) {
          return true;
        },
        dragCompletion: (dataList) {
          moveCount++;
        },
        itemBuilder: (context, dynamic data) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: Text(data as String),
          );
        },
      );
      await tester.pumpWidget(MaterialApp(
          home:
              Directionality(textDirection: TextDirection.ltr, child: redDot)));
      await tester.pumpAndSettle();
      expect(redDot, isNotNull);

      final Offset firstLocation = tester.getCenter(find.text('TestA'));
      final Offset secondLocation = tester.getCenter(find.text('TestB'));

      final TestGesture longPressGesture =
          await tester.startGesture(firstLocation, pointer: 0);
      await tester.pump(const Duration(seconds: 3));
      await longPressGesture.up();
      await tester.pump();

      final Offset firstLocation1 = tester.getCenter(find.text('TestA'));
      final Offset secondLocation1 = tester.getCenter(find.text('TestB'));
      expect(firstLocation1, firstLocation);
      expect(secondLocation1, secondLocation);

      final TestGesture dragGesture =
          await tester.startGesture(firstLocation, pointer: 0);
      await tester.pump(const Duration(seconds: 3));
      await dragGesture.moveTo(secondLocation);
      await dragGesture.up();
      await tester.pump();
      expect(moveCount, 1);
      final Offset firstLocation2 = tester.getCenter(find.text('TestA'));
      final Offset secondLocation2 = tester.getCenter(find.text('TestB'));
      expect(secondLocation2, firstLocation);
      expect(firstLocation2, secondLocation);
    });
  });
}

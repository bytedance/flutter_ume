import 'package:cyclop/src/widgets/picker/hex_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'HexTextField white',
    (WidgetTester tester) async {
      final app = MaterialApp(
        home: Scaffold(
          body: Center(
            child: HexColorField(
              color: Colors.white,
              withAlpha: true,
              hexFocus: FocusNode(),
              onColorChanged: (Color value) {},
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);

      expect(find.text('ffffffff'), findsOneWidget);
    },
  );

  testWidgets(
    'HexTextField black',
    (WidgetTester tester) async {
      final app = MaterialApp(
        home: Scaffold(
          body: Center(
            child: HexColorField(
              color: Colors.black,
              withAlpha: true,
              hexFocus: FocusNode(),
              onColorChanged: (Color value) {},
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);

      expect(find.text('ff000000'), findsOneWidget);
    },
  );

  testWidgets(
    'HexTextField black alpha0',
    (WidgetTester tester) async {
      final app = MaterialApp(
        home: Scaffold(
          body: Center(
            child: HexColorField(
              color: Colors.black.withOpacity(0),
              withAlpha: true,
              hexFocus: FocusNode(),
              onColorChanged: (Color value) {},
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);

      expect(find.text('00000000'), findsOneWidget);
    },
  );

  testWidgets(
    'HexTextField white alpha0',
    (WidgetTester tester) async {
      final app = MaterialApp(
        home: Scaffold(
          body: Center(
            child: HexColorField(
              color: Colors.white.withOpacity(0),
              withAlpha: true,
              hexFocus: FocusNode(),
              onColorChanged: (Color value) {},
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);

      expect(find.text('00ffffff'), findsOneWidget);
    },
  );
}

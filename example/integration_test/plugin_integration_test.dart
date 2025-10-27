import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_dev_catalyst/flutter_dev_catalyst.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('DevCatalyst Integration Tests', () {
    setUpAll(() async {
      // Initialize DevCatalyst before running tests
      await DevCatalyst.initialize(
        apiBaseUrl: 'https://jsonplaceholder.typicode.com',
        enableLogging: true,
        logLevel: LogLevel.debug,
      );
    });

    testWidgets('DevCatalyst initialization test', (WidgetTester tester) async {
      expect(DevCatalyst.isInitialized, true);
    });

    testWidgets('API Client GET request test', (WidgetTester tester) async {
      final response = await DevCatalyst.api.get('/posts/1');

      expect(response.success, true);
      expect(response.statusCode, 200);
      expect(response.data, isNotNull);
    });

    testWidgets('Storage service test', (WidgetTester tester) async {
      const testKey = 'integration_test_key';
      const testValue = 'integration_test_value';

      // Save
      await DevCatalyst.storage.saveString(testKey, testValue);

      // Retrieve
      final retrieved = DevCatalyst.storage.getString(testKey);

      expect(retrieved, equals(testValue));

      // Clean up
      await DevCatalyst.storage.remove(testKey);
    });

    testWidgets('Theme manager test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: DevCatalyst.theme.lightTheme,
          darkTheme: DevCatalyst.theme.darkTheme,
          home: const Scaffold(body: Center(child: Text('Theme Test'))),
        ),
      );

      await tester.pumpAndSettle();

      // Toggle theme
      await DevCatalyst.theme.toggle();
      await tester.pumpAndSettle();

      expect(DevCatalyst.theme.themeMode, isNotNull);
    });

    testWidgets('UI Components render test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CatalystButton.elevated(text: 'Test Button', onPressed: () {}),
                const CatalystTextField(label: 'Test Field'),
                const CatalystLoading(),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find widgets
      expect(find.text('Test Button'), findsOneWidget);
      expect(find.text('Test Field'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Button interaction test', (WidgetTester tester) async {
      bool buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CatalystButton.elevated(
              text: 'Press Me',
              onPressed: () {
                buttonPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap button
      await tester.tap(find.text('Press Me'));
      await tester.pumpAndSettle();

      expect(buttonPressed, true);
    });

    testWidgets('TextField validation test', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CatalystTextField(
              controller: controller,
              label: 'Email',
              type: CatalystTextFieldType.email,
              validators: [Validators.required, Validators.email],
              autoValidate: true,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField), 'invalid-email');
      await tester.pumpAndSettle();

      // Should show error
      expect(find.text('Please enter a valid email'), findsOneWidget);

      // Enter valid email
      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      await tester.pumpAndSettle();

      controller.dispose();
    });

    testWidgets('Loading indicator test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CatalystLoading(message: 'Loading data...')),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading data...'), findsOneWidget);
    });

    testWidgets('Error widget test', (WidgetTester tester) async {
      bool retryPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CatalystErrorWidget.simple(
              message: 'An error occurred',
              onRetry: () {
                retryPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('An error occurred'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      // Tap retry button
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(retryPressed, true);
    });

    testWidgets('Responsive builder test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveBuilder(
              builder: (context, screenSize) {
                return Text('Screen: ${screenSize.name}');
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should find the text widget
      expect(find.byType(Text), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:rijksbook/screens.dart';
import 'package:rijksbook/widgets.dart';

import '../mocks.dart';
import '../utils.dart';

void main() {
  group('HomePage', () {
    late MockRijksRepository repository;

    setUp(() {
      repository = MockRijksRepository();
    });

    tearDown(() {
      reset(repository);
    });

    testWidgets('Smoke test', (WidgetTester tester) async {
      when(() => repository.fetchAll(page: any(named: 'page'))).thenAnswer((_) async => dummyArtModelList);

      await mockNetworkImages(() async {
        await tester.pumpWidget(makeApp(home: const HomePage(), repository: repository));

        expect(find.byKey(LoadingSpinner.defaultKey), findsOneWidget);

        await tester.pump();

        expect(find.byType(SliverGrid), findsOneWidget);
      });
    });

    testWidgets('Item navigates to details page when tapped', (WidgetTester tester) async {
      when(() => repository.fetchAll(page: any(named: 'page'))).thenAnswer((_) async => dummyArtModelList);
      when(() => repository.fetch(any())).thenAnswer((_) async => dummyArtDetailModel);

      await mockNetworkImages(() async {
        await tester.pumpWidget(makeApp(home: const HomePage(), repository: repository));

        await tester.pump();

        await tester.tap(find.byKey(const ValueKey<String>('0')));

        await tester.pump();
        await tester.pump();

        expect(find.byType(DetailsPage), findsOneWidget);
      });
    });
  });
}

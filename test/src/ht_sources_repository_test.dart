// ignore_for_file: prefer_const_constructors, lines_longer_than_80_chars, prefer_const_literals_to_create_immutables

import 'package:flutter_test/flutter_test.dart';
import 'package:ht_shared/ht_shared.dart';
import 'package:ht_sources_client/ht_sources_client.dart';
import 'package:ht_sources_repository/ht_sources_repository.dart';
import 'package:mocktail/mocktail.dart';

// Create a mock class for HtSourcesClient
class MockHtSourcesClient extends Mock implements HtSourcesClient {}

void main() {
  group('HtSourcesRepository', () {
    late HtSourcesClient mockSourcesClient;
    late HtSourcesRepository repository;

    setUp(() {
      // Initialize mocks and repository before each test
      mockSourcesClient = MockHtSourcesClient();
      repository = HtSourcesRepository(sourcesClient: mockSourcesClient);
    });

    test('can be instantiated', () {
      // Check if the repository instance created in setUp is not null
      expect(repository, isNotNull);
    });

    // --- Test Data ---
    final tSource1 = Source(id: '1', name: 'Test Source 1');
    final tSource2 = Source(id: '2', name: 'Test Source 2');
    final tSourcesListFullPage = [tSource1, tSource2];
    final tSourcesListPartialPage = [tSource1];
    final tSourcesListEmpty = <Source>[];
    const tSourceId = '1';
    final tGenericException = Exception('Something went wrong');
    const tSourceCreateFailure = SourceCreateFailure('Create failed');
    const tSourceNotFoundException = SourceNotFoundException('Not found');
    const tSourceFetchFailure = SourceFetchFailure('Fetch failed');
    const tSourceUpdateFailure = SourceUpdateFailure('Update failed');
    const tSourceDeleteFailure = SourceDeleteFailure('Delete failed');

    // --- createSource Tests ---
    group('createSource', () {
      test('calls client.createSource and returns source on success', () async {
        // Arrange
        when(
          () => mockSourcesClient.createSource(source: tSource1),
        ).thenAnswer((_) async => tSource1);
        // Act
        final result = await repository.createSource(source: tSource1);
        // Assert
        expect(result, equals(tSource1));
        verify(
          () => mockSourcesClient.createSource(source: tSource1),
        ).called(1);
      });

      test('rethrows SourceCreateFailure from client', () async {
        // Arrange
        when(
          () => mockSourcesClient.createSource(source: tSource1),
        ).thenThrow(tSourceCreateFailure);
        // Act
        final call = repository.createSource(source: tSource1);
        // Assert
        await expectLater(call, throwsA(isA<SourceCreateFailure>()));
        verify(
          () => mockSourcesClient.createSource(source: tSource1),
        ).called(1);
      });

      test(
        'throws SourceCreateFailure on generic exception from client',
        () async {
          // Arrange
          when(
            () => mockSourcesClient.createSource(source: tSource1),
          ).thenThrow(tGenericException);
          // Act
          final call = repository.createSource(source: tSource1);
          // Assert
          await expectLater(call, throwsA(isA<SourceCreateFailure>()));
          verify(
            () => mockSourcesClient.createSource(source: tSource1),
          ).called(1);
        },
      );
    });

    // --- getSource Tests ---
    group('getSource', () {
      test('calls client.getSource and returns source on success', () async {
        // Arrange
        when(
          () => mockSourcesClient.getSource(id: tSourceId),
        ).thenAnswer((_) async => tSource1);
        // Act
        final result = await repository.getSource(id: tSourceId);
        // Assert
        expect(result, equals(tSource1));
        verify(() => mockSourcesClient.getSource(id: tSourceId)).called(1);
      });

      test('rethrows SourceNotFoundException from client', () async {
        // Arrange
        when(
          () => mockSourcesClient.getSource(id: tSourceId),
        ).thenThrow(tSourceNotFoundException);
        // Act
        final call = repository.getSource(id: tSourceId);
        // Assert
        await expectLater(call, throwsA(isA<SourceNotFoundException>()));
        verify(() => mockSourcesClient.getSource(id: tSourceId)).called(1);
      });

      test('rethrows SourceFetchFailure from client', () async {
        // Arrange
        when(
          () => mockSourcesClient.getSource(id: tSourceId),
        ).thenThrow(tSourceFetchFailure);
        // Act
        final call = repository.getSource(id: tSourceId);
        // Assert
        await expectLater(call, throwsA(isA<SourceFetchFailure>()));
        verify(() => mockSourcesClient.getSource(id: tSourceId)).called(1);
      });

      test(
        'throws SourceFetchFailure on generic exception from client',
        () async {
          // Arrange
          when(
            () => mockSourcesClient.getSource(id: tSourceId),
          ).thenThrow(tGenericException);
          // Act
          final call = repository.getSource(id: tSourceId);
          // Assert
          await expectLater(call, throwsA(isA<SourceFetchFailure>()));
          verify(() => mockSourcesClient.getSource(id: tSourceId)).called(1);
        },
      );
    });

    // --- getSources Tests ---
    group('getSources', () {
      test(
        'calls client.getSources without limit/startAfterId, returns PaginatedResponse with hasMore=false',
        () async {
          // Arrange
          when(
            () => mockSourcesClient.getSources(),
          ).thenAnswer((_) async => tSourcesListFullPage);

          // Act
          final result = await repository.getSources();

          // Assert
          expect(
            result,
            isA<PaginatedResponse<Source>>()
                .having((r) => r.items, 'items', tSourcesListFullPage)
                .having((r) => r.cursor, 'cursor', isNull)
                .having((r) => r.hasMore, 'hasMore', false),
          );
          verify(() => mockSourcesClient.getSources()).called(1);
        },
      );

      test(
        'calls client.getSources with limit, returns PaginatedResponse with hasMore=true and cursor when items.length == limit',
        () async {
          // Arrange
          const limit = 2;
          when(
            () => mockSourcesClient.getSources(limit: limit),
          ).thenAnswer((_) async => tSourcesListFullPage);

          // Act
          final result = await repository.getSources(limit: limit);

          // Assert
          expect(
            result,
            isA<PaginatedResponse<Source>>()
                .having((r) => r.items, 'items', tSourcesListFullPage)
                .having((r) => r.cursor, 'cursor', tSourcesListFullPage.last.id)
                .having((r) => r.hasMore, 'hasMore', true),
          );
          verify(() => mockSourcesClient.getSources(limit: limit)).called(1);
        },
      );

      test(
        'calls client.getSources with limit and startAfterId, returns PaginatedResponse with hasMore=false and no cursor when items.length < limit',
        () async {
          // Arrange
          const limit = 2;
          const startAfterId = '1';
          when(
            () => mockSourcesClient.getSources(
              limit: limit,
              startAfterId: startAfterId,
            ),
          ).thenAnswer((_) async => tSourcesListPartialPage);

          // Act
          final result = await repository.getSources(
            limit: limit,
            startAfterId: startAfterId,
          );

          // Assert
          expect(
            result,
            isA<PaginatedResponse<Source>>()
                .having((r) => r.items, 'items', tSourcesListPartialPage)
                .having((r) => r.cursor, 'cursor', isNull)
                .having((r) => r.hasMore, 'hasMore', false),
          );
          verify(
            () => mockSourcesClient.getSources(
              limit: limit,
              startAfterId: startAfterId,
            ),
          ).called(1);
        },
      );

      test(
        'calls client.getSources, returns PaginatedResponse with empty items, hasMore=false, and no cursor when client returns empty list',
        () async {
          // Arrange
          const limit = 5;
          when(
            () => mockSourcesClient.getSources(limit: limit),
          ).thenAnswer((_) async => tSourcesListEmpty);

          // Act
          final result = await repository.getSources(limit: limit);

          // Assert
          expect(
            result,
            isA<PaginatedResponse<Source>>()
                .having((r) => r.items, 'items', isEmpty)
                .having((r) => r.cursor, 'cursor', isNull)
                .having((r) => r.hasMore, 'hasMore', false),
          );
          verify(() => mockSourcesClient.getSources(limit: limit)).called(1);
        },
      );

      test('rethrows SourceFetchFailure from client', () async {
        // Arrange
        when(
          () => mockSourcesClient.getSources(),
        ).thenThrow(tSourceFetchFailure);
        // Act
        final call = repository.getSources();
        // Assert
        await expectLater(call, throwsA(isA<SourceFetchFailure>()));
        verify(() => mockSourcesClient.getSources()).called(1);
      });

      test(
        'throws SourceFetchFailure on generic exception from client',
        () async {
          // Arrange
          when(
            () => mockSourcesClient.getSources(),
          ).thenThrow(tGenericException);
          // Act
          final call = repository.getSources();
          // Assert
          await expectLater(call, throwsA(isA<SourceFetchFailure>()));
          verify(() => mockSourcesClient.getSources()).called(1);
        },
      );
    });

    // --- updateSource Tests ---
    group('updateSource', () {
      test(
        'calls client.updateSource and returns updated source on success',
        () async {
          // Arrange
          final updatedSource = Source(id: '1', name: 'Updated Source');
          when(
            () => mockSourcesClient.updateSource(source: updatedSource),
          ).thenAnswer((_) async => updatedSource);
          // Act
          final result = await repository.updateSource(source: updatedSource);
          // Assert
          expect(result, equals(updatedSource));
          verify(
            () => mockSourcesClient.updateSource(source: updatedSource),
          ).called(1);
        },
      );

      test('rethrows SourceNotFoundException from client', () async {
        // Arrange
        when(
          () => mockSourcesClient.updateSource(source: tSource1),
        ).thenThrow(tSourceNotFoundException);
        // Act
        final call = repository.updateSource(source: tSource1);
        // Assert
        await expectLater(call, throwsA(isA<SourceNotFoundException>()));
        verify(
          () => mockSourcesClient.updateSource(source: tSource1),
        ).called(1);
      });

      test('rethrows SourceUpdateFailure from client', () async {
        // Arrange
        when(
          () => mockSourcesClient.updateSource(source: tSource1),
        ).thenThrow(tSourceUpdateFailure);
        // Act
        final call = repository.updateSource(source: tSource1);
        // Assert
        await expectLater(call, throwsA(isA<SourceUpdateFailure>()));
        verify(
          () => mockSourcesClient.updateSource(source: tSource1),
        ).called(1);
      });

      test(
        'throws SourceUpdateFailure on generic exception from client',
        () async {
          // Arrange
          when(
            () => mockSourcesClient.updateSource(source: tSource1),
          ).thenThrow(tGenericException);
          // Act
          final call = repository.updateSource(source: tSource1);
          // Assert
          await expectLater(call, throwsA(isA<SourceUpdateFailure>()));
          verify(
            () => mockSourcesClient.updateSource(source: tSource1),
          ).called(1);
        },
      );
    });

    // --- deleteSource Tests ---
    group('deleteSource', () {
      test('calls client.deleteSource on success', () async {
        // Arrange
        when(
          () => mockSourcesClient.deleteSource(id: tSourceId),
        ).thenAnswer((_) async {});
        // Act
        await repository.deleteSource(id: tSourceId);
        // Assert
        verify(() => mockSourcesClient.deleteSource(id: tSourceId)).called(1);
      });

      test('rethrows SourceNotFoundException from client', () async {
        // Arrange
        when(
          () => mockSourcesClient.deleteSource(id: tSourceId),
        ).thenThrow(tSourceNotFoundException);
        // Act
        final call = repository.deleteSource(id: tSourceId);
        // Assert
        await expectLater(call, throwsA(isA<SourceNotFoundException>()));
        verify(() => mockSourcesClient.deleteSource(id: tSourceId)).called(1);
      });

      test('rethrows SourceDeleteFailure from client', () async {
        // Arrange
        when(
          () => mockSourcesClient.deleteSource(id: tSourceId),
        ).thenThrow(tSourceDeleteFailure);
        // Act
        final call = repository.deleteSource(id: tSourceId);
        // Assert
        await expectLater(call, throwsA(isA<SourceDeleteFailure>()));
        verify(() => mockSourcesClient.deleteSource(id: tSourceId)).called(1);
      });

      test(
        'throws SourceDeleteFailure on generic exception from client',
        () async {
          // Arrange
          when(
            () => mockSourcesClient.deleteSource(id: tSourceId),
          ).thenThrow(tGenericException);
          // Act
          final call = repository.deleteSource(id: tSourceId);
          // Assert
          await expectLater(call, throwsA(isA<SourceDeleteFailure>()));
          verify(() => mockSourcesClient.deleteSource(id: tSourceId)).called(1);
        },
      );
    });
  });
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:ht_sources_client/ht_sources_client.dart'; // Import client
import 'package:ht_sources_repository/ht_sources_repository.dart';
import 'package:mocktail/mocktail.dart'; // Import mocktail

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
    final tSource = Source(id: '1', name: 'Test Source');
    final tSourcesList = [tSource, Source(id: '2', name: 'Test Source 2')];
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
        when(() => mockSourcesClient.createSource(source: tSource))
            .thenAnswer((_) async => tSource);
        // Act
        final result = await repository.createSource(source: tSource);
        // Assert
        expect(result, equals(tSource));
        verify(() => mockSourcesClient.createSource(source: tSource)).called(1);
      });

      test('rethrows SourceCreateFailure from client', () async {
        // Arrange
        when(() => mockSourcesClient.createSource(source: tSource))
            .thenThrow(tSourceCreateFailure);
        // Act
        final call = repository.createSource(source: tSource);
        // Assert
        await expectLater(call, throwsA(isA<SourceCreateFailure>()));
        verify(() => mockSourcesClient.createSource(source: tSource)).called(1);
      });

      test('throws SourceCreateFailure on generic exception from client',
          () async {
        // Arrange
        when(() => mockSourcesClient.createSource(source: tSource))
            .thenThrow(tGenericException);
        // Act
        final call = repository.createSource(source: tSource);
        // Assert
        await expectLater(call, throwsA(isA<SourceCreateFailure>()));
        verify(() => mockSourcesClient.createSource(source: tSource)).called(1);
      });
    });

    // --- getSource Tests ---
    group('getSource', () {
      test('calls client.getSource and returns source on success', () async {
        // Arrange
        when(() => mockSourcesClient.getSource(id: tSourceId))
            .thenAnswer((_) async => tSource);
        // Act
        final result = await repository.getSource(id: tSourceId);
        // Assert
        expect(result, equals(tSource));
        verify(() => mockSourcesClient.getSource(id: tSourceId)).called(1);
      });

      test('rethrows SourceNotFoundException from client', () async {
        // Arrange
        when(() => mockSourcesClient.getSource(id: tSourceId))
            .thenThrow(tSourceNotFoundException);
        // Act
        final call = repository.getSource(id: tSourceId);
        // Assert
        await expectLater(call, throwsA(isA<SourceNotFoundException>()));
        verify(() => mockSourcesClient.getSource(id: tSourceId)).called(1);
      });

      test('rethrows SourceFetchFailure from client', () async {
        // Arrange
        when(() => mockSourcesClient.getSource(id: tSourceId))
            .thenThrow(tSourceFetchFailure);
        // Act
        final call = repository.getSource(id: tSourceId);
        // Assert
        await expectLater(call, throwsA(isA<SourceFetchFailure>()));
        verify(() => mockSourcesClient.getSource(id: tSourceId)).called(1);
      });

      test('throws SourceFetchFailure on generic exception from client',
          () async {
        // Arrange
        when(() => mockSourcesClient.getSource(id: tSourceId))
            .thenThrow(tGenericException);
        // Act
        final call = repository.getSource(id: tSourceId);
        // Assert
        await expectLater(call, throwsA(isA<SourceFetchFailure>()));
        verify(() => mockSourcesClient.getSource(id: tSourceId)).called(1);
      });
    });

    // --- getSources Tests ---
    group('getSources', () {
      test('calls client.getSources and returns list of sources on success',
          () async {
        // Arrange
        when(() => mockSourcesClient.getSources())
            .thenAnswer((_) async => tSourcesList);
        // Act
        final result = await repository.getSources();
        // Assert
        expect(result, equals(tSourcesList));
        verify(() => mockSourcesClient.getSources()).called(1);
      });

      test('returns empty list when client returns empty list', () async {
        // Arrange
        when(() => mockSourcesClient.getSources()).thenAnswer((_) async => []);
        // Act
        final result = await repository.getSources();
        // Assert
        expect(result, isEmpty);
        verify(() => mockSourcesClient.getSources()).called(1);
      });

      test('rethrows SourceFetchFailure from client', () async {
        // Arrange
        when(() => mockSourcesClient.getSources())
            .thenThrow(tSourceFetchFailure);
        // Act
        final call = repository.getSources();
        // Assert
        await expectLater(call, throwsA(isA<SourceFetchFailure>()));
        verify(() => mockSourcesClient.getSources()).called(1);
      });

      test('throws SourceFetchFailure on generic exception from client',
          () async {
        // Arrange
        when(() => mockSourcesClient.getSources()).thenThrow(tGenericException);
        // Act
        final call = repository.getSources();
        // Assert
        await expectLater(call, throwsA(isA<SourceFetchFailure>()));
        verify(() => mockSourcesClient.getSources()).called(1);
      });
    });

    // --- updateSource Tests ---
    group('updateSource', () {
      test('calls client.updateSource and returns updated source on success',
          () async {
        // Arrange
        when(() => mockSourcesClient.updateSource(source: tSource))
            .thenAnswer((_) async => tSource);
        // Act
        final result = await repository.updateSource(source: tSource);
        // Assert
        expect(result, equals(tSource));
        verify(() => mockSourcesClient.updateSource(source: tSource)).called(1);
      });

      test('rethrows SourceNotFoundException from client', () async {
        // Arrange
        when(() => mockSourcesClient.updateSource(source: tSource))
            .thenThrow(tSourceNotFoundException);
        // Act
        final call = repository.updateSource(source: tSource);
        // Assert
        await expectLater(call, throwsA(isA<SourceNotFoundException>()));
        verify(() => mockSourcesClient.updateSource(source: tSource)).called(1);
      });

      test('rethrows SourceUpdateFailure from client', () async {
        // Arrange
        when(() => mockSourcesClient.updateSource(source: tSource))
            .thenThrow(tSourceUpdateFailure);
        // Act
        final call = repository.updateSource(source: tSource);
        // Assert
        await expectLater(call, throwsA(isA<SourceUpdateFailure>()));
        verify(() => mockSourcesClient.updateSource(source: tSource)).called(1);
      });

      test('throws SourceUpdateFailure on generic exception from client',
          () async {
        // Arrange
        when(() => mockSourcesClient.updateSource(source: tSource))
            .thenThrow(tGenericException);
        // Act
        final call = repository.updateSource(source: tSource);
        // Assert
        await expectLater(call, throwsA(isA<SourceUpdateFailure>()));
        verify(() => mockSourcesClient.updateSource(source: tSource)).called(1);
      });
    });

    // --- deleteSource Tests ---
    group('deleteSource', () {
      test('calls client.deleteSource on success', () async {
        // Arrange
        when(() => mockSourcesClient.deleteSource(id: tSourceId))
            .thenAnswer((_) async {}); // Completes normally
        // Act
        await repository.deleteSource(id: tSourceId);
        // Assert
        verify(() => mockSourcesClient.deleteSource(id: tSourceId)).called(1);
      });

      test('rethrows SourceNotFoundException from client', () async {
        // Arrange
        when(() => mockSourcesClient.deleteSource(id: tSourceId))
            .thenThrow(tSourceNotFoundException);
        // Act
        final call = repository.deleteSource(id: tSourceId);
        // Assert
        await expectLater(call, throwsA(isA<SourceNotFoundException>()));
        verify(() => mockSourcesClient.deleteSource(id: tSourceId)).called(1);
      });

      test('rethrows SourceDeleteFailure from client', () async {
        // Arrange
        when(() => mockSourcesClient.deleteSource(id: tSourceId))
            .thenThrow(tSourceDeleteFailure);
        // Act
        final call = repository.deleteSource(id: tSourceId);
        // Assert
        await expectLater(call, throwsA(isA<SourceDeleteFailure>()));
        verify(() => mockSourcesClient.deleteSource(id: tSourceId)).called(1);
      });

      test('throws SourceDeleteFailure on generic exception from client',
          () async {
        // Arrange
        when(() => mockSourcesClient.deleteSource(id: tSourceId))
            .thenThrow(tGenericException);
        // Act
        final call = repository.deleteSource(id: tSourceId);
        // Assert
        await expectLater(call, throwsA(isA<SourceDeleteFailure>()));
        verify(() => mockSourcesClient.deleteSource(id: tSourceId)).called(1);
      });
    });
  });
}

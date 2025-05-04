# ht_sources_repository

> **Note:** This package is being archived. Please use the successor package [`ht-data-repository`](https://github.com/headlines-toolkit/ht-data-repository) instead.

A Dart package providing a repository layer for managing news sources data. It acts as an intermediary between the application's business logic and a data source client (`HtSourcesClient`).

## Features

*   Provides `HtSourcesRepository` for managing `Source` data.
*   Abstracts CRUD (Create, Read, Update, Delete) operations via an injected `HtSourcesClient`.
*   Handles specific data layer exceptions (`SourceFetchFailure`, `SourceNotFoundException`, `SourceCreateFailure`, `SourceUpdateFailure`, `SourceDeleteFailure`) and propagates them.
*   Designed with dependency injection for flexibility and testability.
*   Includes a comprehensive test suite with high coverage.

## Getting Started

### Prerequisites

*   Dart SDK: `^3.5.0` or later
*   Flutter SDK: `^3.24.0` or later (if used in a Flutter project)

### Installation

Since this package is hosted on GitHub, add it to your `pubspec.yaml` file under `dependencies`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  ht_sources_client: 
    git:
      url: https://github.com/headlines-toolkit/ht-sources-client.git
      # ref: <specific_commit_or_tag> # Optional: Pin to a specific version
```

Then, run `flutter pub get` or `dart pub get`.

## Usage

Import the necessary packages and instantiate the repository with a concrete implementation of `HtSourcesClient`.

```dart
import 'package:ht_sources_client/ht_sources_client.dart'; // Import client interface/models
import 'package:ht_sources_repository/ht_sources_repository.dart';

// Assume you have a concrete implementation or a mock client
// Example: HtInMemorySourcesClient implements HtSourcesClient
// final sourcesClient = HtInMemorySourcesClient();

// Or using a mock for testing:
class MockHtSourcesClient extends Mock implements HtSourcesClient {}
final mockSourcesClient = MockHtSourcesClient();

// Instantiate the repository
final sourcesRepository = HtSourcesRepository(sourcesClient: mockSourcesClient);

// Example: Fetching sources (now returns PaginatedResponse)
Future<void> fetchSources() async {
  try {
    // getSources now returns a PaginatedResponse
    final paginatedResult = await sourcesRepository.getSources(limit: 10); // Example with limit
    final sources = paginatedResult.items; // Access the list of sources
    final cursor = paginatedResult.cursor; // ID of the last item for next page
    final hasMore = paginatedResult.hasMore; // Indicates if more pages exist

    print('Fetched ${sources.length} sources.');
    if (hasMore) {
      print('More sources available. Next cursor: $cursor');
      // You can call getSources again with startAfterId: cursor to get the next page
    }
    // Process the sources...
  } on SourceFetchFailure catch (e) {
    print('Error fetching sources: ${e.message}');
  } catch (e) {
    print('An unexpected error occurred: $e');
  }
}

// Example: Creating a source
Future<void> createNewSource() async {
  final newSource = Source(name: 'New Example Source');
  try {
    final createdSource = await sourcesRepository.createSource(source: newSource);
    print('Created source with ID: ${createdSource.id}');
  } on SourceCreateFailure catch (e) {
    print('Error creating source: ${e.message}');
  } catch (e) {
    print('An unexpected error occurred: $e');
  }
}

// Example of how you might call these functions
void main() async {
  // Assume sourcesRepository is initialized elsewhere with a concrete HtSourcesClient
  // await fetchSources();
  // await createNewSource();
  print('Example usage functions defined. Ensure sourcesRepository is initialized.');
}

```


## License

This software is licensed under the [PolyForm Free Trial License 1.0.0](LICENSE). Please review the terms before use.

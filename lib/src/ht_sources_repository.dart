// ignore_for_file: lines_longer_than_80_chars

import 'package:ht_shared/ht_shared.dart';
import 'package:ht_sources_client/ht_sources_client.dart';

/// {@template ht_sources_repository}
/// A repository that manages news sources data.
///
/// It interacts with an underlying [HtSourcesClient] to perform CRUD operations
/// on [Source] objects.
/// {@endtemplate}
class HtSourcesRepository {
  /// {@macro ht_sources_repository}
  /// Requires an instance of [HtSourcesClient] to interact with the data source.
  const HtSourcesRepository({required HtSourcesClient sourcesClient})
    : _sourcesClient = sourcesClient;

  final HtSourcesClient _sourcesClient;

  /// Creates a new news source using the injected client.
  ///
  /// Takes a [Source] object to be created.
  /// Returns the created [Source], typically with a server-assigned ID.
  ///
  /// Throws a [SourceCreateFailure] if the creation operation fails in the client.
  /// Rethrows any other exceptions encountered during the process wrapped in [SourceCreateFailure].
  Future<Source> createSource({required Source source}) async {
    try {
      return await _sourcesClient.createSource(source: source);
    } on SourceCreateFailure {
      rethrow;
    } catch (e) {
      // Consider logging the error or stack trace here
      throw SourceCreateFailure(
        'An unexpected error occurred during source creation: $e',
      );
    }
  }

  /// Retrieves a specific news source by its unique [id] using the injected client.
  ///
  /// Throws a [SourceNotFoundException] if no source with the given [id] exists in the client.
  /// Throws a [SourceFetchFailure] for other fetch-related errors from the client.
  /// Rethrows any other exceptions encountered during the process wrapped in [SourceFetchFailure].
  Future<Source> getSource({required String id}) async {
    try {
      return await _sourcesClient.getSource(id: id);
    } on SourceNotFoundException {
      rethrow;
    } on SourceFetchFailure {
      rethrow;
    } catch (e) {
      // Consider logging the error or stack trace here
      throw SourceFetchFailure(
        'An unexpected error occurred fetching source $id: $e',
      );
    }
  }

  /// Retrieves a list of available news sources using the injected client,
  /// supporting pagination.
  ///
  /// [limit]: An optional parameter to specify the maximum number of sources
  ///          to fetch in this request.
  /// [startAfterId]: An optional parameter to fetch sources after the one
  ///                 with the specified ID for pagination.
  ///
  /// Returns a `PaginatedResponse<Source>` containing the list of sources
  /// for the current page, a cursor for the next page, and a flag indicating
  /// if more pages are available.
  /// Throws a [SourceFetchFailure] if the fetch operation fails in the client.
  /// Rethrows any other exceptions encountered during the process wrapped in [SourceFetchFailure].
  Future<PaginatedResponse<Source>> getSources({
    int? limit,
    String? startAfterId,
  }) async {
    try {
      final sources = await _sourcesClient.getSources(
        limit: limit,
        startAfterId: startAfterId,
      );

      // Determine if there are more items based on the limit.
      final hasMore = limit != null && sources.length == limit;

      // Determine the cursor for the next page.
      // Use the ID of the last item if there are more items and the list isn't empty.
      final cursor = hasMore && sources.isNotEmpty ? sources.last.id : null;

      return PaginatedResponse<Source>(
        items: sources,
        cursor: cursor,
        hasMore: hasMore,
      );
    } on SourceFetchFailure {
      rethrow;
    } catch (e) {
      // Consider logging the error or stack trace here
      throw SourceFetchFailure(
        'An unexpected error occurred fetching sources: $e',
      );
    }
  }

  /// Updates an existing news source using the injected client.
  ///
  /// Takes a [Source] object with an existing [Source.id] and updated fields.
  /// Returns the updated [Source].
  ///
  /// Throws a [SourceNotFoundException] if the source to update doesn't exist in the client.
  /// Throws a [SourceUpdateFailure] for other update-related errors from the client.
  /// Rethrows any other exceptions encountered during the process wrapped in [SourceUpdateFailure].
  Future<Source> updateSource({required Source source}) async {
    try {
      return await _sourcesClient.updateSource(source: source);
    } on SourceNotFoundException {
      rethrow;
    } on SourceUpdateFailure {
      rethrow;
    } catch (e) {
      // Consider logging the error or stack trace here
      throw SourceUpdateFailure(
        'An unexpected error occurred updating source ${source.id}: $e',
      );
    }
  }

  /// Deletes a news source by its unique [id] using the injected client.
  ///
  /// Throws a [SourceNotFoundException] if the source to delete doesn't exist in the client.
  /// Throws a [SourceDeleteFailure] for other delete-related errors from the client.
  /// Rethrows any other exceptions encountered during the process wrapped in [SourceDeleteFailure].
  Future<void> deleteSource({required String id}) async {
    try {
      await _sourcesClient.deleteSource(id: id);
    } on SourceNotFoundException {
      rethrow;
    } on SourceDeleteFailure {
      rethrow;
    } catch (e) {
      // Consider logging the error or stack trace here
      throw SourceDeleteFailure(
        'An unexpected error occurred deleting source $id: $e',
      );
    }
  }
}

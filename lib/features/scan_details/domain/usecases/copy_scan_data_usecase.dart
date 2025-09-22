import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/copy_scan_data_usecase.g.dart';

/// Use case for copying scan data to clipboard
@riverpod
class CopyScanDataUseCase extends _$CopyScanDataUseCase {
  @override
  FutureOr<void> build() async {
    return null; // Initial state
  }

  /// Copy a single number to clipboard
  Future<void> copyNumber(String number) async {
    try {
      await Clipboard.setData(ClipboardData(text: number));
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// Copy all numbers to clipboard as comma-separated values
  Future<void> copyAllNumbers(List<String> numbers) async {
    try {
      final text = numbers.join(', ');
      await Clipboard.setData(ClipboardData(text: text));
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// Copy scan result metadata to clipboard
  Future<void> copyScanMetadata({
    required String scanId,
    required DateTime timestamp,
    required double confidence,
    required int numberCount,
  }) async {
    try {
      final text =
          '''
Scan ID: $scanId
Timestamp: ${timestamp.toIso8601String()}
Confidence: ${(confidence * 100).toStringAsFixed(1)}%
Numbers Found: $numberCount''';

      await Clipboard.setData(ClipboardData(text: text));
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
}

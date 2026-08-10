import 'package:flutter/foundation.dart';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

class PdfDownloadService {
  /// Trigger official application form PDF download / print dialog in browser
  static void downloadApplicationForm({
    required String eventTitle,
    required String eventLocation,
    required String lastDate,
    required List<String> requiredDocs,
  }) {
    if (kIsWeb) {
      try {
        if (globalContext.has('downloadApplicationForm')) {
          globalContext.callMethod(
            'downloadApplicationForm'.toJS,
            eventTitle.toJS,
            eventLocation.toJS,
            lastDate.toJS,
            requiredDocs.map((e) => e.toJS).toList().toJS,
          );
        }
      } catch (e) {
        debugPrint('Error triggering application form PDF download: $e');
      }
    } else {
      debugPrint('PDF download triggered for $eventTitle');
    }
  }
}

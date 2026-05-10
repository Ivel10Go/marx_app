import 'package:supabase_flutter/supabase_flutter.dart';

class FeedbackSubmissionService {
  FeedbackSubmissionService._();

  static final FeedbackSubmissionService _instance =
      FeedbackSubmissionService._();

  factory FeedbackSubmissionService() => _instance;

  SupabaseClient get _client => Supabase.instance.client;

  Future<void> submitBugReport({
    required String title,
    required String description,
    required String steps,
    required String expected,
    required String? contact,
    required String platform,
    required String appVersion,
    required String appLocale,
    String? submittedBy,
    String? submitterEmail,
  }) async {
    await _insertSubmission(<String, dynamic>{
      'submission_type': 'bug_report',
      'title': title.isEmpty ? 'Bug Report' : title,
      'message': description,
      'details': <String, dynamic>{
        'steps_to_reproduce': steps,
        'expected_behavior': expected,
        'contact': contact,
      },
      'submitted_by': submittedBy,
      'submitter_email': submitterEmail,
      'platform': platform,
      'app_version': appVersion,
      'app_locale': appLocale,
    });
  }

  Future<void> submitQuoteSubmission({
    required String quote,
    required String author,
    required String? source,
    required String note,
    required String? contact,
    required String platform,
    required String appVersion,
    required String appLocale,
    String? submittedBy,
    String? submitterEmail,
  }) async {
    await _insertSubmission(<String, dynamic>{
      'submission_type': 'quote_submission',
      'title': author.isEmpty ? 'Zitat-Einreichung' : 'Zitat: $author',
      'quote_text': quote,
      'author': author,
      'source': source,
      'message': note,
      'details': <String, dynamic>{'contact': contact},
      'submitted_by': submittedBy,
      'submitter_email': submitterEmail,
      'platform': platform,
      'app_version': appVersion,
      'app_locale': appLocale,
    });
  }

  Future<void> _insertSubmission(Map<String, dynamic> payload) async {
    try {
      await _client.from('community_submissions').insert(payload);
    } catch (e) {
      throw Exception('Fehler beim Speichern der Einreichung: $e');
    }
  }
}

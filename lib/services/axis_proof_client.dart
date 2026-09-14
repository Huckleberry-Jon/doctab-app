import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/note.dart';

class AxisProofConflictException implements Exception {
  const AxisProofConflictException({
    required this.expectedRevision,
    required this.currentRevision,
    required this.currentNote,
  });

  final int expectedRevision;
  final int currentRevision;
  final Note currentNote;
}

class AxisProofClient {
  AxisProofClient({
    this.baseUrl = 'http://127.0.0.1:8787',
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Future<Note> fetchNote() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/proof/note'),
    );

    if (response.statusCode != 200) {
      throw StateError('Axis proof read failed: ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return _noteFromAxis(body['note'] as Map<String, dynamic>);
  }

  Future<Note> directEdit({
    required Note note,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/proof/direct-edit'),
      headers: const <String, String>{
        'content-type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'resourceId': note.id,
        'title': note.title,
        'content': note.content,
        'expectedRevision': note.revision,
      }),
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 409 && body['code'] == 'revision_conflict') {
      throw AxisProofConflictException(
        expectedRevision: body['expectedRevision'] as int,
        currentRevision: body['currentRevision'] as int,
        currentNote: _noteFromAxis(body['note'] as Map<String, dynamic>),
      );
    }

    if (response.statusCode != 200) {
      throw StateError('Axis proof direct edit failed: ${response.statusCode}');
    }

    return _noteFromAxis(body['note'] as Map<String, dynamic>);
  }

  Note _noteFromAxis(Map<String, dynamic> json) {
    final updatedAt = DateTime.parse(json['updatedAt'] as String);
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: updatedAt,
      updatedAt: updatedAt,
      revision: json['revision'] as int,
    );
  }
}

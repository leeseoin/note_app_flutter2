import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:note_app_flutter2/models/note.dart';

class NoteDatabase extends ChangeNotifier {
  final String baseUrl = 'http://127.0.0.1:8080/notes';

  List<Note> currentNotes = [];

  // CREATE - a note and save to db
  Future<void> addNote(String title, String content, String? img) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': title,
          'content': content, // JSON 형식 그대로 저장
          'img': img ?? "",
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        fetchNotes();
      } else {
        print('Failed to create note: ${response.body}');
        throw Exception('Failed to create note');
      }
    } catch (e) {
      print('Error adding note: $e');
    }
  }

  // READALL - notes from db
  Future<void> fetchNotes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response data: $data');
        final notes = (data['notes'] as List<dynamic>).map((note) {
          return Note(
            id: note['id'] as int?,
            title: note['title'] as String?,
            content: note['content'] as String,
            img: note['img'] as String?,
            createdAt: note['created_time'] != null
                ? DateTime.parse(note['created_time'] as String)
                : null,
            updatedAt: note['updated_time'] != null
                ? DateTime.parse(note['updated_time'] as String)
                : null,
          );
        }).toList();

        currentNotes = notes;
        notifyListeners();
      } else {
        print('Failed to fetch notes: ${response.body}');
        throw Exception('Failed to load notes');
      }
    } catch (e) {
      print('Failed to fetch notes: $e');
      throw Exception('Failed to fetch notes');
    }
  }

  // READ - note
  Future<void> fetchNoteById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response data: $data');
        final noteData = data['note_info'];
        final note = Note(
          id: noteData['id'] as int?,
          title: noteData['title'] as String?,
          content: noteData['content'] as String,
          img: noteData['img'] as String?,
          createdAt: noteData['created_time'] != null
              ? DateTime.parse(noteData['created_time'] as String)
              : null,
          updatedAt: noteData['updated_time'] != null
              ? DateTime.parse(noteData['updated_time'] as String)
              : null,
        );

        print('Fetched note: $note');
      } else {
        print('Failed to fetch note: ${response.body}');
        throw Exception('Failed to load note');
      }
    } catch (e) {
      print('Failed to fetch note: $e');
      throw Exception('Failed to fetch note');
    }
  }

  // UPDATE - a note in db
  Future<void> updateNote(
    int id,
    String title,
    String newContent,
    String? imgPath,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': title,
          'content': newContent,
          'img': imgPath ?? "",
        }),
      );

      debugPrint('Update request body: ${jsonEncode(<String, dynamic>{
            'title': title,
            'content': newContent,
            'img': imgPath ?? "",
          })}');

      if (response.statusCode == 200) {
        debugPrint('Update response: ${response.body}');
        await fetchNotes(); // 노트 목록을 다시 가져옵니다.
      } else {
        debugPrint('Failed to update note: ${response.body}');
        throw Exception('Failed to update note');
      }
    } catch (e) {
      debugPrint('Error updating note: $e');
      throw Exception('Failed to update note');
    }
  }

  // DELETE - a note from the db
  Future<void> deleteNote(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      fetchNotes();
    } else {
      throw Exception('Failed to delete note');
    }
  }

  // 마이그레이션 메서드 추가
  Future<void> migrateNotesToJson() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final notes = (data['notes'] as List<dynamic>);

        for (var note in notes) {
          final id = note['id'];
          final title = note['title'];
          final content = note['content'];
          final img = note['img'];

          if (!isJsonContent(content)) {
            final jsonContent = jsonEncode([
              {"insert": content}
            ]);
            await updateNote(id, title, jsonContent, img);
          }
        }
        debugPrint('Notes migration completed');
      } else {
        debugPrint('Failed to fetch notes for migration: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error during notes migration: $e');
    }
  }

  // Analyze and create a new note with the analysis result
  Future<void> analyzeAndCreateNote(Note note) async {
    final url = 'http://127.0.0.1:8080/api/notes/${note.id}/analyze';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'title': note.title,
        'content': note.content,
        'img': note.img,
        'requestText': 'Analyze this note'
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Create a new note with the analysis result
      await addNote(
        '${note.title} (analyzed by Gemini)',
        data['result'] ?? 'No result',
        null,
      );

      // Optionally refresh the notes list
      await fetchNotes();
    } else {
      debugPrint('Failed to analyze note: ${response.body}');
    }
  }

  bool isJsonContent(String content) {
    try {
      jsonDecode(content);
      return true;
    } catch (_) {
      return false;
    }
  }
}

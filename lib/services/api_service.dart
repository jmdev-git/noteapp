import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/note.dart';
import '../models/category.dart';

class ApiService {
  // For Android Emulator use 10.0.2.2, for Windows use localhost
  final String baseUrl = "http://localhost:5000/api"; 

  Future<List<Note>> getNotes() async {
    final response = await http.get(Uri.parse('$baseUrl/notes'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((note) => Note.fromJson(note)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  Future<Note> createNote(Note note) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notes'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': note.title,
        'content': note.content,
        'category': note.category?.id,
      }),
    );
    if (response.statusCode == 201) {
      return Note.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create note');
    }
  }

  Future<Note> updateNote(String id, Note note) async {
    final response = await http.put(
      Uri.parse('$baseUrl/notes/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': note.title,
        'content': note.content,
        'category': note.category?.id,
      }),
    );
    if (response.statusCode == 200) {
      return Note.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update note');
    }
  }

  Future<void> deleteNote(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/notes/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete note');
    }
  }

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((category) => Category.fromJson(category)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

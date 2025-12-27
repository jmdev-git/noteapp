import 'package:flutter/material.dart';
import 'dart:async';
import '../models/note.dart';
import '../models/category.dart';
import '../services/api_service.dart';

class NoteFormScreen extends StatefulWidget {
  final Note? note;

  const NoteFormScreen({super.key, this.note});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final ApiService apiService = ApiService();
  Category? _selectedCategory;
  List<Category> _categories = [];
  Timer? _debounce;
  Note? _currentNote;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _currentNote = widget.note;
    if (_currentNote != null) {
      _titleController.text = _currentNote!.title;
      _contentController.text = _currentNote!.content;
      _selectedCategory = _currentNote!.category;
    }
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      List<Category> categories = await apiService.getCategories();
      setState(() {
        _categories = categories;
        if (_currentNote != null && _currentNote!.category != null) {
           try {
              _selectedCategory = _categories.firstWhere((c) => c.id == _currentNote!.category!.id);
           } catch (e) {
               _selectedCategory = null;
           }
        }
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onContentChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      if (_currentNote != null) {
        _saveNote(isAutoSave: true);
      }
    });
  }

  Future<void> _saveNote({bool isAutoSave = false}) async {
    if (_formKey.currentState!.validate()) {
      if (isAutoSave) {
        setState(() => _isSaving = true);
      }

      Note note = Note(
        id: _currentNote?.id ?? '',
        title: _titleController.text,
        content: _contentController.text,
        category: _selectedCategory,
        createdAt: DateTime.now(),
      );

      try {
        if (_currentNote == null) {
          Note createdNote = await apiService.createNote(note);
          setState(() {
            _currentNote = createdNote;
          });
        } else {
          await apiService.updateNote(_currentNote!.id, note);
        }
        
        if (isAutoSave) {
           setState(() => _isSaving = false);
           // Optional: Show subtle indicator
        } else {
           Navigator.pop(context);
        }
      } catch (e) {
        if (isAutoSave) setState(() => _isSaving = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save note: $e')),
          );
        }
      }
    }
  }

  Future<void> _deleteNote() async {
    if (_currentNote == null) return;
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await apiService.deleteNote(_currentNote!.id);
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete note: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentNote == null ? 'Create Note' : 'Edit Note'),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          if (_currentNote != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteNote,
              tooltip: 'Delete Note',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter note title',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.title),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                onChanged: (_) => _onContentChanged(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<Category>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  hintText: 'Select a category',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.category),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: _categories.map((Category category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (Category? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                  _onContentChanged();
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _contentController,
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: 'Content',
                  hintText: 'Enter note content...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                onChanged: (_) => _onContentChanged(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => _saveNote(isAutoSave: false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                icon: const Icon(Icons.save),
                label: const Text('Save Note'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import '../../domain/repositories/notes_repository.dart';
import '../../domain/entities/note.dart';

class NotesProvider extends ChangeNotifier {
  final NotesRepository repository;

  // Constructor
  NotesProvider(this.repository);

  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  String _searchQuery = "";

  // Getter for all notes
  List<Note> get notes => _searchQuery.isEmpty ? _notes : _filteredNotes;

  // Getter for favorite notes
  List<Note> get favoriteNotes => _notes.where((note) => note.isFavorite).toList();

  // Load all notes from the repository
  Future<void> loadNotes() async {
    _notes = await repository.getAllNotes();
    _filteredNotes = _notes; // Initially, display all notes
    notifyListeners();
  }

  // Perform search based on the query
  void searchNotes(String query) {
    _searchQuery = query;
    _filteredNotes = _notes
        .where((note) =>
    note.title.toLowerCase().contains(query.toLowerCase()) ||
        note.content.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  // Add a new note
  Future<void> addNote(Note note) async {
    await repository.addNote(note);
    await loadNotes(); // Reload after adding a note
  }

  // Update an existing note
  Future<void> updateNote(Note note) async {
    await repository.updateNote(note);
    await loadNotes(); // Reload after updating a note
  }

  // Delete a note
  Future<void> deleteNote(int id) async {
    await repository.deleteNote(id);
    await loadNotes(); // Reload after deleting a note
  }

  // Toggle favorite status
  Future<void> toggleFavorite(Note note) async {
    await repository.toggleFavorite(note.id!, !note.isFavorite);
    await loadNotes(); // Reload after toggling favorite status
  }
}

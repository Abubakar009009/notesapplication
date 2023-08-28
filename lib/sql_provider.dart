import 'package:flutter/material.dart';
import 'package:notesapplication/bottom_sheet.dart';
import 'package:notesapplication/notes_model.dart';
import 'package:notesapplication/sql_helper.dart';

class SQLProvider extends ChangeNotifier {
  List<NotesModel> _journals = [];
  List<NotesModel> get journals => _journals;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = true;
  bool get isloading => _isLoading;

  void refreshJournals() async {
    final data = await SQLHelper.getItems();
    _journals = data.map((map) => NotesModel.fromMap(map)).toList();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteItem(BuildContext context, int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully deleted'),
      ),
    );
    refreshJournals();
  }

  void showForm(BuildContext context, int? id) async {
    if (id != null) {
      final existingNote = _journals.firstWhere((note) => note.id == id);
      _titleController.text = existingNote.title;
      _descriptionController.text = existingNote.description!;
    } else {
      _titleController.text = '';
      _descriptionController.text = '';
    }

    // showModalBottomSheet(
    //   context: context,
    //   builder: (_) => MyBottomSheet(
    //       id: id,
    //       dcontroller: _descriptionController,
    //       tcontroller: _titleController),
    // );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MyAddSheet(
          id: id,
          dcontroller: _descriptionController,
          tcontroller: _titleController,
        ),
      ),
    );
  }
}

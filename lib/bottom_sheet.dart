// ignore_for_file: use_build_context_synchronously, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:notesapplication/notes_model.dart';
import 'package:notesapplication/sql_helper.dart';
import 'package:notesapplication/sql_provider.dart';
import 'package:provider/provider.dart';

class MyAddSheet extends StatelessWidget {
  final int? id;
  final TextEditingController tcontroller;
  final TextEditingController dcontroller;

  const MyAddSheet({
    Key? key,
    required this.id,
    required this.tcontroller,
    required this.dcontroller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(id == null ? 'Add Note' : 'Edit Note'),
        backgroundColor: Colors.orange[200],
        actions: [
          IconButton(
            onPressed: () {
              tcontroller.clear();
              dcontroller.clear();
            },
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: tcontroller,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: 'Title',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dcontroller,
              maxLines: null,
              style: const TextStyle(fontSize: 16),
              decoration: const InputDecoration(
                hintText: 'Description',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                final title = tcontroller.text;
                final description = dcontroller.text;

                if (title.isNotEmpty) {
                  final note = NotesModel(
                    id: id ?? 0,
                    title: title,
                    description: description,
                    createdAt: DateTime.now(),
                  );

                  if (id == null) {
                    await SQLHelper.createItem(note.title, note.description);
                  } else {
                    await SQLHelper.updateItem(
                        note.id, note.title, note.description);
                  }

                  context.read<SQLProvider>().refreshJournals();
                  tcontroller.clear();
                  dcontroller.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                id == null ? 'Create Note' : 'Update Note',
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[200],
                textStyle: const TextStyle(fontSize: 18),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

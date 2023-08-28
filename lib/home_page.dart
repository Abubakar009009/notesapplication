import 'package:flutter/material.dart';
import 'package:notesapplication/sql_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<SQLProvider>().refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
      ),
      body: context.watch<SQLProvider>().isloading
          ? const Center(child: CircularProgressIndicator())
          : (context.watch<SQLProvider>().journals.isEmpty
              ? Center(
                  child: Image.asset('assets/01.png'),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: context.watch<SQLProvider>().journals.length,
                    itemBuilder: (context, index) {
                      final note = context.watch<SQLProvider>().journals[index];
                      return Card(
                        color: Colors.orange[200],
                        margin: const EdgeInsets.all(15),
                        child: ListTile(
                          title: Text(note.title),
                          subtitle: Text(note.description ?? ''),
                          leading: Text(note.id.toString()),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => context
                                      .read<SQLProvider>()
                                      .showForm(context, note.id),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => context
                                      .read<SQLProvider>()
                                      .deleteItem(context, note.id),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.read<SQLProvider>().showForm(context, null),
      ),
    );
  }
}

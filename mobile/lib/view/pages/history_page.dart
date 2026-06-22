import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/history_viewmodel.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<HistoryViewModel>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HistoryViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("History")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),

                hintText: "Cari nama file...",
              ),

              onChanged: vm.searchHistory,
            ),

            const SizedBox(height: 16),

            Expanded(
              child: vm.filteredHistories.isEmpty
                  ? const Center(child: Text("Belum ada history"))
                  : ListView.builder(
                      itemCount: vm.filteredHistories.length,

                      itemBuilder: (context, index) {
                        final history = vm.filteredHistories[index];

                        return Card(
                          child: ListTile(
                            title: Text(history.originalFile),

                            subtitle: Text(history.createdAt),

                            trailing: IconButton(
                              icon: const Icon(Icons.delete),

                              onPressed: () {
                                showDialog(
                                  context: context,

                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Hapus History"),

                                      content: const Text(
                                        "History project ini akan dihapus.",
                                      ),

                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },

                                          child: const Text("Cancel"),
                                        ),

                                        ElevatedButton(
                                          onPressed: () async {
                                            await vm.deleteHistory(history.id!);

                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                          },

                                          child: const Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/history_viewmodel.dart';
import '../../viewmodel/upload_viewmodel.dart';
import '../widgets/history/history_card.dart';
import '../widgets/history/history_delete_dialog.dart';
import '../widgets/history/history_empty.dart';
import '../widgets/history/history_search_bar.dart';
import 'processing_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool isSearching = false;

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
      backgroundColor: const Color(0xffF6F8FC),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              HistorySearchBar(
                isSearching: isSearching,

                onToggleSearch: () {
                  setState(() {
                    isSearching = !isSearching;
                  });

                  if (!isSearching) {
                    vm.searchHistory("");
                  }
                },

                onChanged: vm.searchHistory,
              ),

              const SizedBox(height: 20),

              Expanded(
                child: vm.filteredHistories.isEmpty
                    ? HistoryEmpty(isSearching: isSearching)
                    : ListView.builder(
                        itemCount: vm.filteredHistories.length,

                        itemBuilder: (context, index) {
                          final history = vm.filteredHistories[index];

                          return HistoryCard(
                            history: history,

                            onDownload: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Fitur download akan segera tersedia",
                                  ),
                                ),
                              );
                            },

                            onReprocess: () {
                              context
                                  .read<UploadViewModel>()
                                  .loadHistoryProject(history);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ProcessingPage(),
                                ),
                              );
                            },

                            onDelete: () {
                              showHistoryDeleteDialog(
                                context: context,
                                fileName: history.originalFile,
                                onDelete: () async {
                                  await vm.deleteHistory(history.id!);
                                },
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/upload_viewmodel.dart';
import 'result_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_hasStarted || !mounted) return;

      _hasStarted = true;
      _startProcessing();
    });
  }

  Future<void> _startProcessing() async {
    final vm = context.read<UploadViewModel>();

    // Upload baru wajib punya file lokal
    if (!vm.isReprocessing && vm.selectedLocalPath == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("File belum dipilih")));

      Navigator.pop(context);
      return;
    }

    final success = await vm.processCurrentProject();

    if (!mounted) return;

    if (success) {
      if (!context.mounted) return;

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const ResultPage()));

      return;
    }

    // gagal
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.maybeOf(context);

    messenger?.showSnackBar(SnackBar(content: Text(vm.status)));

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UploadViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const SizedBox(height: 36),

              const CircularProgressIndicator(),

              const SizedBox(height: 30),

              Text(
                vm.isReprocessing
                    ? "Reprocessing your project..."
                    : "Enhancing your audio...",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                vm.status,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              _buildStepItem(
                title: "Analyzing audio...",
                isDone: vm.status != "Uploading...",
              ),

              const SizedBox(height: 14),

              _buildStepItem(
                title: "Removing noise...",
                isDone: vm.status != "Uploading...",
              ),

              const SizedBox(height: 14),

              _buildStepItem(
                title: "Enhancing clarity...",
                isDone: vm.status != "Uploading...",
              ),

              const SizedBox(height: 14),

              _buildStepItem(
                title: "Finalizing output...",
                isDone: vm.isUploadSuccess,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem({required String title, required bool isDone}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isDone ? Colors.green.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_checked,
            color: isDone ? Colors.green : Colors.blue,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isDone ? Colors.green.shade800 : Colors.blue.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

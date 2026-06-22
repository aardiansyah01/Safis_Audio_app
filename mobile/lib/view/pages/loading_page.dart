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
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasStarted) {
      _hasStarted = true;
      _startProcessing();
    }
  }

  Future<void> _startProcessing() async {
    final vm = Provider.of<UploadViewModel>(context, listen: false);

    if (vm.selectedFilePath == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("File belum dipilih")));

      Navigator.pop(context);
      return;
    }

    final success = await vm.uploadFile(vm.selectedFilePath!);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResultPage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(vm.status)));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<UploadViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const SizedBox(height: 30),

              const CircularProgressIndicator(),

              const SizedBox(height: 32),

              const Text(
                "Enhancing your audio...",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/upload_viewmodel.dart';
import 'loading_page.dart';

class ProcessingPage extends StatelessWidget {
  const ProcessingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<UploadViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Audio Processing")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vm.selectedFile,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            Text(
              "Noise Reduction : ${vm.noiseReduction.toInt()}%",
              style: const TextStyle(fontSize: 16),
            ),

            Slider(
              value: vm.noiseReduction,
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: (value) {
                vm.setNoiseReduction(value);
              },
            ),

            const SizedBox(height: 20),

            Text(
              "Audio Enhancement : ${vm.audioEnhancement.toInt()}%",
              style: const TextStyle(fontSize: 16),
            ),

            Slider(
              value: vm.audioEnhancement,
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: (value) {
                vm.setAudioEnhancement(value);
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (vm.selectedFilePath == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("File belum dipilih")),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoadingPage()),
                  );
                },
                child: const Text("Process Audio"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

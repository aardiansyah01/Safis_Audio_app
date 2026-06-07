import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/upload_viewmodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> pickAndUpload(BuildContext context) async {
    final vm = Provider.of<UploadViewModel>(context, listen: false);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'mp4'],
    );

    if (result != null) {
      String path = result.files.single.path!;
      String filename = result.files.single.name;

      vm.setSelectedFile(filename);

      await vm.uploadFile(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<UploadViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Audio Enhancer")),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => pickAndUpload(context),
                child: const Text("Upload Audio / Video"),
              ),

              const SizedBox(height: 20),

              Text(vm.selectedFile, textAlign: TextAlign.center),

              const SizedBox(height: 20),

              if (vm.isLoading) const CircularProgressIndicator(),

              const SizedBox(height: 20),

              Text(vm.status, textAlign: TextAlign.center),

              const SizedBox(height: 20),

              if (vm.enhancedFile != null)
                ElevatedButton(
                  onPressed: () async {
                    await vm.playEnhancedAudio();
                  },
                  child: const Text("▶ Play Enhanced Audio"),
                ),

              const SizedBox(height: 10),

              if (vm.isPlaying)
                ElevatedButton(
                  onPressed: () async {
                    await vm.stopAudio();
                  },
                  child: const Text("⏹ Stop Audio"),
                ),

              if (vm.enhancedFile != null)
                ElevatedButton(
                  onPressed: () async {
                    await vm.downloadEnhancedFile();
                  },
                  child: const Text("Download Enhanced Audio"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

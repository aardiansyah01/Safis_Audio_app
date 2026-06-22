import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/upload_viewmodel.dart';
import 'processing_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> pickFile(BuildContext context) async {
    final vm = Provider.of<UploadViewModel>(context, listen: false);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'mp4'],
    );

    if (result != null) {
      String path = result.files.single.path!;
      String filename = result.files.single.name;

      vm.setSelectedFile(filename);
      vm.setSelectedFilePath(path);
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
                onPressed: () => pickFile(context),

                child: const Text("Upload Audio / Video"),
              ),

              const SizedBox(height: 20),

              Text(vm.selectedFile, textAlign: TextAlign.center),

              const SizedBox(height: 20),

              if (vm.selectedFile != "Tidak ada file dipilih")
                SizedBox(
                  width: 220,

                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProcessingPage(),
                        ),
                      );
                    },

                    child: const Text("Continue"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

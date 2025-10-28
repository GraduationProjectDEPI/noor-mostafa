import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'service.dart';

class ServicePage extends StatelessWidget {
  ServicePage({super.key});
  final controller = Get.put(TextRecognitionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'take your image',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(67, 45, 215, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ------- choose image button -------------
            ElevatedButton(
              onPressed: () => controller.pickImageAndExtractText(
                source: ImageSource.gallery,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(67, 45, 215, 1),
                foregroundColor: Colors.white,
              ),
              child: const Text('choose image'),
            ),
            //  ------ take photo button ---------
            ElevatedButton(
              onPressed: () => controller.pickImageAndExtractText(
                source: ImageSource.camera,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(67, 45, 215, 1),
                foregroundColor: Colors.white,
              ),
              child: const Text('take photo'),
            ),

            const SizedBox(height: 20),

            // -------------- view image choosed -----------------
            Obx(() {
              if (controller.image.value == null) {
                return const Text('thers is no image choosed');
              } else {
                return Image.file(controller.image.value!, height: 200);
              }
            }),

            const SizedBox(height: 20),

            const Text(
              'numbers extracted',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            // ------- view numbers extracted ---------------
            Obx(
              () => Text(
                controller.extractedText.value.isEmpty
                    ? 'there is no numbers extracted'
                    : controller.extractedText.value,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

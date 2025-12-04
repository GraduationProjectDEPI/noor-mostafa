import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'service.dart';

class ServicePage extends StatefulWidget {
  ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  final controller = Get.put(TextRecognitionController());
  int reading = 0;

  int consumption = 0;

  var bill = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('take your image')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ------- choose image button -------------
            ElevatedButton(
              onPressed: () async {
                await controller.pickImageAndExtractText(
                  source: ImageSource.gallery,
                );
                reading = int.tryParse(controller.extractedText.value) ?? 0;
                consumption = await onNewReading(reading);
                print("🔥 Consumption = $consumption");
                bill.value = await calculateTotalBill(consumption);
              },
              child: const Text('choose image'),
            ),
            //  ------ take photo button ---------
            ElevatedButton(
              onPressed: () async {
                await controller.pickImageAndExtractText(
                  source: ImageSource.camera,
                );
                reading = int.tryParse(controller.extractedText.value) ?? 0;

                consumption = await onNewReading(reading);
              },
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
            Obx(() => Text('${bill.value}')),
          ],
        ),
      ),
    );
  }
}

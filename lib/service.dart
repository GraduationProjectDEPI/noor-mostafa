import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextRecognitionController extends GetxController {
  final Rx<File?> image = Rx<File?>(null);
  final RxString extractedText = ''.obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageAndExtractText({required ImageSource source}) async {
    final picked = await _picker.pickImage(
      source: source,
    ); // for open galary or take a photo
    if (picked == null) return;

    image.value = File(picked.path); // change image to file

    final inputImage = InputImage.fromFile(
      image.value!,
    ); // ml kit need the image kind is InputImage
    // ------ extract text from image;
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText = await textRecognizer.processImage(
      inputImage,
    );

    final allText = recognizedText.text;
    // ----------- extract the numbers only -----------
    final numbers = RegExp(
      r'\d+',
    ).allMatches(allText).map((m) => m.group(0)).join(' ');

    extractedText.value = numbers;

    await textRecognizer.close();
  }
}

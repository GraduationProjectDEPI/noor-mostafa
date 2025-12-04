import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'main.dart';

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

// ----------------- detect if in the same month --------------------
bool isSameMonth() {
  var box = Hive.box('meter_box');

  int? savedMonth = box.get('startMonth');
  int? savedYear = box.get('startYear');

  final now = DateTime.now();

  if (savedMonth == null || savedYear == null) {
    return false; // أول استخدام للتطبيق
  }

  return savedMonth == now.month && savedYear == now.year;
}

//---------------- when the user add new read in the same month or in new month
// it calculate the consumption for the consumption related to the first read in the month -----------
Future<int> onNewReading(int currentReading) async {
  var box = Hive.box('meter_box');
  final now = DateTime.now();

  // 1) لو أول مرة أو شهر جديد → خزّن أول قراءة جديدة
  if (!isSameMonth()) {
    await box.put('startReading', currentReading);
    await box.put('startMonth', now.month);
    await box.put('startYear', now.year);

    print("🟢 شهر جديد → تم حفظ أول قراءة جديدة: $currentReading");
    return 0;
  }

  // 2) لو نفس الشهر → احسب الاستهلاك
  int startReading = box.get('startReading');

  int consumption = currentReading - startReading;

  return consumption;
}

//------------ calculate the total bill related to consumption --------------
Future<double> calculateTotalBill(int consumption) async {
  try {
    // 1) هات كل الشرائح مرتّبة
    final rates = await cloud
        .from('Electricity Rates')
        .select()
        .order('range_start', ascending: true);

    if (rates == null || rates.isEmpty) {
      throw Exception("No rates found");
    }

    double total = 0;
    int remaining = consumption;

    for (var rate in rates) {
      int start = rate['range_start'];
      int end = rate['range_end'];
      double price = (rate['price_per_kwh'] as num).toDouble();

      if (remaining <= 0) break;

      // كام وحدة جوّه الشريحة دي؟
      int maxUnitsInThisRange = end - start + 1;

      // وحدات اليوزر اللي تقع داخل الشريحة دي
      int unitsInThisTier = remaining > maxUnitsInThisRange
          ? maxUnitsInThisRange
          : remaining;

      // جمع سعرها
      total += unitsInThisTier * price;

      // قلّل المتبقي
      remaining -= unitsInThisTier;
    }

    return total;
  } catch (e) {
    print("⚠️ Error calculating bill: $e");
    return 0.0;
  }
}

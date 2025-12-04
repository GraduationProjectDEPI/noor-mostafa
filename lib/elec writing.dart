// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// class VoiceInputField extends StatefulWidget {
//   const VoiceInputField({super.key});
//
//   @override
//   State<VoiceInputField> createState() => _VoiceInputFieldState();
// }
//
// class _VoiceInputFieldState extends State<VoiceInputField> {
//   final TextEditingController _controller = TextEditingController();
//   late stt.SpeechToText _speech;
//   bool _isListening = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//   }
//
//   void _listen() async {
//     if (!_isListening) {
//       bool available = await _speech.initialize();
//       if (available) {
//         setState(() => _isListening = true);
//         _speech.listen(
//           onResult: (result) {
//             setState(() {
//               _controller.text = result.recognizedWords.replaceAll(
//                 RegExp(r'[^0-9]'),
//                 '',
//               ); // يحتفظ بالأرقام فقط
//             });
//           },
//         );
//       }
//     } else {
//       setState(() => _isListening = false);
//       _speech.stop();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Voice Number Input')),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(
//               controller: _controller,
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 FilteringTextInputFormatter
//                     .digitsOnly, // ← السطر اللي بيمنع أي حاجة غير أرقام
//               ],
//               decoration: const InputDecoration(
//                 labelText: 'Meter Reading',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             FloatingActionButton(
//               onPressed: _listen,
//               child: Icon(_isListening ? Icons.mic : Icons.mic_none),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'calculateBill.dart';

class VoiceInputField extends StatefulWidget {
  const VoiceInputField({super.key});

  @override
  State<VoiceInputField> createState() => _VoiceInputFieldState();
}

class _VoiceInputFieldState extends State<VoiceInputField> {
  final TextEditingController _oldReadingController = TextEditingController();
  final TextEditingController _newReadingController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  double? _billAmount;
  int? _consumption;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }
  //
  // double calculateBill(int units) {
  //   double cost = 0;
  //   if (units <= 50) {
  //     cost = units * 0.48;
  //   } else if (units <= 100) {
  //     cost = (50 * 0.48) + ((units - 50) * 0.58);
  //   } else if (units <= 200) {
  //     cost = (50 * 0.48) + (50 * 0.58) + ((units - 100) * 0.77);
  //   } else if (units <= 350) {
  //     cost = (50 * 0.48) + (50 * 0.58) + (100 * 0.77) + ((units - 200) * 1.06);
  //   } else if (units <= 650) {
  //     cost =
  //         (50 * 0.48) +
  //         (50 * 0.58) +
  //         (100 * 0.77) +
  //         (150 * 1.06) +
  //         ((units - 350) * 1.28);
  //   } else {
  //     cost =
  //         (50 * 0.48) +
  //         (50 * 0.58) +
  //         (100 * 0.77) +
  //         (150 * 1.06) +
  //         (300 * 1.28) +
  //         ((units - 650) * 1.45);
  //   }
  //   return cost;
  // }

  void _listen(TextEditingController controller) async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          localeId: 'ar_EG',
          onResult: (result) {
            final numbers = result.recognizedWords.replaceAll(
              RegExp(r'[^0-9]'),
              '',
            );
            setState(() {
              controller.text = numbers;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _calculateBill() {
    final oldReading = int.tryParse(_oldReadingController.text);
    final newReading = int.tryParse(_newReadingController.text);

    if (oldReading != null && newReading != null && newReading >= oldReading) {
      final consumption = newReading - oldReading;
      final bill = calculateBill(consumption);
      setState(() {
        _consumption = consumption;
        _billAmount = bill;
      });
    } else {
      setState(() {
        _billAmount = null;
        _consumption = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '⚠️ تأكد من إدخال قراءتين صحيحتين (والقراءة الجديدة أكبر من القديمة)',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Electricity Bill Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // قراءة أول الشهر
              TextField(
                controller: _oldReadingController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ], // ⛔ أرقام فقط
                decoration: InputDecoration(
                  labelText: 'Old Reading (Start of Month)',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                    onPressed: () => _listen(_oldReadingController),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // قراءة آخر الشهر
              TextField(
                controller: _newReadingController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ], // ⛔ أرقام فقط
                decoration: InputDecoration(
                  labelText: 'New Reading (End of Month)',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                    onPressed: () => _listen(_newReadingController),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _calculateBill,
                icon: const Icon(Icons.calculate),
                label: const Text('Calculate Bill'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),

              const SizedBox(height: 30),

              if (_billAmount != null && _consumption != null)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          '🔌 Electricity Bill Summary',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Consumption: $_consumption kWh',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total Bill: ${_billAmount!.toStringAsFixed(2)} EGP',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

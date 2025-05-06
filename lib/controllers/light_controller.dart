import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class LightController extends GetxController {
  // IP دستگاه که با SharedPreferences یا GetStorage هم می‌تواند ذخیره شود
  var ip = '192.168.1.100'.obs;
  var isAuto = false.obs;
  var status = ''.obs;

  final stt.SpeechToText _speech = stt.SpeechToText();

  Future<void> sendCommand(String path) async {
    final url = Uri.parse('http://${ip.value}/$path');
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        status.value = 'دستور $path با موفقیت ارسال شد';
      } else {
        status.value = 'خطا ${res.statusCode}';
      }
    } catch (e) {
      status.value = 'خطا در اتصال';
    }
  }

  void turnOn()    => sendCommand('on');
  void turnOff()   => sendCommand('off');
  void toggleAuto(){
    isAuto.value = !isAuto.value;
    sendCommand(isAuto.value ? 'auto/on' : 'auto/off');
  }

  Future<void> listen() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('Speech status: $val'),
      onError:  (val) => print('Speech error: $val'),
    );
    if (available) {
      _speech.listen(onResult: (res) {
        final txt = res.recognizedWords;
        if (txt.contains('روشن'))    turnOn();
        else if (txt.contains('خاموش')) turnOff();
        else if (txt.contains('خودکار')) {
          if (!isAuto.value) toggleAuto();
        } else if (txt.contains('دستی')) {
          if (isAuto.value) toggleAuto();
        }
      });
    } else {
      status.value = 'فرمان صوتی فعال نشد';
    }
  }

  void stopListening() {
    _speech.stop();
  }
}
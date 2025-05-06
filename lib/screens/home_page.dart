import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/light_controller.dart';

class HomeScreen extends StatelessWidget {
  final LightController c = Get.put(LightController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('کنترل لامپ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ورودی IP
            TextField(
              decoration: const InputDecoration(
                labelText: 'IP دستگاه',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => c.ip.value = v.trim(),
            ),
            const SizedBox(height: 16),

            // دکمه‌های دستی
            ElevatedButton(
              onPressed: c.turnOn,
              child: const Text('روشن'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: c.turnOff,
              child: const Text('خاموش'),
            ),
            const SizedBox(height: 16),

            // سوییچ حالت خودکار
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('حالت خودکار'),
                Obx(() => Switch(
                  value: c.isAuto.value,
                  onChanged: (_) => c.toggleAuto(),
                )),
              ],
            ),
            const SizedBox(height: 16),

            // دکمه فرمان صوتی
            ElevatedButton.icon(
              onPressed: c.listen,
              icon: const Icon(Icons.mic),
              label: const Text('فرمان صوتی'),
            ),
            const SizedBox(height: 16),

            // نمایش وضعیت
            Obx(() => Text(
              c.status.value,
              style: const TextStyle(color: Colors.blue),
            )),
          ],
        ),
      ),
    );
  }
}
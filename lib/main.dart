import 'package:flutter/material.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Tester',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NotificationTestScreen(),
    );
  }
}

class NotificationTestScreen extends StatefulWidget {
  const NotificationTestScreen({super.key});

  @override
  State<NotificationTestScreen> createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  int _notificationCounter = 0;

  int _generateUniqueId() {
    _notificationCounter++;
    return DateTime.now().millisecondsSinceEpoch.remainder(2147483647) +
        _notificationCounter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📬 Notification Tester'), elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('🚀 IMMEDIATE NOTIFICATIONS'),
          _buildTestButton(
            '🔔 Beep Sound',
            () => NotificationService.instance.showNotification(
              id: _generateUniqueId(),
              title: 'Beep!',
              body: 'This is a beep notification',
              soundName: 'beep',
            ),
            Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            '🚨 Alarm Sound',
            () => NotificationService.instance.showNotification(
              id: _generateUniqueId(),
              title: 'Alarm!',
              body: 'This is an alarm notification',
              soundName: 'alarm',
            ),
            Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            '🔔 Bell Sound',
            () => NotificationService.instance.showNotification(
              id: _generateUniqueId(),
              title: 'Bell!',
              body: 'This is a bell notification',
              soundName: 'bell',
            ),
            Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            '✨ Chime Sound',
            () => NotificationService.instance.showNotification(
              id: _generateUniqueId(),
              title: 'Chime!',
              body: 'This is a chime notification',
              soundName: 'chime',
            ),
            Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            '📍 Ding Sound',
            () => NotificationService.instance.showNotification(
              id: _generateUniqueId(),
              title: 'Ding!',
              body: 'This is a ding notification',
              soundName: 'ding',
            ),
            Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            '⚠️ Alert Sound',
            () => NotificationService.instance.showNotification(
              id: _generateUniqueId(),
              title: 'Alert!',
              body: 'This is an alert notification',
              soundName: 'alert',
            ),
            Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            '💬 Notification Sound',
            () => NotificationService.instance.showNotification(
              id: _generateUniqueId(),
              title: 'Notification!',
              body: 'This is a notification',
              soundName: 'notification',
            ),
            Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            '💥 Pop Sound',
            () => NotificationService.instance.showNotification(
              id: _generateUniqueId(),
              title: 'Pop!',
              body: 'This is a pop notification',
              soundName: 'pop',
            ),
            Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            '🌐 Ping Sound',
            () => NotificationService.instance.showNotification(
              id: _generateUniqueId(),
              title: 'Ping!',
              body: 'This is a ping notification',
              soundName: 'ping',
            ),
            Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            '🎵 Whistle Sound',
            () => NotificationService.instance.showNotification(
              id: _generateUniqueId(),
              title: 'Whistle!',
              body: 'This is a whistle notification',
              soundName: 'whistle',
            ),
            Colors.blue,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('⏰ SCHEDULED NOTIFICATIONS'),
          _buildTestButton(
            'Schedule in 10s - Beep',
            () => NotificationService.instance.scheduleOnce(
              id: _generateUniqueId(),
              title: 'Scheduled (10s)',
              body: 'Beep sound notification',
              dateTime: DateTime.now().add(const Duration(seconds: 10)),
              soundName: 'beep',
            ),
            Colors.orange,
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            'Schedule in 1m - Alarm',
            () => NotificationService.instance.scheduleOnce(
              id: _generateUniqueId(),
              title: 'Scheduled (1 min)',
              body: 'Alarm sound notification',
              dateTime: DateTime.now().add(const Duration(minutes: 1)),
              soundName: 'alarm',
            ),
            Colors.orange,
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            'Schedule in 5m - Chime',
            () => NotificationService.instance.scheduleOnce(
              id: _generateUniqueId(),
              title: 'Scheduled (5 min)',
              body: 'Chime sound notification',
              dateTime: DateTime.now().add(const Duration(minutes: 5)),
              soundName: 'chime',
            ),
            Colors.orange,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('📅 DAILY REPEATING NOTIFICATIONS'),
          _buildTestButton(
            'Daily at 9:00 AM - Bell',
            () => NotificationService.instance.scheduleDaily(
              id: _generateUniqueId(),
              title: 'Daily Reminder',
              body: 'Good morning! Time for your daily task.',
              hour: 9,
              minute: 0,
              soundName: 'bell',
            ),
            Colors.green,
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            'Daily at 3:00 PM - Ping',
            () => NotificationService.instance.scheduleDaily(
              id: _generateUniqueId(),
              title: 'Afternoon Reminder',
              body: 'Don\'t forget your afternoon task!',
              hour: 15,
              minute: 0,
              soundName: 'ping',
            ),
            Colors.green,
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            'Daily at 8:00 PM - Ding',
            () => NotificationService.instance.scheduleDaily(
              id: _generateUniqueId(),
              title: 'Evening Reminder',
              body: 'Time to wrap up for the day!',
              hour: 20,
              minute: 0,
              soundName: 'ding',
            ),
            Colors.green,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('📆 WEEKLY NOTIFICATIONS'),
          _buildTestButton(
            'Mon, Wed, Fri at 9:00 AM - Alert',
            () => NotificationService.instance.scheduleWeekly(
              id: _generateUniqueId(),
              title: 'Weekly Meeting',
              body: 'Don\'t forget about your meeting!',
              weekdays: [1, 3, 5],
              hour: 9,
              minute: 0,
              soundName: 'alert',
            ),
            Colors.purple,
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            'Every Monday at 10:00 AM - Whistle',
            () => NotificationService.instance.scheduleWeekly(
              id: _generateUniqueId(),
              title: 'Monday Briefing',
              body: 'Weekly briefing starts in 10 minutes',
              weekdays: [1],
              hour: 10,
              minute: 0,
              soundName: 'whistle',
            ),
            Colors.purple,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('🎛️ MANAGEMENT & DEBUG'),
          _buildTestButton(
            'Debug Status',
            () => NotificationService.instance.debugStatus(),
            Colors.teal,
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            'Cancel All Notifications',
            () => _showConfirmDialog(
              'Cancel all notifications?',
              () => NotificationService.instance.cancelAllNotifications(),
            ),
            Colors.red,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '💡 Tips:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  '• Check console for detailed logs',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  '• Put app in background to see scheduled notifications',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  '• Each test uses a unique ID',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  '• Check "Debug Status" to verify permissions',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTestButton(String label, VoidCallback onPressed, Color color) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog(String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

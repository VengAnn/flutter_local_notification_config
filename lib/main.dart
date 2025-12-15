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
            'Send Immediate Alert',
            () => NotificationService.instance.showNotification(
              id: _generateUniqueId(),
              title: 'Hello!',
              body: 'This is an immediate notification',
            ),
            Colors.blue,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('⏰ SCHEDULED NOTIFICATIONS'),
          _buildTestButton(
            'Schedule in 10 Seconds',
            () => NotificationService.instance.scheduleOnce(
              id: _generateUniqueId(),
              title: 'Scheduled Alert (10s)',
              body: 'This notification was scheduled 10 seconds ago',
              dateTime: DateTime.now().add(const Duration(seconds: 10)),
            ),
            Colors.orange,
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            'Schedule in 1 Minute',
            () => NotificationService.instance.scheduleOnce(
              id: _generateUniqueId(),
              title: 'Scheduled Alert (1 min)',
              body: 'This notification was scheduled 1 minute ago',
              dateTime: DateTime.now().add(const Duration(minutes: 1)),
            ),
            Colors.orange,
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            'Schedule in 5 Minutes',
            () => NotificationService.instance.scheduleOnce(
              id: _generateUniqueId(),
              title: 'Scheduled Alert (5 min)',
              body: 'This notification was scheduled 5 minutes ago',
              dateTime: DateTime.now().add(const Duration(minutes: 5)),
            ),
            Colors.orange,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('📅 DAILY REPEATING NOTIFICATIONS'),
          _buildTestButton(
            'Daily at 9:00 AM',
            () => NotificationService.instance.scheduleDaily(
              id: _generateUniqueId(),
              title: 'Daily Reminder',
              body: 'Good morning! Time for your daily task.',
              hour: 9,
              minute: 0,
            ),
            Colors.green,
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            'Daily at 3:00 PM',
            () => NotificationService.instance.scheduleDaily(
              id: _generateUniqueId(),
              title: 'Afternoon Reminder',
              body: 'Don\'t forget your afternoon task!',
              hour: 15,
              minute: 0,
            ),
            Colors.green,
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            'Daily at 8:00 PM',
            () => NotificationService.instance.scheduleDaily(
              id: _generateUniqueId(),
              title: 'Evening Reminder',
              body: 'Time to wrap up for the day!',
              hour: 20,
              minute: 0,
            ),
            Colors.green,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('📆 WEEKLY NOTIFICATIONS'),
          _buildTestButton(
            'Mon, Wed, Fri at 9:00 AM',
            () => NotificationService.instance.scheduleWeekly(
              id: _generateUniqueId(),
              title: 'Weekly Meeting',
              body: 'Don\'t forget about your meeting!',
              weekdays: [1, 3, 5],
              hour: 9,
              minute: 0,
            ),
            Colors.purple,
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            'Every Monday at 10:00 AM',
            () => NotificationService.instance.scheduleWeekly(
              id: _generateUniqueId(),
              title: 'Monday Briefing',
              body: 'Weekly briefing starts in 10 minutes',
              weekdays: [1],
              hour: 10,
              minute: 0,
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
              color: Colors.blue.withOpacity(0.1),
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

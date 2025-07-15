import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/services.dart';
import 'roommate_management_page.dart';

class HouseDashboard extends StatefulWidget {
  const HouseDashboard({super.key});

  @override
  State<HouseDashboard> createState() => _HouseDashboardState();
}

class _HouseDashboardState extends State<HouseDashboard> {
  String _houseName = 'My House Name';

  void _editHouseName() async {
    final controller = TextEditingController(text: _houseName);

    final newName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit House Name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter new house name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, controller.text.trim());
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.isNotEmpty) {
      setState(() {
        _houseName = newName;
      });
    }
  }

  void _showInviteCode() {
    const code = 'ABC123XYZ';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Invite Code'),
          content: GestureDetector(
            onTap: () {
              Clipboard.setData(const ClipboardData(text: code));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to clipboard')),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  code,
                  style: AppTextStyles.secondary.copyWith(
                    color: context.theme.accentColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap to copy',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.surfaceColor,
      appBar: AppBar(
        title: const Text('House Dashboard'),
        backgroundColor: context.theme.primaryColor,
        foregroundColor: context.theme.accentColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // House name + action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: _houseName,
                  style: AppTextStyles.primary,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: _editHouseName,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      onPressed: _showInviteCode,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RoommateManagementPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.theme.primaryColor,
                  foregroundColor: context.theme.accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Manage Roommates"),
              ),
            ),

            const SizedBox(height: 24),

            const CustomText(
              text: 'Members',
              style: AppTextStyles.primary,
            ),

            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                    color: context.theme.accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      title: Text('Member ${index + 1}'),
                      children: const [
                        ListTile(title: Text('Preferred Payment: Venmo')),
                        ListTile(title: Text('Backup: Zelle')),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

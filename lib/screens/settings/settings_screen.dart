
import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final businessController =
      TextEditingController(text: 'My Business');
  final emailController =
      TextEditingController(text: 'business@example.com');
  final phoneController =
      TextEditingController();

  String currency = 'USD';
  bool showBusinessDetails = true;
  bool autoInvoiceNumber = true;

  @override
  void dispose() {
    businessController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.business_outlined,
                  size: 30,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Business Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Manage your invoice preferences',
                      style: TextStyle(
                        color: AppTheme.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          sectionTitle('Business Information'),
          TextField(
            controller: businessController,
            decoration: const InputDecoration(
              labelText: 'Business name',
              prefixIcon: Icon(Icons.business),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Business email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone number',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),

          sectionTitle('Invoice Preferences'),
          DropdownButtonFormField<String>(
            initialValue: currency,
            decoration: const InputDecoration(
              labelText: 'Default currency',
              prefixIcon: Icon(Icons.currency_exchange),
            ),
            items: [
              'USD', 'EUR', 'GBP', 'PKR',
              'AED', 'SAR', 'CAD', 'AUD',
            ].map((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            )).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => currency = value);
              }
            },
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: autoInvoiceNumber,
            activeThumbColor: AppTheme.primary,
            title: const Text('Automatic invoice numbers'),
            subtitle: const Text(
              'Generate invoice numbers automatically',
            ),
            onChanged: (value) {
              setState(() => autoInvoiceNumber = value);
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: showBusinessDetails,
            activeThumbColor: AppTheme.primary,
            title: const Text('Show business details'),
            subtitle: const Text(
              'Display business information on invoices',
            ),
            onChanged: (value) {
              setState(() => showBusinessDetails = value);
            },
          ),

          sectionTitle('Account'),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.person_outline),
            title: const Text('My Profile'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showMessage('Profile settings will be connected later.'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.lock_outline),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showMessage('Password settings will be connected later.'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.info_outline),
            title: const Text('About Easy Invoice'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Easy Invoice',
              applicationVersion: '1.0.0',
              applicationLegalese: 'Simple invoicing made easy.',
            ),
          ),

          const SizedBox(height: 25),
          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: () => showMessage(
                'Settings are currently local demo data. '
                'Your developer will connect them to Firebase.',
              ),
              child: const Text('Save Settings'),
            ),
          ),
          const SizedBox(height: 25),
          const Center(
            child: Text(
              'Easy Invoice • Version 1.0.0',
              style: TextStyle(
                color: AppTheme.secondaryText,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

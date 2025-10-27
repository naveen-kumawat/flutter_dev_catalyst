import 'package:flutter/material.dart';
import 'api_demo_screen.dart';
import 'storage_demo_screen.dart';
import 'ui_components_screen.dart';
import 'validators_demo_screen.dart';
import 'theme_demo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DevCatalyst Examples'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildDemoCard(
            context,
            title: 'API Client Demo',
            description: 'Test API requests, responses, and error handling',
            icon: Icons.cloud,
            onTap: () => _navigate(context, const ApiDemoScreen()),
          ),
          const SizedBox(height: 12),
          _buildDemoCard(
            context,
            title: 'Storage Demo',
            description: 'Local and secure storage examples',
            icon: Icons.storage,
            onTap: () => _navigate(context, const StorageDemoScreen()),
          ),
          const SizedBox(height: 12),
          _buildDemoCard(
            context,
            title: 'UI Components',
            description: 'Buttons, text fields, loading, and error widgets',
            icon: Icons.widgets,
            onTap: () => _navigate(context, const UiComponentsScreen()),
          ),
          const SizedBox(height: 12),
          _buildDemoCard(
            context,
            title: 'Validators',
            description: 'Form validation examples',
            icon: Icons.check_circle,
            onTap: () => _navigate(context, const ValidatorsDemoScreen()),
          ),
          const SizedBox(height: 12),
          _buildDemoCard(
            context,
            title: 'Theme Manager',
            description: 'Light/dark theme switching',
            icon: Icons.palette,
            onTap: () => _navigate(context, const ThemeDemoScreen()),
          ),
          const SizedBox(height: 24),
          _buildInfoSection(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.rocket_launch,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Flutter Dev Catalyst',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Accelerate your Flutter development with smart automation',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Quick Info',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(context, 'Version', '1.0.0'),
            _buildInfoRow(context, 'Version', '1.0.0'),
            _buildInfoRow(context, 'Flutter', '>=3.16.0'),
            _buildInfoRow(context, 'Dart', '>=3.2.0'),
            const SizedBox(height: 8),
            Text(
              'Explore all features and see how DevCatalyst can speed up your development workflow!',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

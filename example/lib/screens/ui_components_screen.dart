import 'package:flutter/material.dart';
import 'package:flutter_dev_catalyst/flutter_dev_catalyst.dart';

class UiComponentsScreen extends StatefulWidget {
  const UiComponentsScreen({super.key});

  @override
  State<UiComponentsScreen> createState() => _UiComponentsScreenState();
}

class _UiComponentsScreenState extends State<UiComponentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UI Components')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildButtonsSection(),
          const SizedBox(height: 24),
          _buildTextFieldsSection(),
          const SizedBox(height: 24),
          _buildLoadingSection(),
          const SizedBox(height: 24),
          _buildErrorSection(),
          const SizedBox(height: 24),
          _buildSkeletonSection(),
        ],
      ),
    );
  }

  Widget _buildButtonsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Buttons',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CatalystButton.elevated(
              text: 'Elevated Button',
              icon: Icons.star,
              onPressed: () =>
                  context.showSuccessSnackBar('Elevated button pressed'),
              isFullWidth: true,
            ),
            const SizedBox(height: 12),
            CatalystButton.outlined(
              text: 'Outlined Button',
              icon: Icons.favorite,
              onPressed: () =>
                  context.showSuccessSnackBar('Outlined button pressed'),
              isFullWidth: true,
            ),
            const SizedBox(height: 12),
            CatalystButton.text(
              text: 'Text Button',
              icon: Icons.touch_app,
              onPressed: () =>
                  context.showSuccessSnackBar('Text button pressed'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CatalystButton.elevated(
                    text: 'Small',
                    size: CatalystButtonSize.small,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CatalystButton.elevated(
                    text: 'Medium',
                    size: CatalystButtonSize.medium,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CatalystButton.elevated(
                    text: 'Large',
                    size: CatalystButtonSize.large,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CatalystButton.elevated(
              text: 'Loading Button',
              icon: Icons.cloud_upload,
              onPressed: () {},
              isLoading: true,
              isFullWidth: true,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CatalystButton.icon(
                  icon: Icons.favorite,
                  onPressed: () =>
                      context.showSuccessSnackBar('Icon button pressed'),
                ),
                CatalystButton.icon(
                  icon: Icons.share,
                  onPressed: () => context.showSuccessSnackBar('Share pressed'),
                ),
                CatalystButton.icon(
                  icon: Icons.bookmark,
                  onPressed: () =>
                      context.showSuccessSnackBar('Bookmark pressed'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Text Fields',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CatalystTextField(
              label: 'Name',
              hint: 'Enter your name',
              prefixIcon: Icons.person,
              validators: [Validators.required],
              autoValidate: true,
            ),
            const SizedBox(height: 12),
            CatalystTextField(
              type: CatalystTextFieldType.email,
              label: 'Email',
              hint: 'Enter your email',
              prefixIcon: Icons.email,
              validators: [Validators.required, Validators.email],
              autoValidate: true,
            ),
            const SizedBox(height: 12),
            CatalystTextField(
              type: CatalystTextFieldType.password,
              label: 'Password',
              hint: 'Enter your password',
              prefixIcon: Icons.lock,
              validators: [Validators.required, Validators.password],
              autoValidate: true,
            ),
            const SizedBox(height: 12),
            CatalystTextField(
              type: CatalystTextFieldType.phone,
              label: 'Phone',
              hint: 'Enter your phone number',
              prefixIcon: Icons.phone,
              validators: [Validators.required, Validators.phone],
              autoValidate: true,
            ),
            const SizedBox(height: 12),
            CatalystTextField(
              type: CatalystTextFieldType.number,
              label: 'Age',
              hint: 'Enter your age',
              prefixIcon: Icons.calendar_today,
            ),
            const SizedBox(height: 12),
            CatalystTextField(
              type: CatalystTextFieldType.multiline,
              label: 'Bio',
              hint: 'Tell us about yourself',
              prefixIcon: Icons.notes,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loading Indicators',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                CatalystLoading(size: LoadingSize.small),
                CatalystLoading(size: LoadingSize.medium),
                CatalystLoading(size: LoadingSize.large),
              ],
            ),
            const SizedBox(height: 16),
            const CatalystLoading(message: 'Loading data...'),
            const SizedBox(height: 16),
            CatalystLoading.linear(message: 'Downloading...'),
            const SizedBox(height: 16),
            CatalystButton.elevated(
              text: 'Show Full Screen Loading',
              icon: Icons.hourglass_empty,
              onPressed: () {
                CatalystLoading.show(context, message: 'Please wait...');
                Future.delayed(const Duration(seconds: 2), () {
                  CatalystLoading.hide(context);
                });
              },
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Error Widgets',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CatalystErrorWidget.simple(
              message: 'Something went wrong. Please try again.',
              onRetry: () => context.showSuccessSnackBar('Retry pressed'),
            ),
            const SizedBox(height: 16),
            CatalystErrorWidget.detailed(
              title: 'Network Error',
              message: 'Unable to connect to the server.',
              details: 'Error code: 500\nTimestamp: ${DateTime.now()}',
              icon: Icons.wifi_off,
              onRetry: () => context.showSuccessSnackBar('Retry pressed'),
            ),
            const SizedBox(height: 16),
            const CatalystEmptyWidget(
              title: 'No Data',
              message: 'There is no data to display at the moment.',
              icon: Icons.inbox,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Skeleton Loading',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CatalystSkeleton.circle(size: 50),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CatalystSkeleton.rectangular(height: 16, width: 150),
                      const SizedBox(height: 8),
                      CatalystSkeleton.rectangular(height: 12, width: 100),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CatalystSkeleton.rectangular(height: 200, width: double.infinity),
            const SizedBox(height: 12),
            CatalystSkeleton.rectangular(height: 16, width: double.infinity),
            const SizedBox(height: 8),
            CatalystSkeleton.rectangular(height: 16, width: 200),
          ],
        ),
      ),
    );
  }
}

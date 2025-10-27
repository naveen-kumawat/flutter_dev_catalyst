import 'package:flutter/material.dart';
import 'package:flutter_dev_catalyst/flutter_dev_catalyst.dart';

class ValidatorsDemoScreen extends StatefulWidget {
  const ValidatorsDemoScreen({super.key});

  @override
  State<ValidatorsDemoScreen> createState() => _ValidatorsDemoScreenState();
}

class _ValidatorsDemoScreenState extends State<ValidatorsDemoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _urlController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _urlController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validators Demo')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildInfoCard(),
            const SizedBox(height: 24),
            _buildValidatorsSection(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
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
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Form Validators',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Test built-in validators with real-time validation feedback.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValidatorsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test Validators',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Email Validator
            CatalystTextField(
              controller: _emailController,
              type: CatalystTextFieldType.email,
              label: 'Email',
              hint: 'Enter a valid email',
              prefixIcon: Icons.email,
              validators: [Validators.required, Validators.email],
              autoValidate: true,
            ),
            const SizedBox(height: 12),

            // Password Validator
            CatalystTextField(
              controller: _passwordController,
              type: CatalystTextFieldType.password,
              label: 'Password',
              hint: 'Min 8 chars, uppercase, lowercase, number, special char',
              prefixIcon: Icons.lock,
              validators: [Validators.required, Validators.password],
              autoValidate: true,
            ),
            const SizedBox(height: 12),

            // Confirm Password Validator
            CatalystTextField(
              controller: _confirmPasswordController,
              type: CatalystTextFieldType.password,
              label: 'Confirm Password',
              hint: 'Must match password',
              prefixIcon: Icons.lock_outline,
              validators: [
                Validators.required,
                (value) =>
                    Validators.confirmPassword(value, _passwordController.text),
              ],
              autoValidate: true,
            ),
            const SizedBox(height: 12),

            // Phone Validator
            CatalystTextField(
              controller: _phoneController,
              type: CatalystTextFieldType.phone,
              label: 'Phone Number',
              hint: 'Enter valid phone number',
              prefixIcon: Icons.phone,
              validators: [Validators.required, Validators.phone],
              autoValidate: true,
            ),
            const SizedBox(height: 12),

            // URL Validator
            CatalystTextField(
              controller: _urlController,
              label: 'Website URL',
              hint: 'https://example.com',
              prefixIcon: Icons.link,
              validators: [Validators.required, Validators.url],
              autoValidate: true,
            ),
            const SizedBox(height: 12),

            // Age Validator (Min/Max Value)
            CatalystTextField(
              controller: _ageController,
              type: CatalystTextFieldType.number,
              label: 'Age',
              hint: 'Between 18 and 100',
              prefixIcon: Icons.cake,
              validators: [
                Validators.required,
                Validators.integer,
                (value) => Validators.minValue(value, 18, fieldName: 'Age'),
                (value) => Validators.maxValue(value, 100, fieldName: 'Age'),
              ],
              autoValidate: true,
            ),
            const SizedBox(height: 16),

            // Validation Examples
            _buildValidationExamples(),
          ],
        ),
      ),
    );
  }

  Widget _buildValidationExamples() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Validation Rules:',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildValidationRule(
            'Email',
            'Valid email format (user@example.com)',
          ),
          _buildValidationRule(
            'Password',
            'Min 8 chars, uppercase, lowercase, number, special char',
          ),
          _buildValidationRule('Phone', 'Valid phone number format'),
          _buildValidationRule(
            'URL',
            'Valid URL starting with http:// or https://',
          ),
          _buildValidationRule('Age', 'Integer between 18 and 100'),
        ],
      ),
    );
  }

  Widget _buildValidationRule(String field, String rule) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodySmall,
                children: [
                  TextSpan(
                    text: '$field: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: rule),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return CatalystButton.elevated(
      text: 'Validate Form',
      icon: Icons.check_circle,
      onPressed: _validateForm,
      isFullWidth: true,
      size: CatalystButtonSize.large,
    );
  }

  void _validateForm() {
    if (_formKey.currentState?.validate() ?? false) {
      context.showSuccessSnackBar('✅ All fields are valid!');

      // Show summary dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Validation Success'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryRow('Email', _emailController.text),
              _buildSummaryRow('Password', '********'),
              _buildSummaryRow('Phone', _phoneController.text),
              _buildSummaryRow('URL', _urlController.text),
              _buildSummaryRow('Age', _ageController.text),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } else {
      context.showErrorSnackBar('❌ Please fix validation errors');
    }
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:dyno_form/dyno_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dyno Form Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FormExampleScreen(),
    );
  }
}

class FormExampleScreen extends StatefulWidget {
  const FormExampleScreen({super.key});

  @override
  State<FormExampleScreen> createState() => _FormExampleScreenState();
}

class _FormExampleScreenState extends State<FormExampleScreen> {
  final List<DynamicFieldConfig> fields = [
    const DynamicFieldConfig(
      id: 1,
      fieldName: 'Personal Details',
      fieldType: 18, // Section Splitter
    ),
    const DynamicFieldConfig(
      id: 2,
      fieldName: 'Full Name',
      fieldType: 1, // Text
      isMandatory: true,
      placeholder: 'Enter your full name',
    ),
    const DynamicFieldConfig(
      id: 3,
      fieldName: 'Email Address',
      fieldType: 11, // Email
      isMandatory: true,
      placeholder: 'john@example.com',
    ),
    const DynamicFieldConfig(
      id: 4,
      fieldName: 'Event Booking',
      fieldType: 18, // Section Splitter
    ),
    const DynamicFieldConfig(
      id: 5,
      fieldName: 'Start Date',
      fieldType: 2, // DateTime
      isMandatory: true,
    ),
    const DynamicFieldConfig(
      id: 6,
      fieldName: 'End Date (Must be after Start Date)',
      fieldType: 2, // DateTime
      isMandatory: true,
      minDateFromField: '5', // Dynamic Cross-field validation!
    ),
    const DynamicFieldConfig(
      id: 7,
      fieldName: 'Accept Terms & Conditions',
      fieldType: 3, // Checkbox
      isMandatory: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dyno Form Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: DynamicFormWidget(
            fields: fields,
            submitButtonText: 'Submit Registration',
            onSubmit: (Map<String, dynamic> data) {
              // Handle form submission
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Form Submitted!'),
                  content: Text(data.toString()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('OK'),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

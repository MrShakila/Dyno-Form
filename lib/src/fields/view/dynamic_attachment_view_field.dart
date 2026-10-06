import 'dart:io';
import 'package:flutter/material.dart';
import 'package:reactive_image_picker/reactive_image_picker.dart';
import '../../models/dynamic_field_config.dart';

class DynamicAttachmentViewField extends StatelessWidget {
  final DynamicFieldConfig field;
  final dynamic value;

  const DynamicAttachmentViewField({
    super.key,
    required this.field,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.fieldName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        _buildAttachmentView(context),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }

  Widget _buildAttachmentView(BuildContext context) {
    List<dynamic> items = [];
    if (value is List) {
      items = value;
    } else if (value != null) {
      items = [value];
    }

    if (items.isEmpty) {
      return const Text('-', style: TextStyle(fontSize: 16));
    }

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: items.map((item) {
        if (item is SelectedFile) {
          if (item.file != null) {
            return _imageContainer(context, Image.file(File(item.file!.path), fit: BoxFit.cover));
          } else if (item.url != null) {
            return _imageContainer(context, Image.network(item.url!, fit: BoxFit.cover));
          }
        } else if (item is String) {
          if (item.startsWith('http')) {
             return _imageContainer(context, Image.network(item, fit: BoxFit.cover));
          } else {
             return _imageContainer(context, Image.file(File(item), fit: BoxFit.cover));
          }
        }
        return const SizedBox.shrink();
      }).toList(),
    );
  }

  Widget _imageContainer(BuildContext context, Widget image) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  InteractiveViewer(
                    panEnabled: true,
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: image,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 30),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        clipBehavior: Clip.antiAlias,
        child: image,
      ),
    );
  }
}

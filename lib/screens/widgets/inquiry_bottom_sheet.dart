import 'package:flutter/material.dart';
import 'package:maskhaze_flutter/color_style.dart';

class InquiryBottomSheet extends StatefulWidget {
  final String title;
  final Function(Map<String, String>) onSubmit;

  const InquiryBottomSheet({
    super.key,
    required this.title,
    required this.onSubmit,
  });

  @override
  State<InquiryBottomSheet> createState() => _InquiryBottomSheetState();
}

class _InquiryBottomSheetState extends State<InquiryBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final fields = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'message': _messageController.text.trim(),
      };
      
      widget.onSubmit(fields);
      Navigator.of(context).pop();
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    
    return null;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorStyles.backgroundMain,
        border: Border(
          top: BorderSide(color: ColorStyles.borderColor),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorStyles.textMain,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            
            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter your name',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.borderColor),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      filled: true,
                      fillColor: ColorStyles.cardAlt,
                    ),
                    validator: (value) => _validateRequired(value, 'Name'),
                  ),
                  const SizedBox(height: 14),
                  
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.borderColor),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      filled: true,
                      fillColor: ColorStyles.cardAlt,
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 14),
                  
                  // Message Field
                  TextFormField(
                    controller: _messageController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      hintText: 'Enter your message',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.borderColor),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      filled: true,
                      fillColor: ColorStyles.cardAlt,
                      alignLabelWithHint: true,
                    ),
                    validator: (value) => _validateRequired(value, 'Message'),
                  ),
                  const SizedBox(height: 20),
                  
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorStyles.primary,
                        foregroundColor: ColorStyles.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text(
                        'Submit Inquiry',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  // Close Button
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        color: ColorStyles.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

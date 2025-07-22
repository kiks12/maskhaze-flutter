import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maskhaze_flutter/color_style.dart';
import 'package:maskhaze_flutter/data/urls.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleInquire() async {
    if (!_formKey.currentState!.validate()) {
      _showAlert('Please fill out all fields.');
      return;
    }

    try {
      final to = EMAIL;
      const subject = 'Contact Inquiry';
      final body = 'Name: ${_nameController.text}\nEmail: ${_emailController.text}\nMessage: ${_messageController.text}';
      
      final uri = Uri(
        scheme: 'mailto',
        path: to,
        query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        _showSuccessAlert();
        _clearForm();
      } else {
        throw 'Could not launch email client';
      }
    } catch (error) {
      debugPrint('Error sending email: $error');
      _showAlert('Unable to open your email app.');
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          backgroundColor: ColorStyles.cardBackground,
          titleTextStyle: ColorStyles.textLightStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: ColorStyles.textStyle,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(color: ColorStyles.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Inquiry'),
          content: const Text('Thank you for your inquiry! Please send the email in your mail app.'),
          backgroundColor: ColorStyles.cardBackground,
          titleTextStyle: ColorStyles.textLightStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: ColorStyles.textStyle,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(color: ColorStyles.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundMain,
      appBar: AppBar(
        backgroundColor: ColorStyles.backgroundMain,
        foregroundColor: ColorStyles.primary,
        automaticallyImplyLeading: false,
        title: const Text('Contact Us', style: TextStyle(color: ColorStyles.textMain)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header Section
              _buildHeader(),
              const SizedBox(height: 30),
              
              // Contact Information Cards
              _buildContactCard(
                icon: Icons.email,
                title: 'Email',
                info: 'MASKhaze@tbrtengineering.com',
              ),
              const SizedBox(height: 12),
              
              _buildContactCard(
                icon: Icons.phone,
                title: 'Phone',
                info: '+1 920-245-3392',
              ),
              const SizedBox(height: 12),
              
              _buildContactCard(
                icon: Icons.location_pin,
                title: 'Address',
                info: 'Lake Mills, WI 53551',
              ),
              const SizedBox(height: 18),
              
              // Contact Form
              _buildContactForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Text(
        //   'Contact Us',
        //   style: ColorStyles.textStyle.copyWith(
        //     fontSize: 24,
        //     fontWeight: FontWeight.w800,
        //   ),
        // ),
        const SizedBox(height: 10),
        Text(
          'Get in touch with our team',
          style: ColorStyles.textMutedStyle.copyWith(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String info,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorStyles.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorStyles.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2, right: 8),
            child: Icon(
              icon,
              size: 24,
              color: ColorStyles.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: ColorStyles.textStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  info,
                  style: ColorStyles.textMutedStyle.copyWith(
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorStyles.borderColor),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Name',
                filled: true,
                fillColor: ColorStyles.backgroundMain,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: ColorStyles.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: ColorStyles.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: ColorStyles.primary),
                ),
                contentPadding: EdgeInsets.all(12),
                hintStyle: TextStyle(color: ColorStyles.textMuted),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: ColorStyles.textMain,
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) => _validateRequired(value, 'Name'),
            ),
            const SizedBox(height: 12),
            
            // Email Field
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
                filled: true,
                fillColor: ColorStyles.backgroundMain,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: ColorStyles.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: ColorStyles.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: ColorStyles.primary),
                ),
                contentPadding: EdgeInsets.all(12),
                hintStyle: TextStyle(color: ColorStyles.textMuted),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: ColorStyles.textMain,
              ),
              validator: _validateEmail,
            ),
            const SizedBox(height: 12),
            
            // Message Field
            TextFormField(
              controller: _messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Message',
                filled: true,
                fillColor: ColorStyles.backgroundMain,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: ColorStyles.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: ColorStyles.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: ColorStyles.primary),
                ),
                contentPadding: EdgeInsets.all(12),
                hintStyle: TextStyle(color: ColorStyles.textMuted),
                alignLabelWithHint: true,
              ),
              style: const TextStyle(
                fontSize: 16,
                color: ColorStyles.textMain,
              ),
              validator: (value) => _validateRequired(value, 'Message'),
            ),
            const SizedBox(height: 20),
            
            // Submit Button
            ElevatedButton(
              onPressed: _handleInquire,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorStyles.primary,
                foregroundColor: ColorStyles.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 28,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                elevation: 0,
              ),
              child: Text(
                'Inquire',
                style: ColorStyles.whiteTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

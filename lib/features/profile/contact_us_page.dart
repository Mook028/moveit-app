import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _nameController = TextEditingController(text: "mook");
  final _emailController = TextEditingController(text: "micmook78@gmail.com");
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  Future<void> _sendEmail() async {
    final subject = _subjectController.text;
    final message = _messageController.text;

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: '6731503028@lamduan.mfu.ac.th',
      query:
          'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Could not open email app")));
    }
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon) : null,
            hintText: label,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 245, 243),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B5E20)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Contact Us",
          style: TextStyle(color: Color(0xFF1B5E20)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Have a question or feedback? We'd love to hear from you!",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              "Contact us at: 6731503028@lamduan.mfu.ac.th",
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 24),

            _buildField("Your Name", _nameController, icon: Icons.person),
            const SizedBox(height: 16),

            _buildField("Your Email", _emailController, icon: Icons.email),
            const SizedBox(height: 16),

            _buildField("Subject", _subjectController, icon: Icons.subject),
            const SizedBox(height: 16),

            _buildField(
              "Message",
              _messageController,
              maxLines: 5,
              icon: Icons.message,
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF76C58C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Send Message",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

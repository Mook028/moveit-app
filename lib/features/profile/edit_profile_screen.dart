import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/providers/app_provider.dart';
import 'package:flutter/foundation.dart';
import '../../core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const Color _primaryGreen = Color(0xFF2E7D32);
  static const Color _lightGreen = Color(0xFFA5D6A7);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final appProvider = context.read<AppProvider>();
    final firebaseUser = FirebaseAuth.instance.currentUser;

    final firestoreName = appProvider.user.name.trim();
    _nameController.text = firestoreName;
    _usernameController.text = firestoreName;
    _emailController.text = firebaseUser?.email?.trim() ?? '';
    _passwordController.clear();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onPickAvatar() async {
    try {
      final picker = ImagePicker();

      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', pickedFile.path);

      if (!mounted) return;

      // update UI
      context.read<AppProvider>().setProfileImage(pickedFile.path);
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }

  void _onSave() {
    // Get AppProvider and update user profile with changes
    final appProvider = context.read<AppProvider>();

    final updatedName = _nameController.text.trim();
    final updatedEmail = _emailController.text.trim();

    // Call updateUserProfile with the new values
    // This method updates the local user object using copyWith()
    // and calls notifyListeners() to rebuild listening widgets
    appProvider.updateUserProfile(name: updatedName, email: updatedEmail);

    // Pop back to ProfileScreen after saving
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCF0DF).withOpacity(0.5),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E7D32)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Color(0xFF2E7D32)),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                _buildAvatarSection(context),
                const SizedBox(height: 24),
                _LabeledInputField(
                  label: 'Name',
                  controller: _nameController,
                  hintText: 'Enter your name',
                ),
                const SizedBox(height: 18),
                _LabeledInputField(
                  label: 'Email address',
                  controller: _emailController,
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  enabled: false,
                ),
                const SizedBox(height: 8),

                const Text(
                  "Registered email cannot be changed",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF76C58C),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 116,
            height: 116,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _primaryGreen.withValues(alpha: 0.75),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: _primaryGreen.withValues(alpha: 0.26),
                  blurRadius: 30,
                  spreadRadius: 2,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: const Color(0xFFA5D6A7).withValues(alpha: 0.35),
                  blurRadius: 22,
                  spreadRadius: 1,
                ),
              ],
            ),

            // 🔥 ใช้ Consumer + Image.memory
            child: Consumer<AppProvider>(
              builder: (context, provider, child) {
                return ClipOval(
                  child: provider.profileImageBytes != null
                      ? Image.memory(
                          provider.profileImageBytes!,
                          width: 116,
                          height: 116,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.white,
                          child: const Icon(Icons.person_rounded, size: 40),
                        ),
                );
              },
            ),
          ),

          // 📸 ปุ่มกล้อง
          Positioned(
            right: -4,
            bottom: -2,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _showPhotoOptions(context);
                },
                borderRadius: BorderRadius.circular(20),
                child: Ink(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _primaryGreen,
                    boxShadow: [
                      BoxShadow(
                        color: _primaryGreen.withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPhotoOptions(BuildContext context) async {
    final parentContext = context; // ใช้ context ของหน้า EditProfileScreen

    showDialog(
      context: parentContext,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Update Profile Photo",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  Navigator.pop(dialogContext); // ปิด dialog ด้วย dialogContext

                  final picker = ImagePicker();
                  final XFile? pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );

                  if (pickedFile == null || !mounted) return;

                  final bytes = await pickedFile.readAsBytes();
                  context.read<AppProvider>().setProfileImageBytes(bytes);

                  await _onPickAvatar(); // เรียกฟังก์ชันเดิมเพื่อบันทึก path และอัปเดต UI
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F5F3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.image, color: Colors.green),
                      SizedBox(width: 12),
                      Text(
                        "Choose from Gallery",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancel"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _decorativeBlob({
    required double size,
    required Color color,
    required double alpha,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: alpha),
      ),
    );
  }
}

class _LabeledInputField extends StatelessWidget {
  static const Color _primaryGreen = Color(0xFF2E7D32);

  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool enabled;

  const _LabeledInputField({
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _primaryGreen,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _primaryGreen.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF245E27),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: _primaryGreen.withValues(alpha: 0.45),
                fontWeight: FontWeight.w500,
              ),
              suffixIcon: suffixIcon,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: _primaryGreen.withValues(alpha: 0.20),
                  width: 1.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  static const Color _primaryGreen = Color(0xFF2E7D32);

  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: _primaryGreen.withValues(alpha: 0.14),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: _primaryGreen, size: 20),
        ),
      ),
    );
  }
}

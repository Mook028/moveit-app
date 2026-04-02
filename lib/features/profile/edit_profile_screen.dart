import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/app_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const Color _primaryGreen = Color(0xFF2E7D32);
  static const Color _lightGreen = Color(0xFFA5D6A7);
  static const Color _backgroundGreen = Color(0xFFF1F8F4);

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

  void _onPickAvatar() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mock image picker action')));
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
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA8D5BA), Color(0xFFBFE3D0), Color(0xFFEAF5EF)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -70,
              child: _decorativeBlob(
                size: 220,
                color: _lightGreen,
                alpha: 0.18,
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTopBar(),
                      const SizedBox(height: 22),
                      _buildAvatarSection(),
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
                      ),
                      const SizedBox(height: 18),
                      _LabeledInputField(
                        label: 'Username',
                        controller: _usernameController,
                        hintText: 'Enter your username',
                      ),
                      const SizedBox(height: 18),
                      _LabeledInputField(
                        label: 'Password',
                        controller: _passwordController,
                        hintText: 'Enter your password',
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: _primaryGreen.withOpacity(0.75),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        _RoundIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.of(context).maybePop(),
        ),
        const Expanded(
          child: Text(
            'Edit Profile',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF1B5E20),
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
        _RoundIconButton(icon: Icons.check_rounded, onTap: _onSave),
      ],
    );
  }

  Widget _buildAvatarSection() {
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
                color: _primaryGreen.withOpacity(0.75),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: _primaryGreen.withOpacity(0.26),
                  blurRadius: 30,
                  spreadRadius: 2,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: const Color(0xFFA5D6A7).withOpacity(0.35),
                  blurRadius: 22,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person_rounded, size: 56, color: _primaryGreen),
            ),
          ),
          Positioned(
            right: -4,
            bottom: -2,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _onPickAvatar,
                borderRadius: BorderRadius.circular(20),
                child: Ink(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _primaryGreen,
                    boxShadow: [
                      BoxShadow(
                        color: _primaryGreen.withOpacity(0.35),
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
        color: color.withOpacity(alpha),
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

  const _LabeledInputField({
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
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
                color: _primaryGreen.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
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
                color: _primaryGreen.withOpacity(0.45),
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
                  color: _primaryGreen.withOpacity(0.20),
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
                color: _primaryGreen.withOpacity(0.14),
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

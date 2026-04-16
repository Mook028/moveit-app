import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool _loading = false;

  Future<void> _updatePassword() async {
    final current = _currentController.text.trim();
    final newPass = _newController.text.trim();
    final confirm = _confirmController.text.trim();

    // validation
    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      _showMsg("Please fill all fields");
      return;
    }

    if (newPass.length < 6) {
      _showMsg("Password must be at least 6 characters");
      return;
    }

    if (newPass != confirm) {
      _showMsg("Passwords do not match");
      return;
    }

    try {
      setState(() => _loading = true);

      final user = FirebaseAuth.instance.currentUser!;

      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: current,
      );

      // re-authenticate
      await user.reauthenticateWithCredential(cred);

      // update password
      await user.updatePassword(newPass);

      _showMsg("Password updated successfully ");

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _showMsg("Current password is incorrect");
      } else if (e.code == 'weak-password') {
        _showMsg("Password is too weak");
      } else {
        _showMsg(e.message ?? "Error occurred");
      }
    } catch (e) {
      _showMsg("Something went wrong");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _buildInput({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
              onPressed: toggle,
            ),
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
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCF0DF).withOpacity(0.45),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Change Password",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInput(
              label: "Current Password",
              hint: "Enter current password",
              controller: _currentController,
              obscure: _obscureCurrent,
              toggle: () {
                setState(() => _obscureCurrent = !_obscureCurrent);
              },
            ),
            const SizedBox(height: 20),

            _buildInput(
              label: "New Password",
              hint: "At least 6 characters",
              controller: _newController,
              obscure: _obscureNew,
              toggle: () {
                setState(() => _obscureNew = !_obscureNew);
              },
            ),
            const SizedBox(height: 8),

            const Text(
              "Use uppercase letters, numbers, and symbols for a stronger password.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            _buildInput(
              label: "Confirm New Password",
              hint: "Repeat new password",
              controller: _confirmController,
              obscure: _obscureConfirm,
              toggle: () {
                setState(() => _obscureConfirm = !_obscureConfirm);
              },
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _updatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF76C58C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Update Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

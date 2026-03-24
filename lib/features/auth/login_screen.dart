import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;

import '../../core/constants/routes.dart';
import '../../core/providers/app_provider.dart';
import 'auth_provider.dart';

class LoginScreen extends StatefulWidget {
  final bool isLogin;
  const LoginScreen({super.key, this.isLogin = true});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _error;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
    });

    if (!mounted) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    final validationError = _validateInputs(
      email: email,
      password: password,
      name: name,
      isLogin: widget.isLogin,
    );
    if (validationError != null) {
      setState(() {
        _error = validationError;
      });
      return;
    }

    final auth = context.read<AuthProvider>();
    final appProv = context.read<AppProvider>();

    try {
      if (widget.isLogin) {
        await auth.login(email, password);
      } else {
        await auth.register(email, password, name: name);
      }

      if (!mounted) return;

      // sync name to app provider
      final user = auth.user;
      if (user != null) {
        final name = user.displayName ?? user.email ?? '';
        appProv.setUserName(name);
      }

      if (mounted) {
        context.go(Routes.login);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _error = _friendlyAuthMessage(e);
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Something went wrong. Please try again.';
        });
      }
    }
  }

  String? _validateInputs({
    required String email,
    required String password,
    required String name,
    required bool isLogin,
  }) {
    if (!isLogin && name.isEmpty) {
      return 'Please enter your full name.';
    }
    if (email.isEmpty) {
      return 'Email must not be empty.';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  String _friendlyAuthMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already in use. Try signing in instead.';
      case 'weak-password':
        return 'Your password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final loading = auth.isLoading;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFB8F3D9), // mint green
                const Color(0xFFE0F8F1), // light aqua green
                const Color(0xFFF0FCFA), // very light green
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isMobile ? size.width : 400,
                  minHeight:
                      size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Section with Illustration
                    SizedBox(
                      height: isMobile ? size.height * 0.30 : 200,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          // Sky and Landscape Illustration
                          CustomPaint(
                            painter: SkyLandscapePainter(),
                            size: Size(
                              size.width,
                              isMobile ? size.height * 0.30 : 200,
                            ),
                          ),
                          // Hello Text
                          Positioned(
                            left: 24,
                            bottom: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'HELLO',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF1B5E54),
                                    height: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: (isMobile ? size.width : 400) - 48,
                                  child: Text(
                                    'Start your wellness journey with MoveIT',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: const Color(0xFF5A7A76),
                                      fontWeight: FontWeight.w500,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Login Card Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Card with Shadow
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF4A9D87,
                                  ).withOpacity(0.15),
                                  blurRadius: 25,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Name Field (if registering)
                                  if (!widget.isLogin) ...[
                                    _buildInputField(
                                      controller: _nameController,
                                      placeholder: 'Full Name',
                                      icon: Icons.person_outline,
                                      keyboardType: TextInputType.name,
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  // Email Field
                                  _buildInputField(
                                    controller: _emailController,
                                    placeholder: 'Email Address',
                                    icon: Icons.mail_outline,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 16),
                                  // Password Field
                                  _buildPasswordField(
                                    controller: _passwordController,
                                    placeholder: 'Password',
                                    obscureText: _obscurePassword,
                                    onVisibilityToggle: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  // Forgot Password Link (only on login)
                                  if (widget.isLogin)
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: loading
                                            ? null
                                            : () async {
                                                final email = _emailController
                                                    .text
                                                    .trim();
                                                if (email.isEmpty) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Please enter your email to reset',
                                                      ),
                                                    ),
                                                  );
                                                  return;
                                                }
                                                try {
                                                  await context
                                                      .read<AuthProvider>()
                                                      .resetPassword(email);
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          'Password reset link sent',
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                } catch (e) {
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          e.toString(),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }
                                              },
                                        child: Text(
                                          'Forgot password?',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF4A9D87),
                                          ),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 24),
                                  // Sign In / Register Button
                                  _buildGradientButton(
                                    onPressed: loading ? null : _submit,
                                    isLoading: loading,
                                    label: widget.isLogin
                                        ? 'Sign In'
                                        : 'Sign Up',
                                  ),
                                  // Error Message
                                  if (_error != null) ...[
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _error!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Sign Up / Sign In Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.isLogin
                                    ? 'Don\'t have an account? '
                                    : 'Already have an account? ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: const Color(0xFF5A7A76),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (widget.isLogin) {
                                    context.go(Routes.register);
                                  } else {
                                    context.go(Routes.login);
                                  }
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  widget.isLogin ? 'Sign Up' : 'Sign In',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2D8A75),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Bottom Fitness Illustration
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 24),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio:
                              9 / 5, // Responsive square-ish aspect ratio
                          child: Image.asset(
                            'assets/images/fitness_illustration.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback if image not found
                              return Container(
                                color: const Color(0xFFE0F8F1),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.fitness_center,
                                        size: 48,
                                        color: const Color(0xFF4A9D87),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Fitness Illustration',
                                        style: TextStyle(
                                          color: const Color(0xFF5A7A76),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String placeholder,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5FFFE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4EBE5), width: 1.5),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF1B5E54),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: const TextStyle(
            color: Color(0xFFA8C4BD),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF4A9D87), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String placeholder,
    required bool obscureText,
    required VoidCallback onVisibilityToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5FFFE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4EBE5), width: 1.5),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF1B5E54),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: const TextStyle(
            color: Color(0xFFA8C4BD),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: const Color(0xFF4A9D87),
            size: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF4A9D87),
              size: 20,
            ),
            onPressed: onVisibilityToggle,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required VoidCallback? onPressed,
    required bool isLoading,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2D8A75), // deep green
            Color(0xFF1B5E54), // forest green
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D8A75).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Painter for Sky and Landscape
class SkyLandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Sky background gradient
    final skyGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF87CEEB).withOpacity(0.3),
        const Color(0xFFC8E6E5).withOpacity(0.2),
      ],
    );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = skyGradient.createShader(
          Rect.fromLTWH(0, 0, size.width, size.height),
        ),
    );

    // Soft clouds
    _drawCloud(canvas, size.width * 0.15, size.height * 0.15, 30, 15);
    _drawCloud(canvas, size.width * 0.75, size.height * 0.25, 40, 18);
    _drawCloud(canvas, size.width * 0.35, size.height * 0.35, 25, 12);

    // Sun
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.15),
      18,
      Paint()..color = const Color(0xFFFDB813).withOpacity(0.3),
    );

    // Green grass field
    final grassPaint = Paint()
      ..color = const Color(0xFF4A9D87).withOpacity(0.4)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.65, size.width, size.height * 0.35),
      grassPaint,
    );

    // Darker grass line
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.64, size.width, 2),
      Paint()..color = const Color(0xFF2D8A75).withOpacity(0.3),
    );

    // City silhouette
    _drawCitySilhouette(canvas, size);

    // Trees on sides
    _drawTree(canvas, 20, size.height * 0.5, 25, 40);
    _drawTree(canvas, size.width - 40, size.height * 0.48, 28, 45);
  }

  /// Draw a single soft cloud shape
  void _drawCloud(
    Canvas canvas,
    double x,
    double y,
    double width,
    double height,
  ) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, width, height),
        const Radius.circular(8),
      ),
      paint,
    );
  }

  /// Draw city silhouette buildings in the background
  void _drawCitySilhouette(Canvas canvas, Size size) {
    final silhouettePaint = Paint()
      ..color = const Color(0xFF1B5E54).withOpacity(0.15);

    // Building shapes
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.52, 35, 35),
      silhouettePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.25, size.height * 0.48, 30, 40),
      silhouettePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.4, size.height * 0.55, 25, 32),
      silhouettePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.65, size.height * 0.50, 28, 37),
      silhouettePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.8, size.height * 0.54, 32, 33),
      silhouettePaint,
    );
  }

  /// Draw a tree with trunk and foliage
  void _drawTree(
    Canvas canvas,
    double x,
    double y,
    double width,
    double height,
  ) {
    final treePaint = Paint()
      ..color = const Color(0xFF2D8A75).withOpacity(0.25);

    // Trunk
    canvas.drawRect(
      Rect.fromLTWH(x - 3, y + height * 0.6, 6, height * 0.4),
      treePaint,
    );

    // Foliage with multiple circles for depth
    canvas.drawCircle(Offset(x, y + height * 0.4), width / 2, treePaint);
    canvas.drawCircle(
      Offset(x - width * 0.3, y + height * 0.5),
      width * 0.35,
      treePaint,
    );
    canvas.drawCircle(
      Offset(x + width * 0.3, y + height * 0.5),
      width * 0.35,
      treePaint,
    );
  }

  @override
  bool shouldRepaint(SkyLandscapePainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import '../../app/widgets/custom_checkbox.dart';
import '../../app/widgets/custom_divider.dart';
import '../../app/widgets/custom_form_field.dart';
import '../../app/widgets/custom_text_button.dart';
import '../../app/widgets/social_button.dart';
import '../../core/core.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeToTerms = false;
  bool _agreeToPrivacy = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeToTerms || !_agreeToPrivacy) {
      _showErrorSnackBar('Please agree to the terms and privacy policy');
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signUpWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text,
      _nameController.text.trim(),
    );

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/main');
    } else if (mounted) {
      _showErrorSnackBar(authProvider.errorMessage ?? 'Sign up failed');
    }
  }

  Future<void> _signUpWithGoogle() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signInWithGoogle();

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/main');
    } else if (mounted) {
      _showErrorSnackBar(authProvider.errorMessage ?? 'Google sign-up failed');
    }
  }

  Future<void> _signUpWithApple() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signInWithApple();

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/main');
    } else if (mounted) {
      _showErrorSnackBar(authProvider.errorMessage ?? 'Apple sign-up failed');
    }
  }

  void _showErrorSnackBar(String message) {
    context.showErrorSnackBar(message);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: mediaQuery.size.height - mediaQuery.padding.top,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Form Section
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                      ),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Welcome Text
                            Text(
                              'Create Account',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sign up to start managing your finances',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.7,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 40),

                            // Signup Form
                            Expanded(
                              child: Form(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      // Full Name Field
                                      CustomFormField(
                                        controller: _nameController,
                                        label: 'Full Name',
                                        hint: 'Enter your full name',
                                        icon: Icons.person_outline,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Please enter your full name';
                                          }
                                          if (value.trim().length < 2) {
                                            return 'Name must be at least 2 characters';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 24),

                                      // Email Field
                                      CustomFormField(
                                        controller: _emailController,
                                        label: 'Email',
                                        hint: 'Enter your email address',
                                        icon: Icons.email_outlined,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          if (!RegExp(
                                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                          ).hasMatch(value)) {
                                            return 'Please enter a valid email';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 24),

                                      // Password Field
                                      CustomFormField(
                                        controller: _passwordController,
                                        label: 'Password',
                                        hint: 'Create a strong password',
                                        icon: Icons.lock_outlined,
                                        isPassword: true,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a password';
                                          }
                                          if (value.length < 8) {
                                            return 'Password must be at least 8 characters';
                                          }
                                          if (!RegExp(
                                            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)',
                                          ).hasMatch(value)) {
                                            return 'Password must contain uppercase, lowercase, and number';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 24),

                                      // Confirm Password Field
                                      CustomFormField(
                                        controller: _confirmPasswordController,
                                        label: 'Confirm Password',
                                        hint: 'Confirm your password',
                                        icon: Icons.lock_outline,
                                        isPassword: true,
                                        isConfirmPassword: true,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please confirm your password';
                                          }
                                          if (value !=
                                              _passwordController.text) {
                                            return 'Passwords do not match';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 32),

                                      // Terms and Privacy Checkboxes
                                      CustomCheckbox(
                                        value: _agreeToTerms,
                                        onChanged: (value) => setState(
                                          () => _agreeToTerms = value ?? false,
                                        ),
                                        label: 'I agree to the ',
                                        linkText: 'Terms of Service',
                                        onLinkTap: () => _showTermsDialog(),
                                      ),
                                      const SizedBox(height: 16),
                                      CustomCheckbox(
                                        value: _agreeToPrivacy,
                                        onChanged: (value) => setState(
                                          () =>
                                              _agreeToPrivacy = value ?? false,
                                        ),
                                        label: 'I agree to the ',
                                        linkText: 'Privacy Policy',
                                        onLinkTap: () => _showPrivacyDialog(),
                                      ),
                                      const SizedBox(height: 40),

                                      // Sign Up Button
                                      Consumer<AuthProvider>(
                                        builder:
                                            (context, authProvider, child) {
                                              return PrimaryButton(
                                                text: 'Create Account',
                                                onPressed:
                                                    authProvider.isLoading
                                                    ? null
                                                    : _signUp,
                                                isLoading:
                                                    authProvider.isLoading,
                                              );
                                            },
                                      ),
                                      const SizedBox(height: 32),

                                      // OR Divider
                                      CustomDivider(
                                        text: 'OR',
                                        color: theme.colorScheme.onSurface,
                                      ),
                                      const SizedBox(height: 32),

                                      // Social Sign Up Buttons
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SocialButton(
                                              onPressed: _signUpWithGoogle,
                                              icon: Icons.g_mobiledata,
                                              label: 'Google',
                                              color: const Color(0xFFDB4437),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: SocialButton(
                                              onPressed: _signUpWithApple,
                                              icon: Icons.apple,
                                              label: 'Apple',
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 32),

                                      // Sign In Link
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Already have an account? ',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface
                                                      .withOpacity(0.7),
                                                ),
                                          ),
                                          CustomTextButton(
                                            text: 'Sign In',
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            textColor:
                                                theme.colorScheme.primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
          ),
        ),
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => _InfoDialog(
        title: 'Terms of Service',
        content:
            'By using KAS Finance, you agree to our terms of service. This includes accepting responsibility for your financial decisions and understanding that this app is for informational purposes only.',
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => _InfoDialog(
        title: 'Privacy Policy',
        content:
            'We respect your privacy and are committed to protecting your personal information. Your data is encrypted and stored securely. We never share your information with third parties without your consent.',
      ),
    );
  }
}

class _InfoDialog extends StatelessWidget {
  final String title;
  final String content;

  const _InfoDialog({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(
                Icons.info_outline,
                color: theme.colorScheme.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Got it'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

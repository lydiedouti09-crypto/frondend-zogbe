import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/auth_provider.dart';
import '../widgets/zogbe_logo.dart';
import '../widgets/zogbe_mascot.dart';
import '../widgets/ethnic_decorations.dart';
import 'register_screen.dart';
import 'main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;

    if (identifier.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez renseigner votre identifiant et mot de passe.'),
          backgroundColor: ZogbeTheme.redOilBrown,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final res = await context.read<AuthProvider>().login(
      identifier: identifier,
      password: password,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message'] ?? 'Ravi de vous revoir !'),
          backgroundColor: ZogbeTheme.accentGreen,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['error'] ?? 'Identifiant ou mot de passe incorrect.'),
          backgroundColor: ZogbeTheme.redOilBrown,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: ZogbeTheme.kraftLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. En-tête incurvé concave en marron foncé avec le logo Zògbé
            ClipPath(
              clipper: HeaderWaveClipper(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, bottom: 45),
                color: ZogbeTheme.darkBrown,
                child: const Column(
                  children: [
                    ZogbeLogo(
                      size: 70,
                      vertical: true,
                      lightText: true,
                      subtitle: 'Le goût du Togo, à portée de main',
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  // 2. Titre "Bienvenue" + séparateur à losanges
                  Text(
                    'Bienvenue',
                    style: GoogleFonts.outfit(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: ZogbeTheme.darkBrown,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const DiamondSeparator(width: 140),

                  const SizedBox(height: 14),

                  // 3. Mascotte du canari qui pointe du doigt
                  const Center(
                    child: ZogbeMascot(
                      size: 95,
                      pointingRight: true,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. Champ Email / Téléphone
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF7EE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ZogbeTheme.gariOrange.withOpacity(0.8), width: 1.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.email_outlined, color: ZogbeTheme.darkBrown, size: 22),
                        const SizedBox(width: 10),
                        Container(
                          height: 24,
                          width: 1.2,
                          color: ZogbeTheme.darkBrown.withOpacity(0.3),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _identifierController,
                            style: GoogleFonts.plusJakartaSans(
                              color: ZogbeTheme.darkBrown,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: 'email ou téléphone',
                              hintStyle: GoogleFonts.plusJakartaSans(
                                color: ZogbeTheme.darkBrown.withOpacity(0.5),
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 5. Champ Mot de passe
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF7EE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ZogbeTheme.kraftBorder, width: 1.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_outline, color: ZogbeTheme.darkBrown, size: 22),
                        const SizedBox(width: 10),
                        Container(
                          height: 24,
                          width: 1.2,
                          color: ZogbeTheme.darkBrown.withOpacity(0.3),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: GoogleFonts.plusJakartaSans(
                              color: ZogbeTheme.darkBrown,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: 'mot de passe',
                              hintStyle: GoogleFonts.plusJakartaSans(
                                color: ZogbeTheme.darkBrown.withOpacity(0.5),
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: ZogbeTheme.darkBrown.withOpacity(0.7),
                            size: 22,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 6. "Se souvenir de moi" et "Mot de passe oublié ?"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Switch(
                            value: auth.rememberMe,
                            activeColor: ZogbeTheme.darkBrown,
                            activeTrackColor: ZogbeTheme.kraftBorder,
                            inactiveThumbColor: ZogbeTheme.darkBrown.withOpacity(0.5),
                            inactiveTrackColor: ZogbeTheme.kraftDark,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            onChanged: (val) => auth.toggleRememberMe(val),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Se souvenir de moi',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: ZogbeTheme.darkBrown,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Mot de passe oublié ?',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: ZogbeTheme.darkBrown,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 7. Bouton "Se connecter"
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _onLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ZogbeTheme.gariOrange,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : Text(
                              'Se connecter',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 8. Frise géométrique togolais
                  const EthnicChevronBorder(height: 20),

                  const SizedBox(height: 18),

                  // 9. Pied de page : "Pas encore de compte ? S'inscrire"
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: ZogbeTheme.darkBrown,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pas encore de compte ? ',
                          style: GoogleFonts.plusJakartaSans(
                            color: ZogbeTheme.kraftLight,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const RegisterScreen()),
                            );
                          },
                          child: Text(
                            'S’inscrire',
                            style: GoogleFonts.plusJakartaSans(
                              color: ZogbeTheme.gariOrange,
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

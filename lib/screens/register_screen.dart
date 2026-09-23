import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../providers/auth_provider.dart';
import '../widgets/zogbe_logo.dart';
import '../widgets/zogbe_mascot.dart';
import '../widgets/ethnic_decorations.dart';
import 'main_navigation_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(text: '+228 ');
  final TextEditingController _passwordController = TextEditingController();
  String _selectedQuartier = 'Adjougba, Lomé';
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer votre nom complet.'),
          backgroundColor: ZogbeTheme.redOilBrown,
        ),
      );
      return;
    }

    if (phone.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un numéro de téléphone valide.'),
          backgroundColor: ZogbeTheme.redOilBrown,
        ),
      );
      return;
    }

    if (password.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le mot de passe doit comporter au moins 4 caractères.'),
          backgroundColor: ZogbeTheme.redOilBrown,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final res = await context.read<AuthProvider>().register(
      name: name,
      email: email,
      phone: phone,
      password: password,
      quartier: _selectedQuartier,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message'] ?? 'Bienvenue chez Zògbé ! Compte créé.'),
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
          content: Text(res['error'] ?? 'Erreur lors de l’inscription.'),
          backgroundColor: ZogbeTheme.redOilBrown,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZogbeTheme.kraftLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. En-tête incurvé concave avec logo flamme
            ClipPath(
              clipper: HeaderWaveClipper(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, bottom: 45),
                color: ZogbeTheme.darkBrown,
                child: const Column(
                  children: [
                    ZogbeLogo(
                      size: 65,
                      vertical: true,
                      lightText: true,
                      showFlame: true,
                      subtitle: 'Le goût du Togo, chez vous.',
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),

                  // 2. Titre "Créer un compte" + séparateur à losanges
                  Center(
                    child: Text(
                      'Créer un compte',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: ZogbeTheme.darkBrown,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(child: DiamondSeparator(width: 140)),

                  const SizedBox(height: 18),

                  // 3. Champ Nom
                  Text(
                    'Nom complet',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ZogbeTheme.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF7EE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ZogbeTheme.kraftBorder, width: 1.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _nameController,
                            style: GoogleFonts.plusJakartaSans(
                              color: ZogbeTheme.darkBrown,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'ex: Koffi Mensah',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        const Icon(Icons.person_outline, color: ZogbeTheme.darkBrown, size: 20),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Champ Email
                  Text(
                    'Adresse e-mail',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ZogbeTheme.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF7EE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ZogbeTheme.kraftBorder, width: 1.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.plusJakartaSans(
                              color: ZogbeTheme.darkBrown,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'ex: koffi.mensah@gmail.com',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        const Icon(Icons.email_outlined, color: ZogbeTheme.darkBrown, size: 20),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 4. Champ Téléphone + Mascotte à droite
                  Text(
                    'Téléphone',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ZogbeTheme.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBF7EE),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: ZogbeTheme.accentGreen, width: 1.5),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              child: Row(
                                children: [
                                  // Drapeau du Togo 🇹🇬
                                  Container(
                                    width: 28,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26, width: 0.5),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: const Center(
                                      child: Text('🇹🇬', style: TextStyle(fontSize: 14)),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: _phoneController,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: ZogbeTheme.darkBrown,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.check_circle, color: ZogbeTheme.accentGreen, size: 20),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.check_circle, color: ZogbeTheme.accentGreen, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  'Numéro valide',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: ZogbeTheme.accentGreen,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Mascotte avec cœur
                      const SizedBox(
                        width: 90,
                        height: 80,
                        child: ZogbeMascot(
                          size: 70,
                          pointingRight: false,
                          withHeartBubble: true,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 5. Champ Mot de passe
                  Text(
                    'Mot de passe',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ZogbeTheme.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF7EE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ZogbeTheme.kraftBorder, width: 1.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: GoogleFonts.plusJakartaSans(
                              color: ZogbeTheme.darkBrown,
                              fontSize: 15,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Créez un mot de passe',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
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

                  const SizedBox(height: 14),

                  // 6. Quartier / zone de livraison
                  Text(
                    'Quartier / zone de livraison',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ZogbeTheme.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF7EE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ZogbeTheme.kraftBorder, width: 1.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedQuartier,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: ZogbeTheme.darkBrown),
                        items: AppConstants.quartiersLome.map((q) {
                          return DropdownMenuItem<String>(
                            value: q,
                            child: Row(
                              children: [
                                const Icon(Icons.location_on, color: ZogbeTheme.darkBrown, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  q,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: ZogbeTheme.darkBrown,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedQuartier = val);
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 7. Frise ethnique
                  const EthnicChevronBorder(height: 20),

                  const SizedBox(height: 16),

                  // 8. Bouton S'inscrire
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _onRegister,
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
                              'S’inscrire',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 9. Lien "Vous avez déjà un compte ? Connexion"
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Vous avez déjà un compte ? ',
                          style: GoogleFonts.plusJakartaSans(
                            color: ZogbeTheme.darkBrown,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Connexion',
                            style: GoogleFonts.plusJakartaSans(
                              color: ZogbeTheme.redOilBrown,
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Center(
                    child: ZogbeLogo(size: 28, showText: false, showFlame: true),
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

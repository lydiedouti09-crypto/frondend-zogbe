import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../providers/auth_provider.dart';
import '../widgets/ethnic_decorations.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: ZogbeTheme.kraftLight,
      appBar: AppBar(
        title: Text(
          'Mon Profil',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            color: ZogbeTheme.darkBrown,
            fontSize: 24,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Carte Avatar & Nom
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEFE6D5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ZogbeTheme.kraftBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: ZogbeTheme.darkBrown,
                      shape: BoxShape.circle,
                      border: Border.all(color: ZogbeTheme.gariOrange, width: 2.5),
                    ),
                    child: Center(
                      child: Text(
                        auth.userName.isNotEmpty ? auth.userName.substring(0, 1) : 'K',
                        style: GoogleFonts.outfit(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: ZogbeTheme.kraftLight,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auth.userName,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ZogbeTheme.darkBrown,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          auth.userPhone,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: ZogbeTheme.darkBrown.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: ZogbeTheme.gariOrange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Client Fidèle Zògbé 🇹🇬',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Options de Paramètres
            _buildSettingCard(
              context: context,
              icon: Icons.location_on,
              title: 'Quartier de livraison',
              subtitle: auth.selectedQuartier,
              onTap: () => _showQuartierDialog(context, auth),
            ),

            _buildSettingCard(
              context: context,
              icon: Icons.history,
              title: 'Historique de mes commandes',
              subtitle: 'Voir mes plats commandés',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Historique synchronisé avec le restaurant !')),
                );
              },
            ),

            _buildSettingCard(
              context: context,
              icon: Icons.phone,
              title: 'Support & Restaurant',
              subtitle: '+228 90 00 00 00 / contact@zogbe.tg',
              onTap: () {},
            ),

            const SizedBox(height: 16),
            const EthnicChevronBorder(height: 16),
            const SizedBox(height: 16),

            // Bouton Déconnexion
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  auth.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ZogbeTheme.redOilBrown,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Se déconnecter',
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFE6D5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ZogbeTheme.kraftBorder),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ZogbeTheme.gariOrange,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: ZogbeTheme.darkBrown, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: ZogbeTheme.darkBrown.withOpacity(0.7)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: ZogbeTheme.darkBrown),
        onTap: onTap,
      ),
    );
  }

  void _showQuartierDialog(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ZogbeTheme.kraftLight,
        title: Text(
          'Changer mon quartier',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: ZogbeTheme.darkBrown),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: AppConstants.quartiersLome.length,
            itemBuilder: (ctx, i) {
              final q = AppConstants.quartiersLome[i];
              final isCur = q == auth.selectedQuartier;
              return ListTile(
                leading: const Icon(Icons.location_on, color: ZogbeTheme.gariOrange),
                title: Text(
                  q,
                  style: GoogleFonts.plusJakartaSans(fontWeight: isCur ? FontWeight.bold : FontWeight.normal),
                ),
                trailing: isCur ? const Icon(Icons.check, color: ZogbeTheme.accentGreen) : null,
                onTap: () {
                  auth.setQuartier(q);
                  Navigator.pop(ctx);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

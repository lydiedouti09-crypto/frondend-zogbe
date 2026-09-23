import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';

/// Frise ethnique togolais en chevrons / zigzag
class EthnicChevronBorder extends StatelessWidget {
  final double height;
  final Color? baseColor;

  const EthnicChevronBorder({
    super.key,
    this.height = 20,
    this.baseColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: ChevronPatternPainter(),
      ),
    );
  }
}

class ChevronPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double step = 24.0;
    final int count = (size.width / step).ceil() + 1;
    final double h = size.height;

    // Palette de la frise
    final List<Color> colors = [
      ZogbeTheme.darkBrown,
      ZogbeTheme.gariOrange,
      ZogbeTheme.darkGreen,
      ZogbeTheme.redOilBrown,
    ];

    for (int i = 0; i < count; i++) {
      double startX = i * step;
      Color color = colors[i % colors.length];

      Paint paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      Path path = Path();
      path.moveTo(startX - step / 2, h * 0.8);
      path.lineTo(startX, h * 0.2);
      path.lineTo(startX + step / 2, h * 0.8);

      canvas.drawPath(path, paint);

      // Deuxième chevron imbriqué
      Path innerPath = Path();
      innerPath.moveTo(startX - step / 2, h);
      innerPath.lineTo(startX, h * 0.45);
      innerPath.lineTo(startX + step / 2, h);
      canvas.drawPath(innerPath, paint..strokeWidth = 2.0);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Séparateur avec losanges dorés
class DiamondSeparator extends StatelessWidget {
  final double width;

  const DiamondSeparator({super.key, this.width = 160});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width * 0.35,
          height: 1.5,
          color: ZogbeTheme.goldAccent.withOpacity(0.6),
        ),
        const SizedBox(width: 8),
        Transform.rotate(
          angle: 0.785398, // 45 degrés
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: ZogbeTheme.goldAccent,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Transform.rotate(
          angle: 0.785398,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              border: Border.all(color: ZogbeTheme.goldAccent, width: 2),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Transform.rotate(
          angle: 0.785398,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: ZogbeTheme.goldAccent,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: width * 0.35,
          height: 1.5,
          color: ZogbeTheme.goldAccent.withOpacity(0.6),
        ),
      ],
    );
  }
}

/// Découpe incurvée en vague concave pour les en-têtes
class HeaderWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    // Courbe concave fluide
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Badge de disponibilité vert
class DispoBadge extends StatelessWidget {
  final bool isDispo;
  final bool compact;

  const DispoBadge({
    super.key,
    this.isDispo = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isDispo) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'ÉPUISÉ',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: BoxDecoration(
          color: ZogbeTheme.accentGreenBg,
          border: Border.all(color: ZogbeTheme.accentGreen, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: ZogbeTheme.accentGreen, size: 11),
            const SizedBox(width: 3),
            Text(
              'DISPO',
              style: GoogleFonts.plusJakartaSans(
                color: ZogbeTheme.accentGreen,
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: ZogbeTheme.darkGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.eco, color: Colors.white, size: 13),
          const SizedBox(width: 5),
          Text(
            'Disponible',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge de prix stylisé sous forme de ticket/fanion
class PriceTicketBadge extends StatelessWidget {
  final String price;

  const PriceTicketBadge({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ZogbeTheme.gariOrange,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: ZogbeTheme.gariOrange.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Text(
        price,
        style: GoogleFonts.outfit(
          color: Colors.white,
          fontSize: 12.5,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

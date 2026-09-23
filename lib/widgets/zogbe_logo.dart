import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';

class ZogbeLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool vertical;
  final bool lightText;
  final String? subtitle;
  final bool showFlame;

  const ZogbeLogo({
    super.key,
    this.size = 64,
    this.showText = true,
    this.vertical = false,
    this.lightText = false,
    this.subtitle,
    this.showFlame = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget icon = SizedBox(
      width: size,
      height: size * (showFlame ? 1.2 : 0.9),
      child: CustomPaint(
        painter: ZogbeBowlPainter(showFlame: showFlame),
      ),
    );

    if (!showText) {
      return icon;
    }

    final Color textColor = lightText ? ZogbeTheme.gariOrange : ZogbeTheme.darkBrown;

    Widget textBlock = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: vertical ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Z',
              style: GoogleFonts.outfit(
                fontSize: size * 0.45,
                fontWeight: FontWeight.w900,
                color: textColor,
                letterSpacing: -0.5,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'o',
                  style: GoogleFonts.outfit(
                    fontSize: size * 0.45,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                    height: 1.0,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 1),
                  width: size * 0.16,
                  height: 3,
                  decoration: BoxDecoration(
                    color: textColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            Text(
              'gbé',
              style: GoogleFonts.outfit(
                fontSize: size * 0.45,
                fontWeight: FontWeight.w900,
                color: textColor,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: GoogleFonts.plusJakartaSans(
              fontSize: size * 0.16,
              fontWeight: FontWeight.w500,
              color: lightText ? ZogbeTheme.kraftLight.withOpacity(0.9) : ZogbeTheme.darkBrown.withOpacity(0.8),
            ),
            textAlign: vertical ? TextAlign.center : TextAlign.left,
          ),
        ],
      ],
    );

    if (vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 10),
          textBlock,
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        const SizedBox(width: 12),
        textBlock,
      ],
    );
  }
}

class ZogbeBowlPainter extends CustomPainter {
  final bool showFlame;

  ZogbeBowlPainter({this.showFlame = false});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Paint darkPaint = Paint()
      ..color = ZogbeTheme.darkBrown
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final Paint redPaint = Paint()
      ..color = ZogbeTheme.redOilBrown
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final Paint orangePaint = Paint()
      ..color = ZogbeTheme.gariOrange
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final Paint whitePaint = Paint()
      ..color = ZogbeTheme.kraftLight
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final Paint linePaint = Paint()
      ..color = ZogbeTheme.darkBrown
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.04
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    double topOffset = showFlame ? h * 0.25 : 0;
    double bowlHeight = h - topOffset;

    // 1. Flamme supérieure si activée
    if (showFlame) {
      Path flamePath = Path();
      flamePath.moveTo(w * 0.5, h * 0.02);
      flamePath.quadraticBezierTo(w * 0.65, h * 0.12, w * 0.58, h * 0.22);
      flamePath.quadraticBezierTo(w * 0.5, h * 0.25, w * 0.42, h * 0.22);
      flamePath.quadraticBezierTo(w * 0.35, h * 0.12, w * 0.5, h * 0.02);
      flamePath.close();
      canvas.drawPath(flamePath, orangePaint);

      // Cœur de la flamme
      Path flameInner = Path();
      flameInner.moveTo(w * 0.5, h * 0.08);
      flameInner.quadraticBezierTo(w * 0.58, h * 0.15, w * 0.54, h * 0.21);
      flameInner.quadraticBezierTo(w * 0.5, h * 0.23, w * 0.46, h * 0.21);
      flameInner.quadraticBezierTo(w * 0.42, h * 0.15, w * 0.5, h * 0.08);
      flameInner.close();
      canvas.drawPath(flameInner, Paint()..color = ZogbeTheme.kraftLight);
    }

    // 2. Bol inférieur : Demi-lune rouge terre cuite
    Rect bottomBowlRect = Rect.fromLTWH(
      w * 0.15,
      topOffset + bowlHeight * 0.48,
      w * 0.7,
      bowlHeight * 0.5,
    );
    Path bottomBowl = Path()
      ..addArc(bottomBowlRect, 0, 3.14159);
    canvas.drawPath(bottomBowl, redPaint);

    // 3. Fond de la section à motifs (Beige / Blanc)
    Path patternBg = Path();
    patternBg.moveTo(w * 0.08, topOffset + bowlHeight * 0.22);
    patternBg.quadraticBezierTo(w * 0.5, topOffset + bowlHeight * 0.38, w * 0.92, topOffset + bowlHeight * 0.22);
    patternBg.lineTo(w * 0.85, topOffset + bowlHeight * 0.52);
    patternBg.lineTo(w * 0.15, topOffset + bowlHeight * 0.52);
    patternBg.close();
    canvas.drawPath(patternBg, whitePaint);

    // 4. Bord supérieur incurvé (Corniche du bol)
    Path rim = Path();
    rim.moveTo(w * 0.06, topOffset + bowlHeight * 0.18);
    rim.quadraticBezierTo(w * 0.5, topOffset + bowlHeight * 0.35, w * 0.94, topOffset + bowlHeight * 0.18);
    rim.quadraticBezierTo(w * 0.5, topOffset + bowlHeight * 0.25, w * 0.06, topOffset + bowlHeight * 0.18);
    rim.close();
    canvas.drawPath(rim, darkPaint);

    // 5. Motifs géométriques togolais au centre (Losange central + triangles)
    Path diamondDark = Path();
    diamondDark.moveTo(w * 0.5, topOffset + bowlHeight * 0.30);
    diamondDark.lineTo(w * 0.63, topOffset + bowlHeight * 0.42);
    diamondDark.lineTo(w * 0.5, topOffset + bowlHeight * 0.52);
    diamondDark.lineTo(w * 0.37, topOffset + bowlHeight * 0.42);
    diamondDark.close();
    canvas.drawPath(diamondDark, darkPaint);

    Path diamondOrange = Path();
    diamondOrange.moveTo(w * 0.5, topOffset + bowlHeight * 0.35);
    diamondOrange.lineTo(w * 0.57, topOffset + bowlHeight * 0.42);
    diamondOrange.lineTo(w * 0.5, topOffset + bowlHeight * 0.48);
    diamondOrange.lineTo(w * 0.43, topOffset + bowlHeight * 0.42);
    diamondOrange.close();
    canvas.drawPath(diamondOrange, orangePaint);

    Path leftTri = Path();
    leftTri.moveTo(w * 0.12, topOffset + bowlHeight * 0.26);
    leftTri.lineTo(w * 0.32, topOffset + bowlHeight * 0.42);
    leftTri.lineTo(w * 0.18, topOffset + bowlHeight * 0.52);
    leftTri.close();
    canvas.drawPath(leftTri, redPaint);

    Path rightTri = Path();
    rightTri.moveTo(w * 0.88, topOffset + bowlHeight * 0.26);
    rightTri.lineTo(w * 0.68, topOffset + bowlHeight * 0.42);
    rightTri.lineTo(w * 0.82, topOffset + bowlHeight * 0.52);
    rightTri.close();
    canvas.drawPath(rightTri, redPaint);

    canvas.drawLine(
      Offset(w * 0.15, topOffset + bowlHeight * 0.52),
      Offset(w * 0.85, topOffset + bowlHeight * 0.52),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

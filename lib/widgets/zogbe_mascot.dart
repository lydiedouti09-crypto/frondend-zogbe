import 'package:flutter/material.dart';
import '../core/theme.dart';

class ZogbeMascot extends StatelessWidget {
  final double size;
  final bool pointingRight;
  final bool withHeartBubble;

  const ZogbeMascot({
    super.key,
    this.size = 110,
    this.pointingRight = true,
    this.withHeartBubble = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.3,
      height: size,
      child: CustomPaint(
        painter: MascotPainter(
          pointingRight: pointingRight,
          withHeartBubble: withHeartBubble,
        ),
      ),
    );
  }
}

class MascotPainter extends CustomPainter {
  final bool pointingRight;
  final bool withHeartBubble;

  MascotPainter({
    required this.pointingRight,
    required this.withHeartBubble,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Ombre au sol
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.12)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.45, h * 0.92), width: w * 0.55, height: h * 0.1),
      shadowPaint,
    );

    // Corps du canari en terre cuite
    final Paint bodyPaint = Paint()
      ..color = const Color(0xFF8D5338)
      ..style = PaintingStyle.fill;

    // Dessin du bol/canari
    Path bodyPath = Path();
    bodyPath.moveTo(w * 0.2, h * 0.38);
    bodyPath.lineTo(w * 0.68, h * 0.38);
    bodyPath.lineTo(w * 0.58, h * 0.82);
    bodyPath.lineTo(w * 0.30, h * 0.82);
    bodyPath.close();
    canvas.drawPath(bodyPath, bodyPaint);

    // Motifs traditionnels gravés sur le bol
    final Paint patternPaint = Paint()
      ..color = const Color(0xFF673822)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Path pat1 = Path();
    pat1.moveTo(w * 0.22, h * 0.5);
    pat1.lineTo(w * 0.32, h * 0.7);
    pat1.lineTo(w * 0.42, h * 0.5);
    pat1.lineTo(w * 0.52, h * 0.7);
    pat1.lineTo(w * 0.62, h * 0.5);
    canvas.drawPath(pat1, patternPaint);

    // Bord supérieur du canari
    final Paint rimPaint = Paint()
      ..color = const Color(0xFF5A2E1A)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.18, h * 0.35, w * 0.52, h * 0.08),
        const Radius.circular(4),
      ),
      rimPaint,
    );

    // Yeux expressifs
    final Paint whitePaint = Paint()..color = Colors.white;
    final Paint pupilPaint = Paint()..color = const Color(0xFF1E100D);
    final Paint pupilLight = Paint()..color = Colors.white;

    // Œil gauche
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.36, h * 0.55), width: w * 0.1, height: h * 0.18),
      whitePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.37, h * 0.55), width: w * 0.06, height: h * 0.12),
      pupilPaint,
    );
    canvas.drawCircle(Offset(w * 0.35, h * 0.52), 2.5, pupilLight);

    // Œil droit
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.48, h * 0.55), width: w * 0.1, height: h * 0.18),
      whitePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.49, h * 0.55), width: w * 0.06, height: h * 0.12),
      pupilPaint,
    );
    canvas.drawCircle(Offset(w * 0.47, h * 0.52), 2.5, pupilLight);

    // Bouche souriante
    final Paint mouthPaint = Paint()
      ..color = const Color(0xFF1E100D)
      ..style = PaintingStyle.fill;
    Path mouth = Path();
    mouth.moveTo(w * 0.38, h * 0.68);
    mouth.quadraticBezierTo(w * 0.44, h * 0.77, w * 0.50, h * 0.68);
    mouth.close();
    canvas.drawPath(mouth, mouthPaint);

    // Bras
    final Paint armPaint = Paint()
      ..color = const Color(0xFF2B1713)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    if (pointingRight) {
      // Bras gauche plié
      Path leftArm = Path();
      leftArm.moveTo(w * 0.22, h * 0.55);
      leftArm.quadraticBezierTo(w * 0.12, h * 0.58, w * 0.18, h * 0.68);
      canvas.drawPath(leftArm, armPaint);

      // Bras droit qui pointe vers la droite
      Path rightArm = Path();
      rightArm.moveTo(w * 0.64, h * 0.55);
      rightArm.lineTo(w * 0.88, h * 0.64);
      canvas.drawPath(rightArm, armPaint);

      // Main qui pointe
      canvas.drawCircle(Offset(w * 0.88, h * 0.64), 4.5, Paint()..color = const Color(0xFF2B1713));
      canvas.drawLine(
        Offset(w * 0.88, h * 0.64),
        Offset(w * 0.98, h * 0.68),
        armPaint..strokeWidth = 3.0,
      );
    }

    // Bulle avec cœur si inscription
    if (withHeartBubble) {
      // Bulle de dialogue
      final Paint bubblePaint = Paint()..color = Colors.white;
      final Paint bubbleBorder = Paint()
        ..color = ZogbeTheme.darkBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      Path bubble = Path();
      bubble.addOval(Rect.fromCenter(center: Offset(w * 0.78, h * 0.25), width: w * 0.28, height: h * 0.32));
      canvas.drawPath(bubble, bubblePaint);
      canvas.drawPath(bubble, bubbleBorder);

      // Cœur rouge dans la bulle
      final Paint heartPaint = Paint()..color = ZogbeTheme.redOilBrown;
      Path heart = Path();
      double hx = w * 0.78;
      double hy = h * 0.23;
      heart.moveTo(hx, hy + 5);
      heart.cubicTo(hx - 8, hy - 5, hx - 12, hy + 4, hx, hy + 12);
      heart.cubicTo(hx + 12, hy + 4, hx + 8, hy - 5, hx, hy + 5);
      canvas.drawPath(heart, heartPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

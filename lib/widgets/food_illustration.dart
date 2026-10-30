import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/product.dart';

/// Ilustrasi makanan buatan sendiri dari widget Flutter (tanpa gambar internet).
class FoodIllustration extends StatelessWidget {
  const FoodIllustration({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
  if (product.image != null) {
    return SizedBox.expand(
      child: Image.asset(
        product.image!,
        fit: BoxFit.cover,
        // Jika file tidak ketemu, otomatis pakai ilustrasi buatan sendiri
        errorBuilder: (_, _, _) => _drawn(context),
      ),
    );
  }
  return _drawn(context);
}
  Widget _drawn(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth.isFinite ? c.maxWidth : 120.0;
      final h = c.maxHeight.isFinite ? c.maxHeight : 120.0;
      final s = math.min(w, h);
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [product.background, Color.lerp(product.background, Colors.white, 0.55)!],
          ),
        ),
        child: Center(
          child: switch (product.illustration) {
            IllustrationType.plate => _plate(s),
            IllustrationType.bowl => _bowl(s),
            IllustrationType.glass => _glass(s),
          },
        ),
      );
    });
  }

  Widget _dot(double d, Color color, {bool ring = false}) => Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: ring ? Border.all(color: Colors.white, width: d * 0.18) : null,
        ),
      );

  Widget _plate(double s) {
    final d = s * 0.72;
    return SizedBox(
      width: d,
      height: d,
      child: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Color(0x22000000), blurRadius: 10, offset: Offset(0, 5))],
          ),
        ),
        Center(child: _dot(d * 0.74, product.foodColor)),
        Align(alignment: const Alignment(0.45, -0.35), child: _dot(d * 0.26, product.accent, ring: true)),
        Align(alignment: const Alignment(-0.2, 0.05), child: _dot(d * 0.13, const Color(0xFFB96A3A))),
        Align(alignment: const Alignment(0.2, 0.4), child: _dot(d * 0.11, const Color(0xFFB96A3A))),
        Align(alignment: const Alignment(-0.6, 0.5), child: _dot(d * 0.1, const Color(0xFF7BC96F))),
        Align(alignment: const Alignment(-0.45, 0.65), child: _dot(d * 0.1, const Color(0xFF7BC96F))),
      ]),
    );
  }

  Widget _bowl(double s) {
    final d = s * 0.74;
    return SizedBox(
      width: d,
      height: d * 0.8,
      child: Stack(clipBehavior: Clip.none, children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: d,
            height: d * 0.5,
            decoration: BoxDecoration(
              color: product.foodColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(d),
                bottomRight: Radius.circular(d),
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0, 0.05),
          child: Container(
            width: d * 0.9,
            height: d * 0.3,
            decoration: BoxDecoration(
              color: product.accent,
              borderRadius: BorderRadius.circular(d),
            ),
          ),
        ),
        Align(alignment: const Alignment(-0.3, -0.1), child: _dot(d * 0.12, const Color(0xFFB96A3A))),
        Align(alignment: const Alignment(0.25, 0.1), child: _dot(d * 0.1, const Color(0xFF7BC96F))),
        Positioned(
          right: d * 0.2,
          top: -d * 0.12,
          child: Transform.rotate(
            angle: 0.35,
            child: Container(width: 4, height: d * 0.55, color: const Color(0xFFB96A3A)),
          ),
        ),
      ]),
    );
  }

  Widget _glass(double s) {
    final w = s * 0.34;
    final h = s * 0.72;
    return SizedBox(
      width: w,
      height: h,
      child: Stack(clipBehavior: Clip.none, children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(150),
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(4),
              bottom: Radius.circular(w * 0.3),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(w * 0.3)),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: 0.82,
                widthFactor: 1,
                child: ColoredBox(color: product.foodColor),
              ),
            ),
          ),
        ),
        Positioned(
          right: w * 0.25,
          top: -h * 0.12,
          child: Transform.rotate(
            angle: 0.15,
            child: Container(width: 5, height: h * 0.85, color: product.accent),
          ),
        ),
      ]),
    );
  }
}

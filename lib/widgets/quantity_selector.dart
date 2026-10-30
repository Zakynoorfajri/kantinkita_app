import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.value,
    required this.onMinus,
    required this.onPlus,
    this.compact = false,
  });

  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final box = compact ? 32.0 : 44.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _btn(Icons.remove, onMinus, box, AppColors.border, AppColors.textPrimary),
        SizedBox(
          width: compact ? 36 : 48,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: compact ? 14 : 16, fontWeight: FontWeight.w700),
          ),
        ),
        _btn(Icons.add, onPlus, box, AppColors.primary, Colors.white, shadow: true),
      ],
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap, double size, Color bg, Color fg,
      {bool shadow = false}) {
    final r = BorderRadius.circular(compact ? 10 : AppRadius.field);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: r,
        boxShadow: shadow ? AppTheme.orangeShadow : null,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: r,
          onTap: onTap,
          child: Center(child: Icon(icon, size: compact ? 18 : 22, color: fg)),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import 'menu_screen.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
  }

  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Yakin ingin keluar dari akun?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) _toast(context, 'Anda telah keluar (simulasi).');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Profil', style: AppText.screenTitle),
                        RoundIconButton(
                          icon: Icons.settings_outlined,
                          onTap: () => _toast(context, 'Pengaturan belum tersedia'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.primary, AppColors.primaryDark],
                            ),
                            boxShadow: AppTheme.orangeShadow,
                          ),
                          child: const Text('ZN',
                              style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: Colors.white)),
                        ),
                        Positioned(
                          right: 4,
                          bottom: 4,
                          child: GestureDetector(
                            onTap: () => _toast(context, 'Ubah foto profil'),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.textPrimary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                              ),
                              child: const Icon(Icons.photo_camera_outlined, color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Zaky Noorfajri', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    const Text('zaky.noorfajri@kampus.ac.id',
                        style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        boxShadow: AppTheme.softShadow,
                      ),
                      child: const Row(
                        children: [
                          _Stat(value: '24', label: 'Pesanan'),
                          _Divider(),
                          _Stat(value: '8', label: 'Favorit'),
                          _Divider(),
                          _Stat(value: '1.250', label: 'Poin'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      label: 'Pesan Sekarang',
                      icon: Icons.restaurant,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: const RouteSettings(name: '/menu'),
                          builder: (_) => const MenuScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _MenuTile(
                      icon: Icons.location_on_outlined,
                      title: 'Alamat Pengantaran',
                      subtitle: 'Gedung A, Lantai 2',
                      onTap: () => _toast(context, 'Alamat: Gedung A, Lantai 2'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _MenuTile(
                      icon: Icons.card_giftcard_outlined,
                      title: 'Gunakan Poin',
                      subtitle: '1.250 poin tersedia',
                      onTap: () => _toast(context, 'Poin Anda: 1.250'),
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () => _logout(context),
              child: const Text('Keluar',
                  style: TextStyle(color: AppColors.danger, fontSize: 15, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(children: [
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ]),
      );
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 36, color: AppColors.border);
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppTheme.softShadow,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.card),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEDE5),
                    borderRadius: BorderRadius.circular(AppRadius.field),
                  ),
                  child: Icon(icon, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      Text(subtitle,
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

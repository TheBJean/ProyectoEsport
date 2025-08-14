import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_styles.dart';

class SteamAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onLogout;

  const SteamAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppStyles.appBarTitleStyle,
      ),
      backgroundColor: AppColors.darkBackground,
      centerTitle: true,
      elevation: 4,
      shadowColor: AppColors.primaryWithOpacity(0.3),
      toolbarHeight: 48,
      actions: [
        ...?actions,
        if (onLogout != null)
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.primary),
            onPressed: onLogout,
            tooltip: 'Cerrar sesión',
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}

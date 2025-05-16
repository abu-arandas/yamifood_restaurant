import '../../exports.dart';

class ThemeToggle extends StatelessWidget {
  final bool showLabel;

  const ThemeToggle({
    super.key,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return Obx(() {
      final isDarkMode = themeService.themeMode.value == ThemeMode.dark;

      return InkWell(
        onTap: themeService.switchTheme,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: isDarkMode ? AppTheme.darkSecondaryColor : AppTheme.primaryColor,
              ),
              if (showLabel) ...[
                const SizedBox(width: 8),
                Text(
                  isDarkMode ? 'Dark Mode' : 'Light Mode',
                  style: TextStyle(
                    color: isDarkMode ? AppTheme.darkTextColor : AppTheme.lightTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}

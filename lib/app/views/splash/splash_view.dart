import '/exports.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    // Navigate to home after splash animation
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Get.offNamed(Routes.HOME);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo animation
            ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'asset/images/logo.png',
                height: 150,
                width: 150,
              ),
            ),
            const SizedBox(height: 30),

            // Restaurant name with fade animation
            FadeTransition(
              opacity: _animation,
              child: const Text(
                'Yamifood Restaurant',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Arbutus Slab',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tagline
            FadeTransition(
              opacity: _animation,
              child: const Text(
                'Delicious Food Delivered',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontFamily: 'Arbutus Slab',
                ),
              ),
            ),
            const SizedBox(height: 50),

            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

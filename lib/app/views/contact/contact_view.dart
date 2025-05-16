import '../../../exports.dart';

class ContactView extends GetView<HomeController> {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final messageController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final isSubmitting = false.obs;
    final isSubmitted = false.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Contact Banner
            Container(
              height: 200,
              width: double.infinity,
              color: AppTheme.primaryColor,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.contact_support,
                      size: 60,
                      color: Colors.white,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Get in Touch',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Arbutus Slab',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'We\'d love to hear from you!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Contact Info and Form
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contact Information
                  Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Contact Information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Arbutus Slab',
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Address
                            _buildContactItem(
                              icon: Icons.location_on,
                              title: 'Address',
                              details: '123 Culinary Street, Foodie City, FC 12345',
                            ),
                            const SizedBox(height: 16),

                            // Phone
                            _buildContactItem(
                              icon: Icons.phone,
                              title: 'Phone',
                              details: '+1 (555) 123-4567',
                            ),
                            const SizedBox(height: 16),

                            // Email
                            _buildContactItem(
                              icon: Icons.email,
                              title: 'Email',
                              details: 'info@yamifood.com',
                            ),
                            const SizedBox(height: 16),

                            // Hours
                            _buildContactItem(
                              icon: Icons.access_time,
                              title: 'Hours',
                              details: 'Mon-Fri: 8am - 10pm\nSat: 9am - 11pm\nSun: 10am - 9pm',
                            ),
                            const SizedBox(height: 24),

                            // Social Media
                            const Text(
                              'Follow Us',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Arbutus Slab',
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildSocialIcon(Icons.facebook),
                                _buildSocialIcon(Icons.photo_camera),
                                _buildSocialIcon(Icons.tiktok),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Contact Form
                  Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Obx(
                          () => isSubmitted.value
                              ? _buildSuccessMessage()
                              : _buildContactForm(
                                  formKey,
                                  nameController,
                                  emailController,
                                  phoneController,
                                  messageController,
                                  isSubmitting,
                                  isSubmitted,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Map Location (Placeholder)
            Container(
              height: 300,
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map,
                      size: 50,
                      color: AppTheme.primaryColor,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Map Location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Interactive map would be displayed here',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
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

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String details,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 24,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                details,
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildContactForm(
    GlobalKey<FormState> formKey,
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController phoneController,
    TextEditingController messageController,
    RxBool isSubmitting,
    RxBool isSubmitted,
  ) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Send Us a Message',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Arbutus Slab',
            ),
          ),
          const SizedBox(height: 16),

          // Name Field
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Your Name',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Email Field
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Your Email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!GetUtils.isEmail(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Phone Field
          TextFormField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: 'Your Phone (Optional)',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),

          // Message Field
          TextFormField(
            controller: messageController,
            decoration: const InputDecoration(
              labelText: 'Your Message',
              prefixIcon: Icon(Icons.message),
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your message';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: Obx(() => ElevatedButton(
                  onPressed: isSubmitting.value
                      ? null
                      : () {
                          if (formKey.currentState!.validate()) {
                            isSubmitting.value = true;

                            // Simulate API call
                            Future.delayed(const Duration(seconds: 2), () {
                              isSubmitting.value = false;
                              isSubmitted.value = true;
                            });
                          }
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: isSubmitting.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('SEND MESSAGE'),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return SizedBox(
      height: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 60,
          ),
          const SizedBox(height: 24),
          const Text(
            'Thank You!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Arbutus Slab',
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your message has been sent successfully.',
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'We\'ll get back to you as soon as possible.',
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            child: const Text('SEND ANOTHER MESSAGE'),
          ),
        ],
      ),
    );
  }
}

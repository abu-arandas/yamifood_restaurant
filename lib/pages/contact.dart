import '/exports.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Contact',
      body: Column(
        children: [
          const SizedBox(height: 50),
          Divider(color: primary, thickness: 3),

          // Contact Info
          SizedBox(
            width: double.maxFinite,
            height: contact.length * 100,
            child: ListView.builder(
              itemCount: contact.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => contact[index],
            ),
          ),

          // Social Buttons
          SizedBox(
            width: double.maxFinite,
            height: contact.length * 25,
            child: ListView.builder(
              itemCount: social.length,
              scrollDirection: Axis.horizontal,
              reverse: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => social[index],
            ),
          )
        ],
      ),
    );
  }
}

List<SocialButton> social = [
  SocialButton(
    icon: FontAwesomeIcons.facebookF,
    onPressed: () {},
  ),
  SocialButton(
    icon: FontAwesomeIcons.google,
    onPressed: () {},
  ),
  SocialButton(
    icon: FontAwesomeIcons.instagram,
    onPressed: () {},
  )
];

List<ContactInfo> contact = const [
  ContactInfo(
    title: 'Address:',
    info: 'Abdullah Bin Faroukh ST, Amman, Jordan',
  ),
  ContactInfo(
    title: 'Phone:',
    info: '079 1568 798',
  ),
  ContactInfo(
    title: 'E-Mail:',
    info: 'e.arandas@gmail.com',
  ),
];

import '../exports.dart';

class WelcomeButton {
  String text;
  IconData icon;
  Widget page;

  WelcomeButton({required this.text, required this.icon, required this.page});
}

List<WelcomeButton> buttons = [
  WelcomeButton(
    text: 'Menu',
    icon: FontAwesomeIcons.utensils,
    page: const Menu(),
  ),
  WelcomeButton(
    text: 'Favorite',
    icon: FontAwesomeIcons.heart,
    page: const Favorite(),
  ),
  WelcomeButton(
    text: 'Cart',
    icon: FontAwesomeIcons.cartShopping,
    page: const Cart(),
  ),
  WelcomeButton(
    text: 'Contact',
    icon: FontAwesomeIcons.locationDot,
    page: const Contact(),
  ),
];

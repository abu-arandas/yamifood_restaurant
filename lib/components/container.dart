import '/exports.dart';

class CategoryContainer extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function() onTap;

  const CategoryContainer({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 100),
        margin: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/rectangle_shape.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: primary,
              size: 50,
            ),
            const SizedBox(width: 25),
            Text(
              text,
              style: TextStyle(
                color: white,
                fontSize: 25,
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProductContainer extends StatelessWidget {
  final String name, price, image;
  final void Function() onTap;

  const ProductContainer({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: size.height * 0.3,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(image),
            colorFilter: ColorFilter.mode(overlay, BlendMode.dstATop),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primary,
                  transparent,
                ],
              )),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    price,
                    style: const TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactInfo extends StatelessWidget {
  final String title, info;

  const ContactInfo({super.key, required this.title, required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.only(top: 25, left: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            textAlign: TextAlign.left,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Text(
              info,
              style: TextStyle(
                color: grey,
                fontStyle: FontStyle.italic,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  static const routeName = '/contact';

  @override
  Widget build(BuildContext context) {
    final userProfile = ModalRoute.of(context)!.settings.arguments as UserProfileEntity;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                // Open the image in full screen on tap
                Navigator.of(context).push(_buildImagePageRoute(userProfile.photoURL));
              },
              child: Hero(
                tag: 'profile_image_${userProfile.uid}',
                child: CircleAvatar(
                  radius: 64.0,
                  backgroundImage: userProfile.photoURL != null
                      ? NetworkImage(userProfile.photoURL!)
                      : null, // You can use a default image or leave it null for no image
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          ListTile(
            title: const Text('Display Name'),
            subtitle: Text(userProfile.displayName ?? 'Not provided'),
          ),
          const Divider(),
          ListTile(
            title: const Text('Phone Number'),
            subtitle: Text(userProfile.phoneNumber),
            trailing: IconButton(
              icon: const Icon(Icons.call),
              onPressed: () {
                _launchPhoneCall(userProfile.phoneNumber);
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Bio'),
            subtitle: Text(userProfile.bio ?? 'Not provided'),
          ),
        ],
      ),
    );
  }

  PageRouteBuilder _buildImagePageRoute(String? imageUrl) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return _ImageFullScreenPage(imageUrl: imageUrl);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  void _launchPhoneCall(String phoneNumber) async {
    final uri = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      print('Could not launch $uri');
    }
  }
}

class _ImageFullScreenPage extends StatelessWidget {
  final String? imageUrl;

  const _ImageFullScreenPage({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'profile_image_${imageUrl ?? ''}',
          child: Image.network(imageUrl ?? ''),
        ),
      ),
    );
  }
}

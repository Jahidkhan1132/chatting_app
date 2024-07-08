import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/pages/settings_page.dart';
import 'package:flutter/material.dart';
class MyDrawer extends StatelessWidget {
   MyDrawer({super.key});

  final auth= AuthService();
  void logout() {

    final _auth= AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.getCurrentUser();
    final displayName= user?.displayName ?? 'No Name';
    final email= user?.email ?? 'No Email';

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(displayName),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                email.isNotEmpty ? email[0] : '',
                style: const TextStyle(fontSize: 40.0),
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.only(left:25.0 ),
            child: ListTile(
              title: const Text('H O M E'),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);

              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:25.0 ),
            child: ListTile(
              title: Text('S E T T  I N G S'),
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage(),));
              },
            ),
          ),
        ],
      ),
          Padding(
            padding: const EdgeInsets.only(left:25.0 ),
            child: ListTile(
              title: Text('L O G O U T'),
              leading: Icon(Icons.logout),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}

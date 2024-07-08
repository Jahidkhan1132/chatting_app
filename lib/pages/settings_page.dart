import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        backgroundColor:Colors.transparent ,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12)
          
        ),
        margin: const EdgeInsets.all(25),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [

            Text("Dark Mode"),

            Padding(
              padding: const EdgeInsets.only(left: 140),
              child: CupertinoSwitch(value: Provider.of<ThemeProvider>(context,listen: false).isDarkMode,
                onChanged: (value)  => Provider.of<ThemeProvider>(context,listen: false).toggleTheme(),),
            )
          ],
        ),
      ),
    );
  }
}

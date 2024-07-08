import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController= TextEditingController();
  final TextEditingController _passwordController= TextEditingController();
  final Function()? onTop;

   LoginPage(
       {super.key,
         required this.onTop
       });

   void login(BuildContext context) {

     final authService = AuthService();
     try{
       authService.signInWithEmailPassword(_emailController.text, _passwordController.text,);
     }
     catch (e) {
       showDialog(context: context, builder: (context) => AlertDialog(

         title: Text(e.toString()),
       ),);
     }
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,),
            const SizedBox(height: 50,),
            Text("Welcome back, you're been missed!",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16),),
            const SizedBox(height: 25,),

            MyTextField(
              controller: _emailController,
              hintText: 'Email',
              obscureText: false,),

            const SizedBox(height: 10,),

            MyTextField(
              controller: _passwordController,
              hintText: 'Password',
              obscureText: true,),
            const SizedBox(height: 25,),

            MyButton(
              text: 'Login',onTop: () => login(context),),
            const SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member?',
                  style:
                  TextStyle(color:  Theme.of(context).colorScheme.primary),),
                GestureDetector(
                  onTap: onTop,
                  child: Text(
                    'Register now',
                    style:
                    TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


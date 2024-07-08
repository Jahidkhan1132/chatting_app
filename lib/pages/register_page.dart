import 'package:chat_app/auth/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController= TextEditingController();
  final TextEditingController _passwordController= TextEditingController();
  final TextEditingController _ConfirmPasswordController= TextEditingController();
  final Function()? onTop;
   RegisterPage({super.key,required this.onTop});

   void register(BuildContext context) {
// get auth service

   final _auth= AuthService();

   // password match -> create user
if(_passwordController.text ==_ConfirmPasswordController.text ){

  try{
    _auth.signUpWithEmailPassword(_emailController.text, _passwordController.text);

  }
  catch (e) {
    showDialog(context: context, builder: (context) => AlertDialog(

      title: Text(e.toString()),
    ),);


  }
  // password don't match -> tell user to fix

}
else{
  showDialog(context: context, builder: (context) => AlertDialog(

    title: Text("Password don't match!",style: TextStyle(fontSize: 17),),
  ),);
}
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.message,
                size: 60,
                color: Theme.of(context).colorScheme.primary,),
              const SizedBox(height: 50,),
              Text("Let's create an account for you",
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
              const SizedBox(height: 10,),
              MyTextField(
                controller: _ConfirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,),
              const SizedBox(height: 25,),
        
              MyButton(
                text: 'Register',onTop: () => register(context),),
              const SizedBox(height: 10,),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style:
                    TextStyle(color:  Theme.of(context).colorScheme.primary),),
                  GestureDetector(
                    onTap: onTop,
                    child: Text(
                      'Login now',
                      style:
                      TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ) ;
  }
}

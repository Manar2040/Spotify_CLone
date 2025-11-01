import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'signup_page.dart'; // لو في نفس المجلد

import '../widgets/auth_gadient_button.dart';
import '../widgets/custom_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
    formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key:formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                      'Sign In.',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      )
                      ),
               const SizedBox(height: 15,),        
               CustomField(hintText: 'Email',controller: emailController,),
               const SizedBox(height: 15,),
               CustomField(hintText: 'Password',controller: passwordController,isObscureText: true,),
               const SizedBox(height: 20,),
                AuthGadientButton(buttonText: 'Sign in', onTap: () async {
                  await  AuthRemoteRepository().login(email:emailController.text,password:passwordController.text,);},),
               const SizedBox(height: 20,),
                 GestureDetector(
                   onTap: (){
                     Navigator.push(context,MaterialPageRoute(builder:(context)=> SignupPage(),), );

                   },
                 child:RichText(text: TextSpan(
                text: "Don't have an account? ",
                style: Theme.of(context).textTheme.titleMedium,
                children: const [
                  TextSpan(
                    text: 'Sign up',
                    style: TextStyle(
                      color: Pallete.gradient2,
                      fontWeight: FontWeight.bold,
                    ),

                  ),
                ],
               ),),)
            ],
            
          ),
        ),
      ),
    );
  }
}
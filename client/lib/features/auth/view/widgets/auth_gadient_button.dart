import 'package:flutter/material.dart';

import '../../../../core/theme/app_pallete.dart';

class AuthGadientButton extends StatelessWidget {
  const AuthGadientButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Pallete.gradient1,
            Pallete.gradient2,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: ElevatedButton(
        onPressed: (){},
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(359,55),
          backgroundColor: Pallete.transparentColor,
          shadowColor: Pallete.transparentColor,
        ), 
        child: Text(
              'Sign Up',
              style:TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              )
      )
              ),
    );
  }
}
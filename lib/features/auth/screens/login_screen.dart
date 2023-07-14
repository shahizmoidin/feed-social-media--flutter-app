import 'package:feed/core/common/loader.dart';
import 'package:feed/core/common/sign_in_button.dart';
import 'package:feed/core/constants/constants.dart';
import 'package:feed/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});
  void signInAsGuest(WidgetRef ref , BuildContext context)
  {
ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isLoading=ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
    centerTitle: true, // Center the title
    title: Image.asset(
    Constants.logoPath,
    height: 40,
    ),
    actions: [
    TextButton(
      onPressed: () =>signInAsGuest(ref, context), 
      child: const Text(
        'skip',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    ],
    )
    ,
      body:isLoading?const Loader(): Column(
        children: [
          const SizedBox(height: 30,),
          const Text('Dive into anything',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,
          letterSpacing: 0.5)),
          const SizedBox(height: 30),Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(Constants.loginEmotePath,height: 400,),
          ),
          const SizedBox(height: 20,),
          const SignInButton()
        ],
      ),
    );
  }
}
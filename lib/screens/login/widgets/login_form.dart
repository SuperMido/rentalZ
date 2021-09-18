import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'custom_button.dart';
import 'custom_input_field.dart';
import 'fade_slide_transition.dart';
import '../../register/register.dart';
import '../../rentalzForm/rentalzForm.dart';

class LoginForm extends StatefulWidget {
  final Animation<double> animation;

  LoginForm({
    required this.animation,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final _formKey = GlobalKey<FormState>();

  late String _userEmail;

  late String _userPassword;


  void _login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _userEmail,
          password: _userPassword
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user found for that email.')),
        );
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wrong password provided for that user.')),
        );
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final space = height > 650 ? kSpaceM : kSpaceS;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingL),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            FadeSlideTransition(
              animation: widget.animation,
              additionalOffset: 0.0,
              child: CustomInputField(
                label: 'Username or Email',
                prefixIcon: Icons.person,
                obscureText: false,
                onChanged: (value) {
                  setState(() {
                    _userEmail = value!;
                  });
                },
                validation: (value) {
                  if (value!.isEmpty) {
                    return 'Your Username or Email is empty!';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: space),
            FadeSlideTransition(
              animation: widget.animation,
              additionalOffset: space,
              child: CustomInputField(
                label: 'Password',
                prefixIcon: Icons.lock,
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _userPassword = value!;
                  });
                },
                validation: (value) {
                  if (value!.isEmpty) {
                    return 'Your password is empty!';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: space),
            FadeSlideTransition(
              animation: widget.animation,
              additionalOffset: 2 * space,
              child: CustomButton(
                color: kBlue,
                textColor: kWhite,
                text: 'Login to continue',
                onPressed: () {
                  if (_formKey.currentState!.validate()){
                    _login();
                    FirebaseAuth.instance
                        .authStateChanges()
                        .listen((User? user) {
                      if (user == null) {
                        print('User is currently signed out!');
                      } else {
                        print(user);
                        Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RentalzForm(screenHeight: height),
                              )
                          );
                        }
                      }
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 2 * space),
            FadeSlideTransition(
              animation: widget.animation,
              additionalOffset: 3 * space,
              child: CustomButton(
                color: kWhite,
                textColor: kBlack.withOpacity(0.5),
                text: 'Continue with Google',
                image: const Image(
                  image: AssetImage(kGoogleLogoPath),
                  height: 48.0,
                ),
                onPressed: () {},
              ),
            ),
            SizedBox(height: space),
            FadeSlideTransition(
              animation: widget.animation,
              additionalOffset: 4 * space,
              child: CustomButton(
                color: kBlack,
                textColor: kWhite,
                text: 'Create a RentalZ Account',
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Register(screenHeight: height),
                      )
                  );
                },
              ),
            ),
            SizedBox(height: 6 * space),
          ],
        ),
      ),
    );
  }
}

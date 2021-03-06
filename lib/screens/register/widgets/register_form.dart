import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rentalz/screens/login/login.dart';

import '../../../constants.dart';
import 'custom_button.dart';
import 'custom_input_field.dart';
import 'fade_slide_transition.dart';

class RegisterForm extends StatefulWidget {
  final Animation<double> animation;

  RegisterForm({
    required this.animation,
  });

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  late String _userEmail;

  late String _userPassword;

  late String _userPasswordConfirm;

  late bool _success = false;

  late String _messageRegister;

  void _register() async {
    try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _userEmail,
            password: _userPassword
        );
        setState(() {
          _success = true;
        });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          _success = false;
          _messageRegister = 'The password provided is too weak.';
        });
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          _success = false;
          _messageRegister = 'The account already exists for that email.';
        });
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
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
                validation: (value) {
                  if (value!.isEmpty) {
                    return 'Username or Email is empty!';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _userEmail = value!;
                  });
                  return _userEmail;
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
                validation: (value) {
                  if (value!.isEmpty) {
                    return 'Your password is empty!';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _userPassword = value!;
                  });
                  return _userPassword;
                },
              ),
            ),
            SizedBox(height: space),
            FadeSlideTransition(
              animation: widget.animation,
              additionalOffset: space,
              child: CustomInputField(
                label: 'Confirm Password',
                prefixIcon: Icons.lock,
                obscureText: true,
                validation: (value) {
                  if (value!.isEmpty) {
                    return 'Your confirm password is empty!';
                  }
                  if (_userPassword != _userPasswordConfirm){
                    return 'Your password and confirm Password not match!';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _userPasswordConfirm = value!;
                  });
                  return _userPasswordConfirm;
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
                text: 'Create Account',
                onPressed: () {
                  if (_formKey.currentState!.validate()){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registering your account...!')),
                    );
                    _register();
                    if (_success){
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Your account have been created!')));
                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(_messageRegister)));
                      setState(() {
                        _messageRegister = '';
                      });
                    }
                  }
                },
              ),
            ),
            SizedBox(height: space),
            FadeSlideTransition(
              animation: widget.animation,
              additionalOffset: 4 * space,
              child: CustomButton(
                color: kBlack,
                textColor: kWhite,
                text: 'Already has RentalZ account!',
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Login(screenHeight: height),
                      )
                  );
                },
              ),
            ),
            SizedBox(height: 8 * space),
          ],
        ),
      ),
    );
  }
}

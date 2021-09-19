import 'package:dropdownfield/dropdownfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rentalz/screens/login/login.dart';

import '../../../constants.dart';
import 'custom_button.dart';
import 'custom_input_field.dart';
import 'fade_slide_transition.dart';

class RentalZForm extends StatefulWidget {
  final Animation<double> animation;

  RentalZForm({
    required this.animation,
  });

  @override
  _RentalZFormState createState() => _RentalZFormState();
}

class _RentalZFormState extends State<RentalZForm> {
  final _formKey = GlobalKey<FormState>();

  late String _userEmail;

  late String _userPassword;

  late String _userPasswordConfirm;

  late bool _success = false;

  late String _messageRegister;

  late String propertyType = '';

  List<String> propertyTypes = [
    "Flat",
    "House",
    "Bungalow",
  ];


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
            DropDownField(
              onValueChanged: (dynamic value) {
                propertyType = value;
              },
              value: propertyType,
              required: false,
              hintText: 'Choose a property type',
              labelText: 'Property Type',
              items: propertyTypes,
            ),
            SizedBox(height: space),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                labelText: 'Restaurant type',
              ),
              items: <String>['Studio ', 'One', 'Two'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (data) {

              },
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
                text: 'Log Out',
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Login(screenHeight: height),
                      )
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
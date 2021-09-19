import 'package:dropdownfield/dropdownfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentalz/screens/login/login.dart';

import '../../../constants.dart';
import 'custom_button.dart';
import 'custom_multi_text_field.dart';
import 'custom_price_input_field.dart';
import 'fade_slide_transition.dart';

class RentalZForm extends StatefulWidget {
  final Animation<double> animation;

  RentalZForm({
    required this.animation,
  });

  @override
  _RentalZFormState createState() => _RentalZFormState();
}

enum FurnitureType  { Furnished, Unfurnished, Part_Furnished }

class _RentalZFormState extends State<RentalZForm> {
  final _formKey = GlobalKey<FormState>();

  late String propertyType = "Flat";

  var currentUser = FirebaseAuth.instance.currentUser;


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
            FadeSlideTransition(
              animation: widget.animation,
              additionalOffset: space,
              child: Text(
                  currentUser!.email.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.blue
                ),
              ),
            ),
            SizedBox(height: space),
            FadeSlideTransition(
              animation: widget.animation,
              additionalOffset: space,
              child: DropDownField(
                onValueChanged: (dynamic value) {
                  propertyType = value;
                },
                value: propertyType,
                required: true,
                labelText: 'Property Type*',
                items: propertyTypes,
                strict: true,
                icon: Icon(Icons.account_balance),
              ),
            ),
            SizedBox(height: space),
            FadeSlideTransition(
              animation: widget.animation,
              additionalOffset: space,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Bedrooms*',
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
            ),
            SizedBox(height: space),
            FadeSlideTransition(
              animation: widget.animation,
              additionalOffset: space,
              child:

              TextField(
                keyboardType: TextInputType.datetime,
                // controller: _controllerDOB,
                // focusNode: _focusNodeDOB,
                decoration: InputDecoration(
                  hintText: 'DD/MM/YYYY',
                  counterText: '',
                  labelText: 'Date*'
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                  LengthLimitingTextInputFormatter(10),
                  _DateFormatter(),
                ],
              ),
            ),
            SizedBox(height: space),
            FadeSlideTransition(
              animation: widget.animation,
              additionalOffset: space,
              child: CustomPriceInputField(
                label: 'Monthly rent price*',
                prefixIcon: Icons.attach_money,
                obscureText: false,
                validation: (value) {
                  if (value!.isEmpty) {
                    return '';
                  }
                  return null;
                },
                onChanged: (value) {
                },
              ),
            ),
            SizedBox(height: space),
            FadeSlideTransition(
              animation: widget.animation,
              additionalOffset: space,
              child:
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Furniture types',
                ),
                items: <String>['Furnished', 'Unfurnished', 'Part Furnished'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (data) {
                },
              ),
            ),
            SizedBox(height: space),
            FadeSlideTransition(
              animation: widget.animation,
              additionalOffset: space,
              child: CustomMultiTextField(
                label: 'Note',
                prefixIcon: Icons.assignment,
                obscureText: false,
                validation: (value) {
                  if (value!.isEmpty) {
                    return '';
                  }
                  return null;
                },
                onChanged: (value) {
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
                text: 'Submit',
                onPressed: () {
                  if (_formKey.currentState!.validate()){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registering your account...!')),
                    );
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

class _DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue prevText, TextEditingValue currText) {
    int selectionIndex;

    // Get the previous and current input strings
    String pText = prevText.text;
    String cText = currText.text;
    // Abbreviate lengths
    int cLen = cText.length;
    int pLen = pText.length;

    if (cLen == 1) {
      // Can only be 0, 1, 2 or 3
      if (int.parse(cText) > 3) {
        // Remove char
        cText = '';
      }
    } else if (cLen == 2 && pLen == 1) {
      // Days cannot be greater than 31
      int dd = int.parse(cText.substring(0, 2));
      if (dd == 0 || dd > 31) {
        // Remove char
        cText = cText.substring(0, 1);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if (cLen == 4) {
      // Can only be 0 or 1
      if (int.parse(cText.substring(3, 4)) > 1) {
        // Remove char
        cText = cText.substring(0, 3);
      }
    } else if (cLen == 5 && pLen == 4) {
      // Month cannot be greater than 12
      int mm = int.parse(cText.substring(3, 5));
      if (mm == 0 || mm > 12) {
        // Remove char
        cText = cText.substring(0, 4);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if ((cLen == 3 && pLen == 4) || (cLen == 6 && pLen == 7)) {
      // Remove / char
      cText = cText.substring(0, cText.length - 1);
    } else if (cLen == 3 && pLen == 2) {
      if (int.parse(cText.substring(2, 3)) > 1) {
        // Replace char
        cText = cText.substring(0, 2) + '/';
      } else {
        // Insert / char
        cText =
            cText.substring(0, pLen) + '/' + cText.substring(pLen, pLen + 1);
      }
    } else if (cLen == 6 && pLen == 5) {
      // Can only be 1 or 2 - if so insert a / char
      int y1 = int.parse(cText.substring(5, 6));
      if (y1 < 1 || y1 > 2) {
        // Replace char
        cText = cText.substring(0, 5) + '/';
      } else {
        // Insert / char
        cText = cText.substring(0, 5) + '/' + cText.substring(5, 6);
      }
    } else if (cLen == 7) {
      // Can only be 1 or 2
      int y1 = int.parse(cText.substring(6, 7));
      if (y1 < 1 || y1 > 2) {
        // Remove char
        cText = cText.substring(0, 6);
      }
    } else if (cLen == 8) {
      // Can only be 19 or 20
      int y2 = int.parse(cText.substring(6, 8));
      if (y2 < 19 || y2 > 20) {
        // Remove char
        cText = cText.substring(0, 7);
      }
    }

    selectionIndex = cText.length;
    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
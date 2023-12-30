import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AppPhoneTextField extends StatelessWidget {
  const AppPhoneTextField({
    Key? key,
    this.hint,
    this.onSaved,
  }) : super(key: key);

  final String? hint;
  final Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        // Handle changes in phone number input
      },
      onInputValidated: (bool value) {
        // Handle validation of the phone number
      },
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.DIALOG,
      ),
      inputDecoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        labelText: hint,
        labelStyle: const TextStyle(
          color: Color(0xFF9098B1),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            color: Color(0xFFEBF0FF),
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            color: Color(0xFFEBF0FF),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            color: Color(0xFFEBF0FF),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            color: Color(0xFFEBF0FF),
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            color: Color(0xFFEBF0FF),
          ),
        ),
        prefixIcon: const Padding(
          padding: EdgeInsets.all(4),
          child: Icon(
            Icons.phone,
            size: 16,
          ),
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF9098B1),
        ),
      ),
      keyboardType: TextInputType.phone,
      cursorColor: Colors.black,
      textAlign: TextAlign.left,
      spaceBetweenSelectorAndTextField: 0,
      onSaved: (PhoneNumber? number) {
        // Handle saving the phone number
        if (onSaved != null && number != null) {
          onSaved!(number.phoneNumber!.toString());
        }
      },
      autoValidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}

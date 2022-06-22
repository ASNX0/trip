// ignore_for_file: camel_case_types, deprecated_member_use, curly_braces_in_flow_control_structures, unused_local_variable, unnecessary_null_comparison
import 'dart:async';

class Validators {
  final namevalidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name == null || name.isEmpty) {
      sink.addError("");
    } else if (name.length < 5) {
      sink.addError("Short Name");
    } else {
      sink.add(name);
    }
  });

  final emailvalidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    String epattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&*'+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]";
    RegExp eregex = RegExp(epattern);

    if (eregex.hasMatch(email))
      sink.add(email);
    else if (email == null || email.isEmpty)
      sink.addError("");
    else
      sink.addError("Enter a valid Email");
  });

  var passvalidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (pass, sink) {
    String pattern = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[a-zA-Z\d]{5,}$';
    RegExp regex = RegExp(pattern);
    if (regex.hasMatch(pass))
      sink.add(pass);
    else if (pass == null || pass.isEmpty)
      sink.addError("");
    else
      sink.addError("Enater a valid Password");
  });
  // var confvalidator =
  //     StreamTransformer<String, String>.fromHandlers(handleData: (conf, sink) {
  //   String pattern = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[a-zA-Z\d]{5,}$';
  //   RegExp regex = RegExp(pattern);
  //   if (conf == Rbloc.passwordc)
  //     sink.add(conf);
  //   else if (conf == null || conf.isEmpty)
  //     sink.addError("");
  //   else
  //     sink.addError("password dont match");
  // });
  var phonevalidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (phone, sink) {
    String pattern = r'^(?:[0]9)?[0-9]{10}$';
    RegExp regex = new RegExp(pattern);
    if (regex.hasMatch(phone))
      sink.add(phone);
    else if (phone.isEmpty)
      sink.addError("");
    else
      sink.addError("invalid phone number");
  });
}

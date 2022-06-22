// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:scannerapp/logging/valid.dart';

class Bloc extends Object with Validators {
//Stream controller
  final _name = new BehaviorSubject<String>();
  final _email = new BehaviorSubject<String>();
  final _password = new BehaviorSubject<String>();
  // final _confpassword = new BehaviorSubject<String>();
  final _phone = new BehaviorSubject<String>();
  final _hide = new BehaviorSubject<bool>();

// process Data
  Stream<String> get name => _name.stream.transform(namevalidator);
  Stream<String> get email => _email.stream.transform(emailvalidator);
  Stream<String> get password => _password.stream.transform(passvalidator);
  // Stream<String> get confpassword =>
  //     _confpassword.stream.transform(confvalidator);
  Stream<String> get phone => _phone.stream.transform(phonevalidator);
  Stream<bool> get hide => _hide.stream;
  Stream<bool> get submitValid =>
      Rx.combineLatest2(email, password, (e, p) => true);
  Stream<bool> get regValid =>
      Rx.combineLatest4(name, email, password, phone, (n, e, p, ph) => true);

//Add Data to Stream
  Function(String) get changeName => _name.sink.add;
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  // Function(String) get changeConf => _confpassword.sink.add;
  Function(String) get changephone => _phone.sink.add;
  Sink<bool> get changehide => _hide.sink;

// Get Data
  get namec => _name.value;
  get emailc => _email.value;
  get passwordc => _password.value;
  // get Confc => _confpassword.value;
  get phonec => _phone.value;
  get hidec => _hide.value;

  void disp() {
    _name.close();
    _email.close();
    _password.close();
    // _confpassword.close();
    _phone.close();
    _hide.close();
  }

  dispose() async {
    print('Started Dispose');

    await _name.drain();
    await _email.drain();
    await _password.drain();
    await _phone.drain();
    await _hide.drain();

    print('_mainStream Drained');
  }
}

final Rbloc = Bloc();
final Dbloc = Bloc();
final Lbloc = Bloc();

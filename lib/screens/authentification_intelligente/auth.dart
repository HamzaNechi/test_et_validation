import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:local_auth/local_auth.dart';
import 'package:psychoday/screens/Login/components/login_form.dart';
import 'package:psychoday/screens/listDoctor/pages/home_page.dart';
import 'package:psychoday/screens/therapy/list_therapy.dart';
import 'package:psychoday/utils/style.dart';

class Authh extends StatefulWidget {
  const Authh({super.key});

  @override
  State<Authh> createState() => _AuthhState();
}

class _AuthhState extends State<Authh> {
    final LocalAuthentication auth = LocalAuthentication();

 _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

 Future<void> _authenticate() async {
  bool authenticated = false;
  try {
    setState(() {
      _isAuthenticating = true;
      _authorized = 'Authenticating';
    });
    authenticated = await auth.authenticate(
      localizedReason: 'Let OS determine authentication method',
      options: const AuthenticationOptions(
        stickyAuth: true,
      ),
    );
    setState(() {
      _isAuthenticating = false;
    });

    if (authenticated) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage() ), // f blassit homeScreen n3aytou chatbot
      );
    }

  } on PlatformException catch (e) {
    print(e);
    setState(() {
      _isAuthenticating = false;
      _authorized = 'Error - ${e.message}';
    });
    return;
  }
  if (!mounted) {
    return;
  }

  setState(
      () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
}


  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
         elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text("Security and Privacy"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.security_update_good),
          )
        ],
        ),
        body: ListView(
          padding: const EdgeInsets.only(top: 30),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_supportState == _SupportState.unknown)
                  const CircularProgressIndicator()
                else if (_supportState == _SupportState.supported)
                  const Text('This device is supported')
                else
                  const Text('This device is not supported'),
                const Divider(height: 100),
             Image.asset("Assets/security.png"),
            
                // Text('Can check biometrics: $_canCheckBiometrics\n'),
                // ElevatedButton(
                //   onPressed: _checkBiometrics,
                //   child: const Text('Check biometrics'),
                // ),
                // const Divider(height: 100),
                // Text('Available biometrics: $_availableBiometrics\n'),
                // ElevatedButton(
                //   onPressed: _getAvailableBiometrics,
                //   child: const Text('Get available biometrics'),
                // ),
                const Divider(height: 100),
                if (_isAuthenticating)
                  ElevatedButton(
                    onPressed: _cancelAuthentication,
                    // TODO(goderbauer): Make this const when this package requires Flutter 3.8 or later.
                    // ignore: prefer_const_constructors
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Text('Cancel Authentication'),
                        Icon(Icons.cancel),
                      ],
                    ),
                  )
                else
                  Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _authenticate,
                         style: ElevatedButton.styleFrom(
    primary: Style.marron, // set the background color of the button
  ),
                        // TODO(goderbauer): Make this const when this package requires Flutter 3.8 or later.
                        // ignore: prefer_const_constructors
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            Text('Authenticate'),
                            Icon(Icons.perm_device_information),
                            
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _authenticateWithBiometrics,
                        style: ElevatedButton.styleFrom(
    primary: Style.marron, // set the background color of the button
  ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(_isAuthenticating
                                ? 'Cancel'
                                : 'Authenticate: biometrics only'),
                            const Icon(Icons.fingerprint),
                          ],
                        ),
                      ),
                      Text('Current State: $_authorized\n'),

                      if(_isAuthenticating==true)
                         ElevatedButton(
                    onPressed: () { Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomeScreen();
            },
          ),
        );},
                    // TODO(goderbauer): Make this const when this package requires Flutter 3.8 or later.
                    // ignore: prefer_const_constructors
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Text('Log In'),
                        Icon(Icons.cancel),
                      ],
                    ),
                  )
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
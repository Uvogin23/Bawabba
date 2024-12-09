import 'package:bawabba/core/models/user.dart';
import 'package:bawabba/core/services/auth_provider.dart';
import 'package:bawabba/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bawabba/core/services/config.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final url = Uri.parse('${Config.baseUrl}/login'); // Your API endpoint
    try {
      print('object');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        final user = User.fromJson(data['user']);
        Provider.of<AuthProvider>(context, listen: false).token = token;
        Provider.of<AuthProvider>(context, listen: false).user = user;
        print(response.body);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      } else {
        setState(() {
          _errorMessage = 'Invalid credentials';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error connecting to the server';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 225, 227, 228),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(70, 50, 50, 40),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 50, 120, 50),
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              color: Color.fromARGB(255, 158, 159, 162),
                            )
                          ],
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Color.fromARGB(255, 255, 255, 255)),
                      child: Column(
                        children: [
                          TextField(
                            controller: _usernameController,
                            decoration:
                                const InputDecoration(labelText: 'Username'),
                          ),
                          TextField(
                            controller: _passwordController,
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          if (_errorMessage != null) ...[
                            Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 20),
                          ],
                          ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text('Login'),
                          ),
                        ],
                      ),
                    )),
                    Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(120, 50, 0, 50),
                          padding: EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  color: Color.fromARGB(255, 158, 159, 162),
                                )
                              ],
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                              color: Color.fromARGB(255, 91, 141, 26)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    width: 55,
                                    height: 79.0,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            AssetImage('assets/images/ANP.png'),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    width: 75,
                                    height: 89.0,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/algerieLogo.png'),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                ' الجمهورية الجزائرية الديمقراطية الشعبية\n وزارة الدفـــــــاع الوطنــــــي \n الناحية العسكرية الرابعة \n القطاع العسكري جانت',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontFamily: 'Times New Roman',
                                    fontSize: 24,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.bold,
                                    height: 1),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                width: 150,
                                height: 150.0,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/logo.png'),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              const Text(
                                'تطبيقة متابعة الدخول و الخروج\nعبر حدود ولاية جانت',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontFamily: 'Times New Roman',
                                    fontSize: 24,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.bold,
                                    height: 1),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


/*class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
        width: screenWidth * 1,
        height: screenHeight * 1,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(1),
            topRight: Radius.circular(1),
            bottomLeft: Radius.circular(1),
            bottomRight: Radius.circular(1),
          ),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                offset: Offset(0, 4),
                blurRadius: 34)
          ],
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Stack(children: <Widget>[
          Positioned(
              top: 150,
              left: 200,
              right: 200,
              bottom: 150,
              child: Container(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.8,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Color.fromRGBO(25, 83, 153, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 82, 83, 99), // Shadow color
                        blurRadius: 10, // Blur radius
                        offset: Offset(0, 0), // Offset in x and y directions
                      ),
                    ],
                  ))),
          Positioned(
              top: 270,
              left: 1000,
              right: 300,
              bottom: 270,
              child: //Mask holder Template
                  Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: Color.fromRGBO(255, 255, 255, 1),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Color.fromARGB(255, 82, 83, 99), // Shadow color
                            blurRadius: 10, // Blur radius
                            offset:
                                Offset(0, 0), // Offset in x and y directions
                          ),
                        ],
                      ),
                      child: null)),
          Positioned(
            top: 330,
            left: 490,
            child: Container(
              width: 200,
              height: 200.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/change.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          const Positioned(
            top: 570,
            left: 450,
            child: Text(
              'تطبيقة متابعة الدخول و الخروج\nعبر حدود ولاية جانت',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontFamily: 'Times New Roman',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
          ),
        ]));
  }
}*/

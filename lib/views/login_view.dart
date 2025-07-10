import 'package:flutter/material.dart';
import '../services/login_services.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usercontroller = TextEditingController();
    final TextEditingController passwordcontroller = TextEditingController();
    const snackBar = SnackBar(content: Text('Credenciales incorrectas'));

    return Scaffold(
      appBar: AppBar(title: const Text("Bienvenido")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: "usuario"),
              controller: usercontroller,
            ),
            TextField(
              decoration: InputDecoration(labelText: "password"),

              obscureText: true,

              controller: passwordcontroller,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final bool resp = await loginServices(
                  usercontroller.text,
                  passwordcontroller.text,
                );
                print(resp);
                if (resp) {
                  Navigator.pushNamed(context, '/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Text('Iniciar Sesion'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bienvenutti')),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [ElevatedButton(onPressed: (){
        Navigator.pushNamed(context, '/');
            }, child:Text('Iniciar Sesion'),)
      ],
      ),
      )
    );
  }
}

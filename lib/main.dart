import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'counter_bloc.dart';
import 'counter_page.dart';

void main(){
  runApp(const CounterApp());
}
class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
      create: (_)=> CounterBloc(),
      child: const CounterPage(),
      ),

    );
    
  }
}
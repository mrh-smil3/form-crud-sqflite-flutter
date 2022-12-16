import 'package:flutter/material.dart';
import 'database/db_helper.dart';
import 'form_mahasiswa.dart';
import 'list_mahasiswa.dart';
import 'model/mahasiswa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daftar Mahasiswa',
      home: ListMahasiswaPage(),
    );
  }
}

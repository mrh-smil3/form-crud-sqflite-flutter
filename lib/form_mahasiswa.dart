import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/src/widgets/container.dart';

import 'database/db_helper.dart';
import 'model/mahasiswa.dart';

class FormMahasiswa extends StatefulWidget {
  final Mahasiswa? mhs;

  FormMahasiswa({this.mhs});

  @override
  State<FormMahasiswa> createState() => _FormMahasiswaState();
}

class _FormMahasiswaState extends State<FormMahasiswa> {
  DbHelper db = DbHelper();

  TextEditingController? nama;
  TextEditingController? namaAkhir;
  TextEditingController? nim;
  TextEditingController? email;
  TextEditingController? prodi;

  @override
  void initState() {
    nama =
        TextEditingController(text: widget.mhs == null ? '' : widget.mhs!.nama);
    nim =
        TextEditingController(text: widget.mhs == null ? '' : widget.mhs!.nim);
    email = TextEditingController(
        text: widget.mhs == null ? '' : widget.mhs!.email);
    prodi = TextEditingController(
        text: widget.mhs == null ? '' : widget.mhs!.prodi);

    super.initState();
  }

  var _formKeyMhs = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form Mahasiswa')),
      body: Form(
          key: _formKeyMhs,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-z A-Z .,']"))
                ],
                controller: nama,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: "Masukan Nama Lengkap Anda",
                    labelText: "Nama",
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0))),
                validator: ((value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Tidak Boleh Kosong';
                  }
                  return null;
                }),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  maxLength: 12,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: nim,
                  decoration: InputDecoration(
                    hintText: "Masukkan NIM Anda",
                    labelText: "NIM",
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                  ),
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return 'NIM Tidak Boleh Kosong';
                    }
                    return null;
                  }),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "contoh@example.com",
                      labelText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0))),
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan Email Yang Valid';
                    }
                    return null;
                  }),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-z A-Z ]"))
                  ],
                  controller: prodi,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Masukkan Program Studi",
                      labelText: "Program Studi",
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0))),
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return 'Program Studi Tidak Boleh Kosong';
                    }
                    return null;
                  }),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKeyMhs.currentState!.validate()) {
                          upsertMhs();
                        }
                      },
                      child: Container(
                          child: (widget.mhs == null)
                              ? Text('Tambah')
                              : Text('Update'))))
            ],
          )),
    );
  }

  Future<void> upsertMhs() async {
    if (widget.mhs != null) {
      //update
      await db.updateMhs(Mahasiswa.fromMap({
        'id': widget.mhs!.id,
        'nama': nama!.text,
        'nim': nim!.text,
        'email': email!.text,
        'prodi': prodi!.text
      }));
      Navigator.pop(context, 'update');
    } else {
      //insert
      await db.saveMhs(Mahasiswa(
          nama: nama!.text,
          nim: nim!.text,
          email: email!.text,
          prodi: prodi!.text));
      Navigator.pop(context, 'save');
    }
  }
}

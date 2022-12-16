import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/material.dart';
import 'form_mahasiswa.dart';
import 'database/db_helper.dart';
import 'model/mahasiswa.dart';

class ListMahasiswaPage extends StatefulWidget {
  const ListMahasiswaPage({super.key});

  @override
  State<ListMahasiswaPage> createState() => _ListMahasiswaPageState();
}

class _ListMahasiswaPageState extends State<ListMahasiswaPage> {
  List<Mahasiswa> listMhs = [];
  DbHelper db = DbHelper();

  @override
  void initState() {
    //awal
    _getAllMhs();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Daftar Mahasiswa')),
      ),
      body: ListView.builder(
        itemCount: listMhs.length,
        itemBuilder: ((context, index) {
          Mahasiswa mhs = listMhs[index];
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListTile(
              tileColor: Color.fromARGB(125, 123, 189, 134),
              leading: Icon(
                Icons.person,
                size: 50,
              ),
              title: Text('${mhs.nim}'),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('Nama: ${mhs.nama}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('Email: ${mhs.email}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('Prodi: ${mhs.prodi}'),
                  ),
                ],
              ),
              trailing: FittedBox(
                fit: BoxFit.fill,
                child: Row(
                  children: [
                    //button edit
                    IconButton(
                        onPressed: () {
                          _openFormEdit(mhs);
                        },
                        icon: Icon(Icons.edit)),
                    //button hapus
                    IconButton(
                        onPressed: () {
                          //dialog konfirmasi
                          AlertDialog hapus = AlertDialog(
                            title: Text('Information'),
                            content: Container(
                              height: 100,
                              child: Column(children: [
                                Text('Yakin Menghapus Data ${mhs.nama}')
                              ]),
                            ),
                            //2 button, ya = hapus (_deleteMhs()), tidak = tutup dialog

                            actions: [
                              TextButton(
                                  onPressed: () {
                                    _deleteMhs(mhs, index);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Ya')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Tidak'))
                            ],
                          );
                          showDialog(
                              context: context, builder: (context) => hapus);
                        },
                        icon: Icon(Icons.delete)),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
      //button apung kanan bawah
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _openFormCreate();
        },
      ),
    );
  }

  //ambil semua data
  Future<void> _getAllMhs() async {
    //list menampung data dari dbs
    var list = await db.getAllMhs();

    //perubahan state
    setState(() {
      //hapus data pada listMhs
      listMhs.clear();

      //perulangan var list
      list!.forEach((mhs) {
        //masukkan data ke listmhs
        listMhs.add(Mahasiswa.fromMap(mhs));
      });
    });
  }

  //menghapus data
  Future<void> _deleteMhs(Mahasiswa mhs, int position) async {
    await db.deleteMhs(mhs.id!);
    setState(() {
      listMhs.removeAt(position);
    });
  }

  //tambah mahasiswa
  Future<void> _openFormCreate() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => FormMahasiswa()));
    if (result == 'save') {
      await _getAllMhs();
    }
  }

  //membuka halaman edit
  Future<void> _openFormEdit(Mahasiswa mhs) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => FormMahasiswa(mhs: mhs)));
    if (result == 'update') {
      await _getAllMhs();
    }
  }
}

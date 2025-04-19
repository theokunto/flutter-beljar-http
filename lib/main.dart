import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mahasiswa App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool error = false, dataloaded = false;
  var data;

  String dataurl = "http://127.0.0.1/basis-data/json.php";

  @override
  void initState() {
    super.initState();
    loaddata(); // Load data on startup
  }

  void loaddata() async {
    Future.delayed(Duration.zero, () async {
      try {
        var res = await http.post(Uri.parse(dataurl));
        if (res.statusCode == 200) {
          print('Response body: ${json.decode(res.body)}');
          setState(() {
            data = json.decode(res.body);
            dataloaded = true;
          });
        } else {
          setState(() {
            error = true;
          });
        }
      } catch (e) {
        setState(() {
          error = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PHP/MYSQL Table"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: dataloaded
            ? datalist()
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget datalist() {
    if (data["error"]) {
      return Text(data["errmsg"]);
    } else {
      List<NameOne> namelist = List<NameOne>.from(data["data"].map((i) {
        return NameOne.fromJSON(i);
      }));

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          border: TableBorder.all(width: 1, color: Colors.black45),
          defaultColumnWidth: FixedColumnWidth(150), // You can adjust this width
          children: [
            // Table header
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[300]),
              children: [
                tableCell("NIM", isHeader: true),
                tableCell("Nama", isHeader: true),
                tableCell("Alamat", isHeader: true),
                tableCell("Jurusan", isHeader: true),
              ],
            ),
            // Table data
            ...namelist.map((nameone) {
              return TableRow(
                children: [
                  tableCell(nameone.nim),
                  tableCell(nameone.nama),
                  tableCell(nameone.alamat),
                  tableCell(nameone.jurusan),
                ],
              );
            }).toList(),
          ],
        ),
      );
    }
  }

  Widget tableCell(String text, {bool isHeader = false}) {
    return TableCell(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class NameOne {
  final String nim;
  final String nama;
  final String alamat;
  final String jurusan;

  NameOne({
    required this.nim,
    required this.nama,
    required this.alamat,
    required this.jurusan,
  });

  factory NameOne.fromJSON(Map<String, dynamic> json) {
    return NameOne(
      nim: json['nim'] ?? '',
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      jurusan: json['jurusan'] ?? '',
    );
  }
}

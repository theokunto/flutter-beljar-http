class Mhs {
  String nim, nama, alamat, jurusan;
  Mhs({
    this.nim = "",
    this.nama = "",
    this.alamat = "",
    this.jurusan = ""
  });

  factory Mhs.fromJson(Map<String, dynamic> json) =>
      Mhs(
          nim: json['nim'],
          nama: json['nama'],
          alamat: json['alamat'],
          jurusan: json['jurusan']
      );

}
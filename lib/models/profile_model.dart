class ProfileModel {
  final String id;
  final String email;
  final String role;

  final String? nama;
  final String? alamat;
  final String? noHp;

  // seller
  final String? namaUmkm;
  final String? kategoriUmkm;

  // lokasi
  final String? kecamatan;
  final String? kabupaten;

  // profile
  final String? fotoProfile;

  // pencairan
  final String? metodePencairan;

  final String? nomorDana;
  final String? nomorShopeepay;

  final String? namaBank;
  final String? nomorRekening;
  final String? namaPemilikRekening;

  final bool isProfileComplete;

  ProfileModel({
    required this.id,
    required this.email,
    required this.role,

    this.nama,
    this.alamat,
    this.noHp,

    this.namaUmkm,
    this.kategoriUmkm,

    this.kecamatan,
    this.kabupaten,

    this.fotoProfile,

    this.metodePencairan,

    this.nomorDana,
    this.nomorShopeepay,

    this.namaBank,
    this.nomorRekening,
    this.namaPemilikRekening,

    required this.isProfileComplete,
  });

  factory ProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProfileModel(
      id: json['id'],
      email: json['email'],
      role: json['role'],

      nama: json['nama'],
      alamat: json['alamat'],
      noHp: json['no_hp'],

      namaUmkm: json['nama_umkm'],
      kategoriUmkm: json['kategori_umkm'],

      kecamatan: json['kecamatan'],
      kabupaten: json['kabupaten'],

      fotoProfile: json['foto_profile'],

      metodePencairan:
          json['metode_pencairan'],

      nomorDana:
          json['nomor_dana'],

      nomorShopeepay:
          json['nomor_shopeepay'],

      namaBank:
          json['nama_bank'],

      nomorRekening:
          json['nomor_rekening'],

      namaPemilikRekening:
          json[
              'nama_pemilik_rekening'],

      isProfileComplete:
          json[
                  'is_profile_complete'] ??
              false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,

      'nama': nama,
      'alamat': alamat,
      'no_hp': noHp,

      'nama_umkm': namaUmkm,
      'kategori_umkm':
          kategoriUmkm,

      'kecamatan': kecamatan,
      'kabupaten': kabupaten,

      'foto_profile':
          fotoProfile,

      'metode_pencairan':
          metodePencairan,

      'nomor_dana':
          nomorDana,

      'nomor_shopeepay':
          nomorShopeepay,

      'nama_bank': namaBank,

      'nomor_rekening':
          nomorRekening,

      'nama_pemilik_rekening':
          namaPemilikRekening,

      'is_profile_complete':
          isProfileComplete,
    };
  }
}
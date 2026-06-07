import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/profile_service.dart';

import '../pembeli/pembeli_dashboard.dart';
import '../penjual/penjual_dashboard.dart';

class CompleteProfilePage
    extends StatefulWidget {
  const CompleteProfilePage({
    super.key,
  });

  @override
  State<CompleteProfilePage>
      createState() =>
          _CompleteProfilePageState();
}

class _CompleteProfilePageState
    extends State<CompleteProfilePage> {
  final profileService =
      ProfileService();

  // =========================
  // CONTROLLER
  // =========================

  final namaC =
      TextEditingController();

  final alamatC =
      TextEditingController();

  final noHpC =
      TextEditingController();

  final namaUmkmC =
      TextEditingController();

  final kecamatanC =
      TextEditingController();

  final kabupatenC =
      TextEditingController();

  final danaC =
      TextEditingController();

  final shopeeC =
      TextEditingController();

  final bankC =
      TextEditingController();

  final rekeningC =
      TextEditingController();

  final pemilikRekeningC =
      TextEditingController();

  // =========================

  String kategori = 'FNB';

  String role = '';

  String metodePencairan =
      'DANA';

  bool isLoading = false;

  XFile? image;

  // =========================
  // INIT
  // =========================

  @override
  void initState() {
    super.initState();

    loadRole();
  }

  // =========================
  // LOAD ROLE
  // =========================

  Future<void> loadRole() async {
    final profile =
        await profileService
            .getProfile();

    if (profile != null) {
      setState(() {
        role = profile['role'];
      });
    }
  }

  // =========================
  // PICK IMAGE
  // =========================

  Future<void> pickImage() async {
    final picker = ImagePicker();

    image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {});
  }

  // =========================
  // SAVE PROFILE
  // =========================

  Future<void> saveProfile() async {
    if (namaC.text.isEmpty ||
        alamatC.text.isEmpty ||
        noHpC.text.isEmpty ||
        kecamatanC.text.isEmpty ||
        kabupatenC.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Lengkapi data',
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String imageUrl = '';

      if (image != null) {
        imageUrl =
            await profileService
                .uploadImage(
          image!,
        );
      }

      await profileService
          .completeProfile(
        nama: namaC.text.trim(),

        alamat:
            alamatC.text.trim(),

        noHp: noHpC.text.trim(),

        // seller
        namaUmkm:
            role == 'penjual'
                ? namaUmkmC.text
                    .trim()
                : null,

        kategoriUmkm:
            role == 'penjual'
                ? kategori
                : null,

        // lokasi
        kecamatan:
            kecamatanC.text.trim(),

        kabupaten:
            kabupatenC.text.trim(),

        // pencairan
        metodePencairan:
            role == 'penjual'
                ? metodePencairan
                : null,

        nomorDana:
            metodePencairan ==
                    'DANA'
                ? danaC.text.trim()
                : null,

        nomorShopeepay:
            metodePencairan ==
                    'ShopeePay'
                ? shopeeC.text
                    .trim()
                : null,

        namaBank:
            metodePencairan ==
                    'Bank'
                ? bankC.text.trim()
                : null,

        nomorRekening:
            metodePencairan ==
                    'Bank'
                ? rekeningC.text
                    .trim()
                : null,

        namaPemilikRekening:
            metodePencairan ==
                    'Bank'
                ? pemilikRekeningC
                    .text
                    .trim()
                : null,

        fotoProfile:
            imageUrl,
      );

      if (!mounted) return;

      // =========================
      // REDIRECT
      // =========================

      if (role == 'penjual') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const PenjualDashboard(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const PembeliDashboard(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  // =========================
  // DISPOSE
  // =========================

  @override
  void dispose() {
    namaC.dispose();
    alamatC.dispose();
    noHpC.dispose();

    namaUmkmC.dispose();

    kecamatanC.dispose();
    kabupatenC.dispose();

    danaC.dispose();
    shopeeC.dispose();

    bankC.dispose();
    rekeningC.dispose();
    pemilikRekeningC.dispose();

    super.dispose();
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lengkapi Profile",
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            children: [
              // =========================
              // NAMA
              // =========================

              TextField(
                controller: namaC,

                decoration:
                    const InputDecoration(
                  labelText: 'Nama',
                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // =========================
              // ALAMAT
              // =========================

              TextField(
                controller: alamatC,

                decoration:
                    const InputDecoration(
                  labelText:
                      'Alamat Rumah',
                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // =========================
              // NO HP
              // =========================

              TextField(
                controller: noHpC,

                keyboardType:
                    TextInputType.phone,

                decoration:
                    const InputDecoration(
                  labelText: 'No HP',
                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // =========================
              // KECAMATAN
              // =========================

              TextField(
                controller:
                    kecamatanC,

                decoration:
                    const InputDecoration(
                  labelText:
                      'Kecamatan',
                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // =========================
              // KABUPATEN
              // =========================

              TextField(
                controller:
                    kabupatenC,

                decoration:
                    const InputDecoration(
                  labelText:
                      'Kabupaten',
                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // =========================
              // SELLER ONLY
              // =========================

              if (role == 'penjual') ...[
                TextField(
                  controller:
                      namaUmkmC,

                  decoration:
                      const InputDecoration(
                    labelText:
                        'Nama UMKM',
                    border:
                        OutlineInputBorder(),
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                DropdownButtonFormField<
                    String>(
                  value: kategori,

                  decoration:
                      const InputDecoration(
                    border:
                        OutlineInputBorder(),

                    labelText:
                        'Kategori UMKM',
                  ),

                  items: const [
                    DropdownMenuItem(
                      value: 'FNB',
                      child: Text(
                        'FNB',
                      ),
                    ),

                    DropdownMenuItem(
                      value:
                          'Industri Kreatif',

                      child: Text(
                        'Industri Kreatif',
                      ),
                    ),

                    DropdownMenuItem(
                      value:
                          'Fashion',

                      child: Text(
                        'Fashion',
                      ),
                    ),
                  ],

                  onChanged: (
                    value,
                  ) {
                    setState(() {
                      kategori =
                          value!;
                    });
                  },
                ),

                const SizedBox(
                  height: 15,
                ),

                // =========================
                // METODE PENCAIRAN
                // =========================

                DropdownButtonFormField<
                    String>(
                  value:
                      metodePencairan,

                  decoration:
                      const InputDecoration(
                    border:
                        OutlineInputBorder(),

                    labelText:
                        'Metode Pencairan',
                  ),

                  items: const [
                    DropdownMenuItem(
                      value:
                          'DANA',

                      child: Text(
                        'DANA',
                      ),
                    ),

                    DropdownMenuItem(
                      value:
                          'ShopeePay',

                      child: Text(
                        'ShopeePay',
                      ),
                    ),

                    DropdownMenuItem(
                      value:
                          'Bank',

                      child: Text(
                        'Bank',
                      ),
                    ),
                  ],

                  onChanged: (
                    value,
                  ) {
                    setState(() {
                      metodePencairan =
                          value!;
                    });
                  },
                ),

                const SizedBox(
                  height: 15,
                ),

                // =========================
                // DANA
                // =========================

                if (metodePencairan ==
                    'DANA')
                  TextField(
                    controller: danaC,

                    keyboardType:
                        TextInputType
                            .phone,

                    decoration:
                        const InputDecoration(
                      labelText:
                          'Nomor DANA',

                      border:
                          OutlineInputBorder(),
                    ),
                  ),

                // =========================
                // SHOPEEPAY
                // =========================

                if (metodePencairan ==
                    'ShopeePay')
                  TextField(
                    controller:
                        shopeeC,

                    keyboardType:
                        TextInputType
                            .phone,

                    decoration:
                        const InputDecoration(
                      labelText:
                          'Nomor ShopeePay',

                      border:
                          OutlineInputBorder(),
                    ),
                  ),

                // =========================
                // BANK
                // =========================

                if (metodePencairan ==
                    'Bank')
                  Column(
                    children: [
                      TextField(
                        controller:
                            bankC,

                        decoration:
                            const InputDecoration(
                          labelText:
                              'Nama Bank',

                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      TextField(
                        controller:
                            rekeningC,

                        keyboardType:
                            TextInputType
                                .number,

                        decoration:
                            const InputDecoration(
                          labelText:
                              'Nomor Rekening',

                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      TextField(
                        controller:
                            pemilikRekeningC,

                        decoration:
                            const InputDecoration(
                          labelText:
                              'Nama Pemilik Rekening',

                          border:
                              OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(
                  height: 20,
                ),
              ],

              // =========================
              // IMAGE
              // =========================

              ElevatedButton(
                onPressed:
                    pickImage,

                child: const Text(
                  "Pilih Foto",
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // SAVE
              // =========================

              SizedBox(
                width:
                    double.infinity,

                height: 50,

                child: ElevatedButton(
                  onPressed:
                      isLoading
                          ? null
                          : saveProfile,

                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Simpan Profile",
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}